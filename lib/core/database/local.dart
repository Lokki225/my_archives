import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:my_archives/features/authentification/data/models/table_change_tracker_model.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';
import 'package:my_archives/features/home/data/models/folder_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/home/data/models/archive_model.dart';
import '../../features/home/data/models/category_model.dart';
import '../../features/home/domain/entities/category_entity.dart';
import '../constants/constants.dart';


Database? _database;

class LocalDatabase
{
    Future<Database?> get database async
    {
        if (_database != null) return _database;

        _database = await _init("/local.db");
        return _database;
    }

    // Insert in TablesChangesTracker
    Future<void> insertInTrackChange({
        required String tableName,
        required int rowId,
        required String status, // 'Created', 'Modified', 'Deleted'
        required int userId,
    }) async {
        final db = await database;
        await db!.insert('TablesChangesTracker', {
            'table_name': tableName,
            'row_id': rowId,
            'status': status,
            'user_id': userId,
            'timestamp': DateTime.now().toIso8601String(),
        });
    }

    // get all tables changes
    Future<List<TableChangeTrackerModel>> getTablesChanges(int userId) async {
        final db = await database;
        final changes = await db!.query(
            'TablesChangesTracker',
            where: 'user_id = ?',
            whereArgs: [userId],
            orderBy: 'timestamp DESC LIMIT 5',
        );

        return changes.map((change) => TableChangeTrackerModel.fromJSON(change)).toList();
    }



    Future<void> copyDatabaseFromAssets() async
    {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'local.db');

        // Only copy if DB doesn't exist
        final exists = await databaseExists(path);
        if (!exists) {
            print("Copying database from assets...");
            // Load from asset
            final data = await rootBundle.load('lib/assets/local.db');
            final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

            // Write to the DB location
            await File(path).writeAsBytes(bytes, flush: true);
            print("Database copied successfully!");
        } else {
            print("Database already exists!");
        }
    }

    Future<void> deleteMyDatabase() async {
        final databasesPath = await getDatabasesPath();
        final path = join(databasesPath, 'local.db'); // Replace with your DB name

        await deleteDatabase(path);
        print("🗑️ Database deleted at path: $path");
    }

    void printDbPath() async {
        final databasesPath = await getDatabasesPath();
        print("📂 DB Path: $databasesPath");
    }

    // Empty all rows from local DB tables (but keep table structure)
    Future<void> emptyTables() async {
        final db = await database;

        // Use a transaction for efficiency and safety
        await db!.transaction((txn) async {
            await txn.delete('User');
            await txn.delete('Folder');
            await txn.delete('Archive');
            await txn.delete('Category');
            await txn.delete('Folder_Category');
            await txn.delete('PinCode');
            // Add more tables here as needed
        });
    }

    String getOrderByClause(SortingOption option) 
    {
        switch (option)
        {
            case SortingOption.lastAddedFirst:
                return 'createdAt DESC';
            case SortingOption.lastUpdatedFirst:
                return 'updatedAt DESC';
            case SortingOption.titleAZ:
                return 'title COLLATE NOCASE ASC'; // case-insensitive sort
            case SortingOption.titleZA:
                return 'title COLLATE NOCASE DESC';
            case SortingOption.all:
                return 'id ASC'; // default order
        }
    }

    Future<Database> _init(String filepath) async
    {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath + filepath);
        return await openDatabase(path, version: 1, onCreate: _createDb);
    }

    Future<void> _createDb(Database db, int version) async
    {
        await db.execute(DB_TABLES);
    }


    // User CRUD Operations on User Table
    Future<int?> insertUser(UserModel user) async
    {
        final db = await database;
        try
        {
            final id = await db!.rawInsert(
                '''
        INSERT INTO User(firstName, lastName, email, password, username, profilePicture, createdAt, updatedAt)
        VALUES(?, ?, ?, ?, ?, ?, ?, ?)
        ''',
                [
                    user.firstName,
                    user.lastName,
                    user.email,
                    user.password,
                    user.username,
                    user.profilePicture,
                    user.createdAt,
                    user.updatedAt,
                ]
            );

            return id;
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting user ID !");
            print("##############################################################");
        }
        return null;
    }

    Future<void> addUserProfilePicture(String path, int userId) async
    {
        final db = await database;

        try
        {
            await db!.update(
                'User',
                {
                    'profilePicture': path,
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                },
                where: 'id = ?',
                whereArgs: [userId],
            );
            print('User profile picture updated successfully: $userId');
        }
        catch(e)
        {
            print('Failed to update user profile picture: $e');
        }
    }

    Future<UserModel?> getUserByEmailOrId(String? email, int? id) async
    {
        final db = await database;
        List<Map<String, dynamic>> maps = [];

        try
        {
            if (email != null) 
            {
                final q = "SELECT * FROM 'User' WHERE email = '$email';";
                maps = await db!.rawQuery(q);
            }

            if (id != null) 
            {
                print("Id : $id");
                maps = await db!.query(
                    'User',
                    where: 'id = ?',
                    whereArgs: [id],
                );
            }

            if (maps.isEmpty) 
            {
                return null;
            }

            final model = UserModel.fromJSON(maps.first).toString();
            print("User Model: $model}");

            return UserModel.fromJSON(maps.first);
        }
        catch (e, stackTrace)
        {
            // Log the error for better debugging
            print("##############################################################");
            print("An error occurred while getting user with email: $email or id: $id!");
            print("Error: $e");
            print("StackTrace: $stackTrace");
            print("##############################################################");
            return null;
        }
    }

    Future<UserModel?> getUserByFirstName(String? firstName) async
    {
        final db = await database;
        try
        {
            List<Map<String, dynamic>> maps = await db!.query(
                'User',
                where: 'firstName = ?',
                whereArgs: [firstName],
            );

            if (maps.isEmpty) 
            {
                return null;
            }

            return UserModel.fromJSON(maps.first);
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting user with firstName: $firstName !");
            print("##############################################################");
        }
        return null;
    }

    Future<List<UserModel>?> getUsers() async
    {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db!.query('User');
        return maps.isNotEmpty ? maps.map((map) => UserModel.fromJSON(map)).toList() : null;
    }

    Future<void> updateUser(UserModel user) async
    {
        final db = await database;

        try
        {
            await db!.update(
                'User',
                {
                    'firstName': user.firstName,
                    'lastName': user.lastName,
                    'email': user.email,
                    'password': user.password,
                    'username': user.username,
                    'profilePicture': user.profilePicture,
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                },
                where: 'id = ?',
                whereArgs: [user.id],
            );
            print('User updated successfully: ${user.id}');
        }
        catch(e)
        {
            print('Failed to update user: $e');
        }
    }

    Future<String?> getUserPinCode(int id) async {
        final db = await database;

        try {
            final maps = await db!.query(
                'PinCode',
                where: 'userId = ?',
                whereArgs: [id],
                columns: ['pin_code'],
            );

            if (maps.isEmpty) {
                print("❗ No pin code found for user ID $id");
                return null;
            }

            final pinCode = maps.first['pin_code'] as String;
            print("Pin code: $pinCode");
            return pinCode;
        } catch (e) {
            print("##############################################################");
            print("An error occurred while getting user pin_code with id: $id !");
            print("Error: $e");
            print("##############################################################");
            return null;
        }
    }

    Future<void> setUserPinCode(int id, String pinCode) async{
        final db = await database;

        try{
            await db!.insert(
                'PinCode',
                {
                    'userId': id,
                    'pin_code': pinCode,
                },
            );
            print('Pin code updated successfully: $id');
        }catch(e){
            print('Failed to update pin code: $e');
        }
    }


    // Operations on Archive Table
    Future<int?> insertArchive(ArchiveModel archive) async
    {
        final db = await database;

        try
        {
            final id = await db!.rawInsert(
                '''
        INSERT INTO Archive(title, description, cover_image, resource_paths, folderId, userId, createdAt, updatedAt)
        VALUES(?, ?, ?, ?, ?, ?, ?, ?)
        ''',
                [
                    archive.title,
                    archive.description,
                    archive.coverImage,
                    jsonEncode(archive.resourcePaths),
                    archive.folderId,
                    archive.userId,
                    archive.createdAt,
                    archive.updatedAt,
                ]
            );

            return id;
        }
        catch(e)
        {
            print("##############################################################");
            print("An error occurred while getting archive ID !\n Error: $e");
            print("##############################################################");
        }
        return null;
    }

    Future<List<ArchiveModel>> getArchives(SortingOption sort, { int id = 12}) async
    {
        try
        {
            final db = await database;
            final String orderBy = getOrderByClause(sort);

            final List<Map<String, dynamic>> maps = await db!.query(
                'Archive',
                orderBy: orderBy,
                columns: [
                    'id',
                    'title',
                    'description',
                    'cover_image',
                    'resource_paths',
                    'userId',
                    'folderId',
                    'createdAt',
                    'updatedAt'
                ],
                where: 'userId = ?',
                whereArgs: [id],
            );

            return maps.isNotEmpty ? maps.map((map) => ArchiveModel.fromJSON(map)).toList() : [];
        }
        catch (e)
        {
            print("##############################################################");
            print("An error occurred while getting archives: $e");
            print("##############################################################");
        }

        return [];
    }

    Future<List<ArchiveModel>> getArchivesByQuery(String query) async
    {
        final db = await database;

        try
        {
            final List<Map<String, dynamic>> maps = await db!.query(
                'Archive',
                where: 'title LIKE ? OR description LIKE ?',
                whereArgs: ['%$query%', '%$query%'],
            );
            return maps.isNotEmpty ? maps.map((map) => ArchiveModel.fromJSON(map)).toList() : [];
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting archives with query: $query !");
            print("##############################################################");
        }
        return [];
    }

    Future<ArchiveModel?> getArchive(int id) async
    {
        final db = await database;

        try
        {
            final maps = await db!.query(
                'Archive',
                where: 'id = ?',
                whereArgs: [id],
            );
            if (maps.isEmpty) 
            {
                return null;
            }
            return ArchiveModel.fromJSON(maps.first);
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting archive with id: $id !");
            print("##############################################################");
        }
        return null;
    }

    Future<void> updateArchive(ArchiveModel archive) async
    {
        final db = await database;

        try
        {
            await db!.update(
                'Archive',
                {
                    'title': archive.title,
                    'description': archive.description,
                    'cover_image': archive.coverImage,
                    'folderId': archive.folderId,
                    'userId': archive.userId,
                    'resource_paths': jsonEncode(archive.resourcePaths),
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                },
                where: 'id = ?',
                whereArgs: [archive.id],
            );
            print('Archive updated successfully: ${archive.id}');
        }
        catch(e)
        {
            print('Failed to update archive: $e');
        }
    }

    Future<void> deleteArchive(int id) async
    {
        final db = await database;

        try
        {
            await db!.delete(
                'Archive',
                where: 'id = ?',
                whereArgs: [id],
            );

            print("Archive with id: $id deleted successfully !");
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while deleting archive with id: $id !");
            print("##############################################################");
        }
    }

    Future<void> deleteAllArchives() async
    {
        final db = await database;

        try
        {
            await db!.delete('Archive');
            print("All archives deleted successfully !");
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while deleting all archives !");
            print("##############################################################");
        }
    }


    // Operations on Folder Table
    Future<int?> insertFolder(FolderModel folder) async
    {
        final db = await database;

        try
        {
            final id = await db!.rawInsert(
                '''
        INSERT INTO Folder(title, color, userId, createdAt, updatedAt)
        VALUES(?, ?, ?, ?, ?)
        ''',
                [
                    folder.title,
                    folder.color,
                    folder.userId,
                    folder.createdAt,
                    folder.updatedAt,
                ]
            );
            return id;
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting folder ID !");
            print("##############################################################");

        }
        return null;
    }

    Future<void> addFolderRelatedCategories(int folderId, List<CategoryModel> categories) async
    {
        final db = await database;

        try
        {
            for (final category in categories)
            {
                await db!.insert(
                    'Folder_Category',
                    {
                        'folderId': folderId,
                        'categoryId': category.id,
                    },
                );
            }
            print('Folder categories added successfully: $folderId');
        }
        catch(e)
        {
            print('Failed to add folder categories: $e');
        }
    }

    Future<List<FolderModel>> getFolders(SortingOption sort, {int id = 12}) async {
        final String orderBy = getOrderByClause(sort);
        final db = await database;

        final List<Map<String, dynamic>> maps = await db!.query(
            'Folder',
            columns: ['id', 'title', 'color', 'userId', 'createdAt', 'updatedAt'],
            orderBy: orderBy,
            where: 'userId = ?',
            whereArgs: [id],
        );

        // Convert the maps to a new map with the related categories
        List<Map<String, dynamic>> newMap = [];

        for (final map in maps) {
            final categories = await getFolderCategories(map['id']);
            final nMap = {
                'id': map['id'],
                'title': map['title'],
                'color': map['color'],
                'userId': map['userId'],
                'relatedCategories': categories,
                'createdAt': map['createdAt'],
                'updatedAt': map['updatedAt'],
            };
            newMap.add(nMap);
        }

        return maps.isNotEmpty
            ? newMap.map((map) => FolderModel.fromJSON(map)).toList()
            : [];
    }


    Future<List<FolderModel>> getFoldersByQuery(String query) async
    {
        final db = await database;

        try
        {
            final List<Map<String, dynamic>> maps = await db!.query(
                'Folder',
                where: 'title LIKE ?',
                whereArgs: ['%$query%'],
            );
            return maps.isNotEmpty ? maps.map((map) => FolderModel.fromJSON(map)).toList() : [];
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting folders with query: $query !");
            print("##############################################################");
        }
        return [];
    }

    Future<List<ArchiveModel>> getFolderRelatedArchives(int folderId) async
    {
        final db = await database;

        try
        {
            final List<Map<String, dynamic>> maps = await db!.query(
                'Archive',
                where: 'folderId = ?',
                whereArgs: [folderId],
                columns: [
                    'id',
                    'title',
                    'description',
                    'cover_image',
                    'resource_paths',
                    'userId',
                    'folderId',
                    'createdAt',
                    'updatedAt'
                ],
            );
            return maps.isNotEmpty ? maps.map((map) => ArchiveModel.fromJSON(map)).toList() : [];
        }
        catch(_){
            print("##############################################################");
            print("An error occurred while getting related folders for folder with id: $folderId !");
            print("##############################################################");
        }
        return [];
    }

    Future<List<CategoryModel>> getFolderCategories(int folderId) async
    {
        final db = await database;

        final maps = await db!.rawQuery(
            '''
              SELECT Category.*
              FROM Category
              INNER JOIN Folder_Category ON Category.id = Folder_Category.categoryId
              WHERE Folder_Category.folderId = ?
            ''',
            [folderId],
        );

        return maps.map((map) => CategoryModel.fromJSON(map)).toList();
    }


    Future<FolderModel?> getFolder(int id) async
    {
        final db = await database;

        try
        {
            final maps = await db!.query(
                'Folder',
                where: 'id = ?',
                whereArgs: [id],
            );
            if (maps.isEmpty) 
            {
                return null;
            }
            return FolderModel.fromJSON(maps.first);
        }
        catch (_)
        {
            print("##############################################################");
            print("An error occurred while getting folder with id: $id !");
            print("##############################################################");
        }
        return null;
    }

    Future<void> updateFolder({
        required int folderId,
        required String title,
        required String color,
    }) async
    {
        final db = await database;

        try
        {
            // Update the folder in the database
            await db!.update(
                'Folder', // Table name
                {
                    'title': title,
                    'color': color,
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                },
                where: 'id = ?',
                whereArgs: [folderId],
            );

            print('Folder updated successfully: $folderId');
        }
        catch (e)
        {
            print('Failed to update folder: $e');
        }
    }

    Future<void> deleteFolder(int id) async
    {
        final db = await database;

        try
        {
            await db!.delete(
                'Folder',
                where: 'id = ?',
                whereArgs: [id],
            );

            print("Folder with id: $id deleted successfully !");
        }
        catch (_)
        {
            print("##############################################################");
            print("An error occurred while deleting folder with id: $id !");
            print("##############################################################");
        }
    }

    // Operations on Category Table
    Future<int?> insertCategory(CategoryModel category) async
    {
        final db = await database;
        try
        {
            final id = await db!.rawInsert(
                '''
        INSERT INTO Category(title, icon, userId, createdAt, updatedAt)
        VALUES(?, ?, ?, ?, ?)
        ''',
                [
                    category.title,
                    category.icon,
                    category.userId,
                    category.createdAt,
                    category.updatedAt,
                ]
            );
            return id;
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting category ID !");
            print("##############################################################");
        }
        return null;
    }

    Future<CategoryModel?> getCategory(int id) async
    {
        final db = await database;

        try
        {
            final maps = await db!.query(
                'Category',
                where: 'id = ?',
                whereArgs: [id],
            );

            if (maps.isEmpty) 
            {
                return null;
            }
            return CategoryModel.fromJSON(maps.first);
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting category with id: $id !");
            print("##############################################################");
        }
        return null;
    }

    Future<List<CategoryModel>> getCategories(SortingOption sort, {int id = 12}) async
    {
        final String orderBy = getOrderByClause(sort);
        final db = await database;
        final List<Map<String, dynamic>> maps = await db!.query('Category', orderBy: orderBy, where: 'userId = ?', whereArgs: [id]);

        return maps.isNotEmpty ? maps.map((map) => CategoryModel.fromJSON(map)).toList() : [];
    }

    Future<List<CategoryModel>> getCategoriesByQuery(String query) async
    {
        final db = await database;
        try
        {
            final List<Map<String, dynamic>> maps = await db!.query(
                'Category',
                where: 'title LIKE ?',
                whereArgs: ['%$query%'],
            );

            return maps.isNotEmpty ? maps.map((map) => CategoryModel.fromJSON(map)).toList() : [];
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while getting categories with query: $query !");
            print("##############################################################");
        }
        return [];
    }

    Future<void> updateCategory(int categoryId, String title, String icon) async
    {
        final db = await database;

        try
        {
            await db!.update(
                'Category',
                {
                    'title': title,
                    'icon': icon,
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                },
                where: 'id = ?',
                whereArgs: [categoryId],
            );
            print('Category updated successfully: $categoryId');
        }
        catch(e)
        {
            print('Failed to update category: $e');
        }
    }

    Future<void> deleteCategory(int id) async
    {
        final db = await database;

        try
        {
            await db!.delete(
                'Category',
                where: 'id = ?',
                whereArgs: [id],
            );

            print("Category with id: $id deleted successfully !");
        }
        catch(_)
        {
            print("##############################################################");
            print("An error occurred while deleting category with id: $id !");
            print("##############################################################");
        }
    }
}

