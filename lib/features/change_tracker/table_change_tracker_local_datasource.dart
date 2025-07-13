
import 'package:my_archives/core/util/status_to_string.dart';
import 'package:my_archives/features/authentification/data/models/table_change_tracker_model.dart';

import '../../core/constants/constants.dart';
import '../../core/database/local.dart';
import '../../core/error/exceptions.dart';

abstract class TableChangeTrackerLocalDataSource {
  Future<void> insertInTrackChange({
    required String tableName,
    required int rowId,
    required TableChangeStatus status, // 'Created', 'Modified', 'Deleted'
    required int userId,
  });

  Future<List<TableChangeTrackerModel>> getTablesChanges(int userId);
}

class TableChangeTrackerLocalDataSourceImpl implements TableChangeTrackerLocalDataSource {
  final LocalDatabase localDb;

  TableChangeTrackerLocalDataSourceImpl({required this.localDb});

  @override
  Future<List<TableChangeTrackerModel>> getTablesChanges(int userId) async{
    try {
      final tablesChanges = await localDb.getTablesChanges(userId);
      return tablesChanges;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> insertInTrackChange({required String tableName, required int rowId, required TableChangeStatus status, required int userId}) async{
    try{
      final String statusString = statusToString(status);
      await localDb.insertInTrackChange(tableName: tableName, rowId: rowId, status: statusString, userId: userId);
    }catch(_){
      throw CacheException();
    }
  }

}