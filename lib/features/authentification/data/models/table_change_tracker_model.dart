
import '../../../change_tracker/table_change_tracker_entity.dart';

class TableChangeTrackerModel extends TableChangeTracker {
  const TableChangeTrackerModel({
    required super.id,
    required super.tableName,
    required super.rowId,
    required super.userId,
    required super.status,
    required super.timestamp,
  });

  factory TableChangeTrackerModel.fromJSON(Map<String, dynamic> json) {
    return TableChangeTrackerModel(
      id: json['id'],
      tableName: json['table_name'],
      rowId: json['row_id'],
      userId: json['user_id'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
      'row_id': rowId,
      'user_id': userId,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}