
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/folder_entity.dart';

class AddNewFolder{
  final FolderRepository repo;

  AddNewFolder({required this.repo});

  Future<Either<Failure, int>> call(Folder folder){
    return repo.addFolder(folder);
  }
}