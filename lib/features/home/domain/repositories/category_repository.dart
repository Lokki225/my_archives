
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository{
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Category>>> getCategoriesByQuery(String query);
  Future<Either<Failure, Category>> getCategory(int id);
  Future<Either<Failure, void>> addCategory(Category category);
  Future<Either<Failure, void>> updateCategory(int categoryId, String title, String icon);
  Future<Either<Failure, void>> deleteCategory(int id);
}