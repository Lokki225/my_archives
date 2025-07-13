
import 'package:my_archives/core/constants/constants.dart';

import '../../../../core/database/local.dart';
import '../../../../core/error/exceptions.dart';
import '../models/archive_model.dart';

abstract class ArchiveLocalDataSource{
  Future<List<ArchiveModel>> getArchives(SortingOption sortOption, int userId);

  Future<List<ArchiveModel>> getArchivesByQuery(String query);
  
  Future<ArchiveModel?> getArchive(int id);
  
  Future<void> addArchive(ArchiveModel archive);
  
  Future<void> updateArchive(ArchiveModel archive);

  Future<void> deleteArchive(int id);
}

class ArchiveLocalDataSourceImpl implements ArchiveLocalDataSource{
  final LocalDatabase localDb;

  ArchiveLocalDataSourceImpl({required this.localDb});

  @override
  Future<void> addArchive(ArchiveModel archive) async{
    try {
      await localDb.insertArchive(archive);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ArchiveModel?> getArchive(int id) async{
    try {
      final archive = await localDb.getArchive(id);
      if (archive != null) {
        return archive;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ArchiveModel>> getArchives(SortingOption sortOption, int userId) async{
    try {
      final archives = await localDb.getArchives(sortOption, id: userId);
      return archives;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateArchive(ArchiveModel archive) async{
    try{
      await localDb.updateArchive(archive);
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<void> deleteArchive(int id) async{
    try{
      await localDb.deleteArchive(id);
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<List<ArchiveModel>> getArchivesByQuery(String query) async{
    try{
      final archives = await localDb.getArchivesByQuery(query);
      return archives;
    }catch(_){
      throw CacheException();
    }
  }
  
}