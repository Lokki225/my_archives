
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/repositories/category_repository.dart';

class DeleteCategory{
  final CategoryRepository repo;

  DeleteCategory({required this.repo});

  Future<Either<Failure, void>> call(int id) async{
    return await repo.deleteCategory(id);
  }
}