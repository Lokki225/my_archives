part of 'table_change_tracker_bloc.dart';

@immutable
sealed class TableChangeTrackerEvent {}

final class TableChangeTrackerFetchEvent extends TableChangeTrackerEvent {
  final int userId;
  TableChangeTrackerFetchEvent({required this.userId});
}

final class InsertInTableChangeTrackerEvent extends TableChangeTrackerEvent {
  final String tableName;
  final int rowId;
  final TableChangeStatus status; // 'Created', 'Modified', 'Deleted'
  final int userId;

  InsertInTableChangeTrackerEvent({
    required this.tableName,
    required this.rowId,
    required this.status,
    required this.userId,
  });
}