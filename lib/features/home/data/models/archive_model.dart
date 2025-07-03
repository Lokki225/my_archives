
import 'dart:convert';

import 'package:my_archives/features/home/domain/entities/archive_entity.dart';

class ArchiveModel extends Archive{
  const ArchiveModel({
    required super.id,
    required super.title,
    required super.description,
    required super.coverImage,
    required super.resourcePaths,
    required super.userId,
    required super.folderId,
    required super.createdAt,
    required super.updatedAt
  });

  factory ArchiveModel.fromJSON(Map<String, dynamic> json){
    final List<String> resourcePaths = json['resource_paths'].isEmpty ? [] : List<String>.from(jsonDecode(json['resource_paths']));

    return ArchiveModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['cover_image'] ?? '',
      resourcePaths: resourcePaths,
      userId: json['userId'] as int,
      folderId: json['folderId'] as int,
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover_image': coverImage,
      'resource_paths': jsonEncode(resourcePaths),
      'userId': userId,
      'folderId': folderId,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  //To Entity
  Archive toEntity(){
    return Archive(
      id: id,
      title: title,
      description: description,
      coverImage: coverImage,
      resourcePaths: resourcePaths,
        userId: userId,
      folderId: folderId,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  // From Entity
  factory ArchiveModel.fromEntity(Archive archive){
    return ArchiveModel(
      id: archive.id,
      title: archive.title,
      description: archive.description,
      coverImage: archive.coverImage,
      resourcePaths: archive.resourcePaths,
      userId: archive.userId,
      folderId: archive.folderId,
        createdAt: archive.createdAt,
      updatedAt: archive.updatedAt
    );
  }
}