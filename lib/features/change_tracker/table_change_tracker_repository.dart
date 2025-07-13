
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_entity.dart';

import '../../core/constants/constants.dart';
import '../../core/error/failures.dart';

abstract class TableChangeTrackerRepository {
  Future<Either<Failure, void>> insertInTrackChange({
    required String tableName,
    required int rowId,
    required TableChangeStatus status, // 'Created', 'Modified', 'Deleted'
    required int userId,
  });

  Future<Either<Failure, List<TableChangeTracker>>> getTablesChanges(int userId);
}