
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/constants/constants.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/repositories/category_repository.dart';

class GetCategories{
  final CategoryRepository repo;

  GetCategories({required this.repo});

  Future<Either<Failure, List<Category>>> call(SortingOption sort, int userId) async{
    return await repo.getCategories(sort, userId);
  }
}