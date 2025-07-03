
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/repositories/category_repository.dart';

class GetCategories{
  final CategoryRepository repo;

  GetCategories({required this.repo});

  Future<Either<Failure, List<Category>>> call() async{
    return await repo.getCategories();
  }
}