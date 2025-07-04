
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/category_entity.dart';

class GetFolderRelatedCategories{
  final FolderRepository repo;

  GetFolderRelatedCategories({required this.repo});

  Future<Either<Failure, List<Category>>> call(int folderId) {
    return repo.getFolderRelatedCategories(folderId);
  }

}