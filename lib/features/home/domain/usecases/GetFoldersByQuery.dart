
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../entities/folder_entity.dart';

class GetFoldersByQuery{
  final FolderRepository repo;

  GetFoldersByQuery({required this.repo});

  Future<Either<Failure, List<Folder>>> call(String query) async {
    return await repo.getFoldersByQuery(query);
  }

}