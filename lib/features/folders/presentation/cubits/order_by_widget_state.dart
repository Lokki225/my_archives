part of 'order_by_widget_cubit.dart';

@immutable
sealed class OrderByWidgetState {}

final class OrderByWidgetInitial extends OrderByWidgetState {}

final class OrderByWidgetLastAdded extends OrderByWidgetState {}

final class OrderByWidgetLastUpdated extends OrderByWidgetState {}

final class OrderByWidgetTitleAsc extends OrderByWidgetState {}

final class OrderByWidgetTitleDesc extends OrderByWidgetState {}