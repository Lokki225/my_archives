
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/archive_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/archive_entity.dart';

class GetArchiveById{
  final ArchiveRepository repo;

  GetArchiveById({required this.repo});

  Future<Either<Failure, Archive>> call(int id) async{
    return await repo.getArchive(id);
  }
}