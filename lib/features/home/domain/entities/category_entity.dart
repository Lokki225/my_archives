
import 'package:equatable/equatable.dart';
import 'package:my_archives/features/home/data/models/category_model.dart';

class Category extends Equatable{
  final int id;
  final String title;
  final String icon;
  final int userId;
  final int createdAt;
  final int updatedAt;

  const Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, icon, userId, createdAt, updatedAt];


  CategoryModel toModel(){
    return CategoryModel(id: id, title: title, icon: icon, userId: userId, createdAt: createdAt, updatedAt: updatedAt);
  }

}