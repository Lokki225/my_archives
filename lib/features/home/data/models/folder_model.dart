
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

import '../../domain/entities/category_entity.dart';

class FolderModel extends Folder
{
    const FolderModel({
      required super.id,
      required super.title,
      required super.color,
      required super.userId,
      required super.relatedCategories,
      required super.createdAt,
      required super.updatedAt
    });

    factory FolderModel.fromJSON(Map<String, dynamic> json){
      return FolderModel(
        id: json['id'] as int,
        title: json['title'] ?? '',
        color: json['color'] ?? '',
        userId: json['userId'] as int,
        relatedCategories: json['relatedCategories'] as List<Category> ?? [],
        createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch
      );
    }

    Map<String, dynamic> toJSON(){
      return {
        'id': id,
        'title': title,
        'color': color,
        'userId': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
    }
}
