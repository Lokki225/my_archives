part of 'folder_bloc.dart';

@immutable
sealed class FolderEvent {}

class FetchFoldersEvent extends FolderEvent {}

class FetchFolderRelatedArchivesAndCategoriesEvent extends FolderEvent {
  final int folderId;

  FetchFolderRelatedArchivesAndCategoriesEvent(this.folderId);
}

class FetchFoldersByQueryEvent extends FolderEvent {
  final String query;

  FetchFoldersByQueryEvent(this.query);
}

class ResetFolderToInitialStateEvent extends FolderEvent {}

class AddNewFolderEvent extends FolderEvent {
  final String title;
  final String color;

  AddNewFolderEvent(this.title, this.color);
}

class EditFolderEvent extends FolderEvent {
  final int id;
  final String title;
  final String color;

  EditFolderEvent(this.id, this.title, this.color);
}

class DeleteFolderEvent extends FolderEvent {
  final int folderId;

  DeleteFolderEvent(this.folderId);
}
