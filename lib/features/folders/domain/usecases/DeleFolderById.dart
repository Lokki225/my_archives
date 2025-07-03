
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';

class DeleteFolderById{
  final FolderRepository repo;

  DeleteFolderById({ required this.repo});

  Future<Either<Failure, void>> call(int id){
    return repo.deleteFolder(id);
  }

}