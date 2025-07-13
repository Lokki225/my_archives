
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_entity.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_local_datasource.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_repository.dart';

class TableChangeTrackerRepositoryImpl implements TableChangeTrackerRepository{
  final TableChangeTrackerLocalDataSource localDataSource;
  TableChangeTrackerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TableChangeTracker>>> getTablesChanges(int userId) async{
    try{
      final tablesChanges = await localDataSource.getTablesChanges(userId);
      return Right(tablesChanges);
    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> insertInTrackChange({required String tableName, required int rowId, required TableChangeStatus status, required int userId}) async{
    try{
      await localDataSource.insertInTrackChange(tableName: tableName, rowId: rowId, status: status, userId: userId);
      return const Right(null);
    }catch(e){
      return Left(CacheFailure());
    }
  }

  
}