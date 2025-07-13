import 'package:my_archives/core/database/local.dart';
import 'package:faker/faker.dart';

class DatabaseSeeder {
  final LocalDatabase localDatabase;
  final faker = Faker();

  DatabaseSeeder(this.localDatabase);

  Future<void> seedArchives() async {
    final db = await localDatabase.database;
    // await db!.execute('''
    //   CREATE TABLE Archive (
    //   id INTEGER PRIMARY KEY AUTOINCREMENT,
    //   userId INTEGER NOT NULL,
    //   folderId INTEGER NOT NULL,
    //   title TEXT NOT NULL,
    //   description TEXT NOT NULL,
    //   cover_image TEXT NOT NULL,
    //   resource_paths TEXT NOT NULL,
    //   createdAt INTEGER NOT NULL,
    //   updatedAt INTEGER NOT NULL,
    //   FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE,
    //   FOREIGN KEY (folderId) REFERENCES Folder (id) ON DELETE SET NULL
    //  );
    // ''');

    final List<Map<String, dynamic>> archives = List.generate(15, (index) {
      return {
        'title': faker.lorem.words(1).join(' '),
        'userId': faker.randomGenerator.integer(10),
        'folderId': faker.randomGenerator.integer(10),
        'description': faker.lorem.sentences(2).join(' '),
        'cover_image': faker.image.loremPicsum(
          width: 500,
          height: 500,
        ),
        'resource_paths': faker.lorem.words(5).map((word) => 'path/to/$word').toList().toString(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
    });

    for (var archive in archives) {
      await db!.rawInsert(
          '''
        INSERT INTO Archive(title, userId, folderId, description, cover_image, resource_paths, createdAt, updatedAt)
        VALUES(?, ?, ?, ?, ?, ?, ?, ?)
        ''',
          [
            archive['title'],
            archive['userId'],
            archive['folderId'],
            archive['description'],
            archive['cover_image'],
            archive['resource_paths'],
            archive['createdAt'],
            archive['updatedAt'],
          ]
      );
    }

  }

  Future<void> seedFolders() async {
    final db = await localDatabase.database;

    // Uncomment and modify the CREATE TABLE statement if necessary
//     await db!.execute('''
//       CREATE TABLE Folder (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       userId INTEGER NOT NULL,
//       title TEXT NOT NULL,
//       color TEXT NOT NULL,
//       createdAt INTEGER NOT NULL,
//       updatedAt INTEGER NOT NULL,
//       FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
// );
//     ''');

    final List<Map<String, dynamic>> folders = List.generate(5, (index) {
      return {
        'title': faker.lorem.word(),
        'userId': faker.randomGenerator.integer(10),
        'color': faker.color.color(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
    });

    for (var folder in folders) {
      await db!.rawInsert(
        '''
      INSERT INTO Folder(title, userId, color, createdAt, updatedAt)
      VALUES(?, ?, ?, ?, ?)
      ''',
        [
          folder['title'],
          folder['userId'],
          folder['color'],
          folder['createdAt'],
          folder['updatedAt'],
        ],
      );
    }

  }

  Future<void> seedCategories() async {
    final db = await localDatabase.database;

    // Uncomment and modify the CREATE TABLE statement if necessary
    await db!.execute('''
    CREATE TABLE Category (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      title TEXT NOT NULL,
      icon TEXT NOT NULL,
      createdAt INTEGER NOT NULL,
      updatedAt INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
    );
    ''');

    final List<Map<String, dynamic>> categories = List.generate(5, (index) {
      return {
        'title': faker.lorem.word(),
        'userId': faker.randomGenerator.integer(10, min: 1), // Assuming user IDs are 1 to 10
        'icon': faker.image.loremPicsum(width: 50, height: 50),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
    });

    for (var category in categories) {
      await db.rawInsert(
        '''
      INSERT INTO Category(title, userId, icon, createdAt, updatedAt)
      VALUES(?, ?, ?, ?, ?)
      ''',
        [
          category['title'],
          category['userId'],
          category['icon'],
          category['createdAt'],
          category['updatedAt'],
        ],
      );
    }

  }

  Future<void> seedPinCode(int userId) async {
    // final db = await localDatabase.database;

    // await db!.execute('''
    //   CREATE TABLE PinCode (
    //   userId INTEGER NOT NULL,
    //   pin_code TEXT NOT NULL,
    //   FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
    //   );
    // ''');

    final pinCode = "2001";

    try{
      await localDatabase.setUserPinCode(3, pinCode);
      // print('Pin code seeded successfully!');
    }catch(e){
      // print('Error seeding pin code: $e');
    }
  }

  Future<void> seedFolderCategory() async {
    final db = await localDatabase.database;

    // await db!.execute('''
    //   CREATE TABLE Folder_Category (
    //     folderId INTEGER NOT NULL,
    //     categoryId INTEGER NOT NULL,
    //     PRIMARY KEY (folderId, categoryId),
    //     FOREIGN KEY (folderId) REFERENCES Folder (id) ON DELETE CASCADE,
    //     FOREIGN KEY (categoryId) REFERENCES Category (id) ON DELETE CASCADE
    // );
    // ''');

    final List<Map<String, dynamic>> folderCategories = List.generate(5, (index) {
      return {
        'folderId': faker.randomGenerator.integer(5, min: 1),
        'categoryId': faker.randomGenerator.integer(10, min: 1), // Assuming Category IDs are 1 to 10
      };
    });

    for (var category in folderCategories) {
      await db!.rawInsert(
        '''
      INSERT INTO Folder_Category(folderId, categoryId)
      VALUES(?, ?)
      ''',
        [
          category['folderId'],
          category['categoryId'],
        ],
      );
    }
  }

  // Seed TablesChangesTracker
  Future<void> seedTablesChangesTracker() async {
    final db = await localDatabase.database;

    final List<String> tables = ['Folder', 'Archive', 'Category'];
    final List<String> statuses = ['Created', 'Modified', 'Deleted'];

    // await db!.execute('''
    //   CREATE TABLE TablesChangesTracker (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     table_name TEXT NOT NULL,
    //     row_id INTEGER NOT NULL,
    //     status TEXT CHECK(status IN ('Created', 'Modified', 'Deleted')) NOT NULL,
    //     user_id INTEGER NOT NULL,
    //     timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    //   );
    // ''');

    final List<Map<String, dynamic>> tablesChanges = List.generate(5, (index) {
      return {
        'table_name': tables[faker.randomGenerator.integer(tables.length)],
        'row_id': faker.randomGenerator.integer(10),
        'status': statuses[faker.randomGenerator.integer(statuses.length)],
        'user_id': 3,
        'timestamp': DateTime.now().toIso8601String(),
      };
    });

    for (var tableChange in tablesChanges) {
      await db!.rawInsert(
        '''
      INSERT INTO TablesChangesTracker(table_name, row_id, status, user_id, timestamp)
      VALUES(?, ?, ?, ?, ?)
      ''',
        [
          tableChange['table_name'],
          tableChange['row_id'],
          tableChange['status'],
          tableChange['user_id'],
          tableChange['timestamp'],
        ],
      );
    }
  }
}
