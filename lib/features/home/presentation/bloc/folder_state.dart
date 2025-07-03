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

final class FolderRelatedArchivesLoaded extends FolderState {
  final List<Archive> archives;

  FolderRelatedArchivesLoaded(this.archives);
}

final class FolderDeleted extends FolderState {}

final class FolderError extends FolderState {
  final String error;

  FolderError(this.error);
}

