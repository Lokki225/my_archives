
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/category_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/category_entity.dart';

class AddNewCategory{
  final CategoryRepository repo;

  AddNewCategory({required this.repo});

  Future<Either<Failure, void>> call(Category category) async{
    return await repo.addCategory(category);
  }
}