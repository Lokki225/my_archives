
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/category_repository.dart';

import '../../../../core/error/failures.dart';

class EditCategory{
  final CategoryRepository repo;

  EditCategory({required this.repo});

  Future<Either<Failure, void>> call(int categoryId, String title, String icon) async {
    return await repo.updateCategory(categoryId, title, icon);
  }
}