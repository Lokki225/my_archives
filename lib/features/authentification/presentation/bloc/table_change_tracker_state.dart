part of 'table_change_tracker_bloc.dart';

@immutable
sealed class TableChangeTrackerState {}

final class TableChangeTrackerInitial extends TableChangeTrackerState {}

final class TableChangeTrackerLoading extends TableChangeTrackerState {}

final class TableChangeTrackerLoaded extends TableChangeTrackerState {
  final List<TableChangeTracker> tableChanges;

  TableChangeTrackerLoaded({required this.tableChanges});
}

final class TableChangeTrackerError extends TableChangeTrackerState {
  final String error;

  TableChangeTrackerError(this.error);
}

final class TableChangeTrackerInserted extends TableChangeTrackerState{}