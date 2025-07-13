
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';
import 'package:my_archives/features/home/domain/repositories/archive_repository.dart';

import '../../../../core/constants/constants.dart';

class GetArchives{
  final ArchiveRepository repo;

  GetArchives({required this.repo});

  Future<Either<Failure, List<Archive>>> call(SortingOption sortOption, int userId) async {
    return await repo.getArchives(sortOption, userId);
  }
}