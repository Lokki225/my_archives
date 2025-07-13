
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/home/data/datasources/category_local_datasource.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:my_archives/features/home/domain/repositories/category_repository.dart';

import '../../../../core/error/failures.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository{
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addCategory(Category category) async{
    try{
      final model = CategoryModel.fromEntity(category);
      final id = await localDataSource.addCategory(model);
      return const Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async{
    try{
      await localDataSource.deleteCategory(id);
      return const Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories(SortingOption sort, int userId) async{
    try{
      final categoryModels = await localDataSource.getCategories(sort, userId);
      final List<Category> categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    }catch(e){
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByQuery(String query) async{
    try {
      final categoryModels = await localDataSource.getCategoriesByQuery(query);
      final List<Category> categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) async{
    try{
      final categoryModel = await localDataSource.getCategory(id);
      final category = categoryModel.toEntity();
      return Right(category);
    }
    catch(_){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(int categoryId, String title, String icon) async{
    try{
      await localDataSource.updateCategory(categoryId, title, icon);
      return const Right(null);
    }catch(_){
      return Left(CacheFailure());
    }
  }

}