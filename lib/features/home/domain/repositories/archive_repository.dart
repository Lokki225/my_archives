
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/constants/constants.dart';

import '../../../../core/error/failures.dart';
import '../entities/archive_entity.dart';

abstract class ArchiveRepository{
  Future<Either<Failure, Archive>> getArchive(int id);
  Future<Either<Failure, List<Archive>>> getArchives(SortingOption sortOption);
  Future<Either<Failure, List<Archive>>> getArchivesByQuery(String query);
  Future<Either<Failure, void>> addArchive(Archive archive);
  Future<Either<Failure, void>> updateArchive(Archive archive);
  Future<Either<Failure, void>> deleteArchive(int id);

}