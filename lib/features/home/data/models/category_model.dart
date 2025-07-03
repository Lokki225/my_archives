

import '../../domain/entities/category_entity.dart';

class CategoryModel extends Category{
  const CategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromJSON(Map<String, dynamic> json){
    return CategoryModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      userId: json['userId'] as int,
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory CategoryModel.fromEntity(Category category){
    return CategoryModel(
      id: category.id,
      title: category.title,
      icon: category.icon,
      userId: category.userId,
        createdAt: category.createdAt,
      updatedAt: category.updatedAt
    );
  }

  Category toEntity(){
    return Category(
      id: id,
      title: title,
      icon: icon,
      userId: userId,
        createdAt: createdAt,
      updatedAt: updatedAt
    );
  }
}