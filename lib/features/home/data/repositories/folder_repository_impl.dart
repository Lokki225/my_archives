
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/data/models/folder_model.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/archive_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/folder_local_datasource.dart';

class FolderRepositoryImpl implements FolderRepository{
  final FolderLocalDataSource localDataSource;

  FolderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> addFolder(Folder folder) async{
    final folderModel = FolderModel(id: folder.id, title: folder.title, color: folder.color, userId: folder.userId, relatedCategories: folder.relatedCategories, createdAt: folder.createdAt, updatedAt: folder.updatedAt);
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
  Future<Either<Failure, List<Folder>>> getFolders(SortingOption sortOption, int userId) async{
    try {
      final folders = await localDataSource.getFolders(sortOption, userId);
      return Right(folders);
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
      return Right(folders);
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Archive>>> getFolderRelatedArchives(int folderId) async{
    try{
      final archives = await localDataSource.getFolderRelatedArchives(folderId);
      return Right(archives);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getFolderRelatedCategories(int folderId) async{
    try{
      final categories = await localDataSource.getFolderRelatedCategories(folderId);
      return Right(categories.cast<Category>());
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addFolderRelatedCategories(int folderId, List<Category> categories) async{
    try{
      final categoryModels = categories.map((category) => category.toModel()).toList();
      localDataSource.addFolderRelatedCategories(folderId, categoryModels);
      return Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }
  
}