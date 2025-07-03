
import 'package:equatable/equatable.dart';
import 'package:my_archives/features/home/data/models/archive_model.dart';

class Archive extends Equatable{
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final List<String> resourcePaths;
  final int userId;
  final int folderId;
  final int createdAt;
  final int updatedAt;

  const Archive({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.resourcePaths,
    required this.userId,
    required this.folderId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, title, description, coverImage, resourcePaths, userId, folderId, createdAt, updatedAt];

  ArchiveModel toModel() => ArchiveModel(
    id: id,
    title: title,
    description: description,
    coverImage: coverImage,
    resourcePaths: resourcePaths,
    userId: userId,
    folderId: folderId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}