
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/archive_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/archive_entity.dart';

class AddNewArchive{
  final ArchiveRepository repo;

  AddNewArchive({required this.repo});

  Future<Either<Failure, void>> call(Archive archive) async{
    return await repo.addArchive(archive);
  }
}