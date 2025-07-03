
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/repositories/archive_repository.dart';

class DeleteArchiveById{
  final ArchiveRepository repo;

  DeleteArchiveById({required this.repo});

  Future<Either<Failure, void>> call(int archiveId){
    return repo.deleteArchive(archiveId);
  }

}