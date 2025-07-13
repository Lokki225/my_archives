
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_repository.dart';

import '../../core/error/failures.dart';
import 'table_change_tracker_entity.dart';

class GetTableChangeTracker {
  final TableChangeTrackerRepository repo;

  GetTableChangeTracker({required this.repo});

  Future<Either<Failure, List<TableChangeTracker>>> call(int userId) async{
    return await repo.getTablesChanges(userId);
  }
}