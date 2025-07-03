part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class FetchCategoriesEvent extends CategoryEvent {}

class FetchCategoriesByQueryEvent extends CategoryEvent {
  final String query;

  FetchCategoriesByQueryEvent(this.query);
}

class AddNewCategoryEvent extends CategoryEvent {
  final String title;
  final String icon;

  AddNewCategoryEvent(this.title, this.icon);
}

class EditCategoryEvent extends CategoryEvent {
  final int id;
  final String title;
  final String icon;

  EditCategoryEvent(this.id, this.title, this.icon);
}

class DeleteCategoryEvent extends CategoryEvent {
  final int categoryId;

  DeleteCategoryEvent(this.categoryId);
}

class ResetCategoryToInitialStateEvent extends CategoryEvent {}