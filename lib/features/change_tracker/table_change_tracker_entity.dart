import 'package:equatable/equatable.dart';

import '../authentification/data/models/table_change_tracker_model.dart';

class TableChangeTracker extends Equatable{
  final int id;
  final String tableName;
  final int rowId;
  final int userId;
  final String status;
  final DateTime timestamp;

  const TableChangeTracker({
    required this.id,
    required this.tableName,
    required this.rowId,
    required this.userId,
    required this.status,
    required this.timestamp,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, tableName, rowId, userId, status, timestamp];

  // Convert the TableChangeTracker object to a Model
  TableChangeTrackerModel toModel() {
    return TableChangeTrackerModel(
      id: id,
      tableName: tableName,
      rowId: rowId,
      userId: userId,
      status: status,
      timestamp: timestamp,
    );
  }
}