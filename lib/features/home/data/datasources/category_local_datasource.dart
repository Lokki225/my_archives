
import 'package:my_archives/features/home/data/models/category_model.dart';

import '../../../../core/database/local.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/category_entity.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>?> getCategoriesByQuery(String query);
  Future<CategoryModel> getCategory(int id);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(int categoryId, String title, String icon);
  Future<void> deleteCategory(int id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource{
  final LocalDatabase localDb;
  
  CategoryLocalDataSourceImpl({required this.localDb});
  
  @override
  Future<void> addCategory(Category category) async{
    try{
      final model = CategoryModel.fromEntity(category);
      final id = await localDb.insertCategory(model);

      if(id == null){
        throw CacheException();
      }
      return;
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCategory(int id) async{
    try{
      await localDb.deleteCategory(id);
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async{
    try{
      final categories = await localDb.getCategories();

      if(categories!.isNotEmpty){
        return categories;
      }
      return [];
    }catch(_){
      throw CacheException();
    }
  }

  @override
  Future<List<CategoryModel>?> getCategoriesByQuery(String query) async{
    try {
      final categories = await localDb.getCategoriesByQuery(query);
      if (categories!.isNotEmpty) {
        return categories;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<CategoryModel> getCategory(int id) {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(int categoryId, String title, String icon) async{
    try{
      await localDb.updateCategory(categoryId, title, icon);
    }catch(_){
      throw CacheException();
    }
  }
  
}