
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/category_entity.dart';

class AddFolderRelatedCategories {
  final FolderRepository repo;

  AddFolderRelatedCategories({required this.repo});


  Future<Either<Failure, void>> call(int folderId, List<Category> categories) async{
    return await repo.addFolderRelatedCategories(folderId, categories);
  }
}