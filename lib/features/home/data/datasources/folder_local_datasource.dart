
import 'package:my_archives/features/home/data/models/archive_model.dart';

import '../../../../core/database/local.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/folder_model.dart';

abstract class FolderLocalDataSource{
  Future<List<FolderModel>> getFolders();
  Future<List<FolderModel>> getFoldersByQuery(String query);
  Future<List<ArchiveModel>> getFolderRelatedArchives(int folderId);
  Future<List<CategoryModel>> getFolderRelatedCategories(int folderId);
  Future<FolderModel?> getFolder(int id);
  Future<int> addFolder(FolderModel folder);
  Future<void> updateFolder(int folderId, String title, String color);
  Future<void> deleteFolder(int id);
}

class FolderLocalDataSourceImpl implements FolderLocalDataSource{
  final LocalDatabase localDb;
  
  FolderLocalDataSourceImpl({required this.localDb});

  @override
  Future<int> addFolder(FolderModel folder) async{
    try {
      final folderId = await localDb.insertFolder(folder);
      if (folderId == null) {
        throw CacheException();
      }

      return folderId;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteFolder(int id) async{
    try {
      await localDb.deleteFolder(id);
      return;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<FolderModel?> getFolder(int id) async{
    try {
      final folder = await localDb.getFolder(id);
      if (folder != null) {
        return folder;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<FolderModel>> getFolders() async{
    try {
      final folders = await localDb.getFolders();
      return folders;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateFolder(int folderId, String title, String color) async{
    try {
      await localDb.updateFolder(folderId: folderId, title: title, color: color);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<FolderModel>> getFoldersByQuery(String query) async{
    try {
      final folders = await localDb.getFoldersByQuery(query);
      return folders;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ArchiveModel>> getFolderRelatedArchives(int folderId) async{
    try{
      final archives = await localDb.getFolderRelatedArchives(folderId);
      return archives;
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<List<CategoryModel>> getFolderRelatedCategories(int folderId) async{
    try{
      final categories = await localDb.getFolderCategories(folderId);
      return categories;
    }catch(_){
      throw CacheException();
    }
  }
}