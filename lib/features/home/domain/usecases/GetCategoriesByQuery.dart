
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:my_archives/features/home/domain/repositories/category_repository.dart';

import '../../../../core/error/failures.dart';

class GetCategoriesByQuery{
  final CategoryRepository repo;

  GetCategoriesByQuery({required this.repo});

  Future<Either<Failure, List<Category>>> call(String query){
    return repo.getCategoriesByQuery(query);
  }
}