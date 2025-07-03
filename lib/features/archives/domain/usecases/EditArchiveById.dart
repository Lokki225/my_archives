
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/repositories/archive_repository.dart';

class EditArchiveById{
  final ArchiveRepository repo;

  EditArchiveById({required this.repo});

  Future<Either<Failure, void>> call(Archive archive){
    return repo.updateArchive(archive);
  }

}