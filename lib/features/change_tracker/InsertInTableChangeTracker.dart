
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_repository.dart';

import '../../core/constants/constants.dart';
import '../../core/error/failures.dart';

class InsertInTableChangeTracker{
  final TableChangeTrackerRepository repo;

  InsertInTableChangeTracker({required this.repo});

  Future<Either<Failure, void>> call(String tableName, int rowId, TableChangeStatus status, int userId){
    return repo.insertInTrackChange(tableName: tableName, rowId: rowId, status: status, userId: userId);
  }
}