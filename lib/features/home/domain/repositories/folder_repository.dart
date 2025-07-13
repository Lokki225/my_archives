
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/folder_entity.dart';

abstract class FolderRepository{
  Future<Either<Failure, List<Folder>>> getFolders(SortingOption sortOption, int userId);
  Future<Either<Failure, List<Folder>>> getFoldersByQuery(String query);
  Future<Either<Failure, List<Archive>>> getFolderRelatedArchives(int folderId);
  Future<Either<Failure, List<Category>>> getFolderRelatedCategories(int folderId);
  Future<Either<Failure, Folder>> getFolder(int id);
  Future<Either<Failure, int>> addFolder(Folder folder);
  Future<Either<Failure, void>> addFolderRelatedCategories(int folderId, List<Category> categories);
  Future<Either<Failure, void>> updateFolder(int folderId, String title, String color);
  Future<Either<Failure, void>> deleteFolder(int id);
}