
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/data/models/folder_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/archive_entity.dart';
import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/folder_local_datasource.dart';

class FolderRepositoryImpl implements FolderRepository{
  final FolderLocalDataSource localDataSource;

  FolderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> addFolder(Folder folder) async{
    final folderModel = FolderModel(id: folder.id, title: folder.title, color: folder.color, userId: folder.userId, createdAt: folder.createdAt, updatedAt: folder.updatedAt);
    try{
      final folderId = await localDataSource.addFolder(folderModel);

      return Right(folderId);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteFolder(int id) async{
    try{
      await localDataSource.deleteFolder(id);
      return Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Folder>> getFolder(int id) async{
    try {
      final folder = await localDataSource.getFolder(id);
      if (folder != null) {
        return Right(folder); // Return the cached user.
      }
      return Left(CacheFailure()); // No user cached.
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Folder>>> getFolders() async{
    try {
      final folders = await localDataSource.getFolders();
      if (folders!.isNotEmpty) {
        return Right(folders); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, void>> updateFolder(int folderId, String title, String color) async{
    try {
      await localDataSource.updateFolder(folderId, title, color);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Folder>>> getFoldersByQuery(String query) async{
    try {
      final folders = await localDataSource.getFoldersByQuery(query);
      if (folders!.isNotEmpty) {
        return Right(folders); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Archive>>> getRelatedFolders(int folderId) async{
    try{
      final archives = await localDataSource.getRelatedFolders(folderId);
      if(archives!.isNotEmpty){
        return Right(archives);
      }else {
        return Left(CacheFailure());
      }
    }catch(_){
      return Left(CacheFailure());
    }
  }
  
}