part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryCreated extends CategoryState {}

final class CategoryEdited extends CategoryState {}

final class CategoryDeleted extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded(this.categories);
}

final class CategoryError extends CategoryState {
  final String error;

  CategoryError(this.error);
}

