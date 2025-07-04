part of 'folder_bloc.dart';

@immutable
sealed class FolderState {}

final class FolderInitial extends FolderState {}

final class FolderLoading extends FolderState {}

final class FolderCreated extends FolderState {}

final class FolderEdited extends FolderState {}

final class FolderLoaded extends FolderState {
  final List<Folder> folders;

  FolderLoaded(this.folders);
}

final class FolderDetailsLoaded extends FolderState {
  final List<Archive> archives;
  final List<Category> categories;

  FolderDetailsLoaded({required this.archives, required this.categories});
}

final class FolderDeleted extends FolderState {}

final class FolderError extends FolderState {
  final String error;

  FolderError(this.error);
}

