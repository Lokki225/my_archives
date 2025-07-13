
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';
import 'package:my_archives/features/home/domain/repositories/archive_repository.dart';

import '../../../../core/constants/constants.dart';
import '../datasources/archive_local_datasource.dart';

class ArchiveRepositoryImpl implements ArchiveRepository{
  final ArchiveLocalDataSource localDataSource;

  ArchiveRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addArchive(Archive archive) async{
    try{
      await localDataSource.addArchive(archive.toModel());
      return Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteArchive(int id) async{
    try{
      await localDataSource.deleteArchive(id);
      return Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Archive>> getArchive(int id) async{
    try{
      final archiveModel = await localDataSource.getArchive(id);
      if (archiveModel != null) {
        return Right(archiveModel.toEntity()); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    }catch(_) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Archive>>> getArchives(SortingOption sortOption, int userId) async{
    try {
      final archives = await localDataSource.getArchives(sortOption, userId);
      return Right(archives.map((archive) => archive.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, void>> updateArchive(Archive archive) async{
    try{
      await localDataSource.updateArchive(archive.toModel());
      return Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Archive>>> getArchivesByQuery(String query) async{
    try{
      final archivesModel = await localDataSource.getArchivesByQuery(query);
      final List<Archive> archives = archivesModel.map((archive) => archive.toEntity()).toList();
      return Right(archives);
    }catch(_) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

}