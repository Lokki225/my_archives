
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';
import 'package:my_archives/features/home/domain/repositories/archive_repository.dart';

class GetArchivesByQuery {
  final ArchiveRepository repository;

  GetArchivesByQuery({required this.repository});

  Future<Either<Failure, List<Archive>>> call(String query){
    return repository.getArchivesByQuery(query);
  }
}