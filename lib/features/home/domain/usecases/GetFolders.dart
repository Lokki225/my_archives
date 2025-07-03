
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/folder_repository.dart';

class GetFolders{
  final FolderRepository repo;

  GetFolders({required this.repo});

  Future<Either<Failure, List<Folder>>> call() async {
    return await repo.getFolders();
  }
}