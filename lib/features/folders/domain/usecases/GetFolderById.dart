
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/folder_entity.dart';

class GetFolderById{
  final FolderRepository repo;

  GetFolderById(this.repo);

  Future<Either<Failure, Folder>> call(int id) async{
    return await repo.getFolder(id);
  }
}