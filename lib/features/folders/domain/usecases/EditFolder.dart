
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';

class EditFolder {
  final FolderRepository repo;

  EditFolder({required this.repo});

  Future<Either<Failure, void>> call(int folderId, String title, String color){
    return repo.updateFolder(folderId, title, color);
  }
}