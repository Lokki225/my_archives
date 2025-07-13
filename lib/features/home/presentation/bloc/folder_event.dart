part of 'folder_bloc.dart';

@immutable
sealed class FolderEvent {}

class FetchFoldersEvent extends FolderEvent {
  final SortingOption sortOption;

  FetchFoldersEvent({this.sortOption = SortingOption.all});
}

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
  final List<Category> categories;

  AddNewFolderEvent(this.title, this.color, this.categories);
}

class EditFolderEvent extends FolderEvent {
  final int id;
  final String title;
  final String color;
  final List<Category> relatedCategories;

  EditFolderEvent(this.id, this.title, this.color, this.relatedCategories);
}

class DeleteFolderEvent extends FolderEvent {
  final int folderId;

  DeleteFolderEvent(this.folderId);
}
