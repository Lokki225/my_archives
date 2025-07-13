import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/constants/constants.dart';
import '../../../change_tracker/table_change_tracker_entity.dart';
import '../../../change_tracker/GetTableChangeTracker.dart';
import '../../../change_tracker/InsertInTableChangeTracker.dart';

part 'table_change_tracker_event.dart';
part 'table_change_tracker_state.dart';

class TableChangeTrackerBloc extends Bloc<TableChangeTrackerEvent, TableChangeTrackerState> {
  final GetTableChangeTracker getTableChangeTracker;
  final InsertInTableChangeTracker insertInTableChangeTracker;

  TableChangeTrackerBloc({
    required this.getTableChangeTracker,
    required this.insertInTableChangeTracker,
  }) : super(TableChangeTrackerInitial()) {
    on<TableChangeTrackerFetchEvent>(_onTableChangeTrackerHandler);
    on<InsertInTableChangeTrackerEvent>(_onInsertInTableChangeTrackerHandler);
  }

  void _onTableChangeTrackerHandler(TableChangeTrackerFetchEvent event, Emitter<TableChangeTrackerState> emit) async{
    emit(TableChangeTrackerLoading());

    final failureOrTablesChanges = await getTableChangeTracker(event.userId);

    failureOrTablesChanges.fold(
      (failure) => emit(TableChangeTrackerError("Something went wrong")),
      (tablesChanges) => emit(TableChangeTrackerLoaded(tableChanges: tablesChanges)),
    );
  }

  void _onInsertInTableChangeTrackerHandler(InsertInTableChangeTrackerEvent event, Emitter<TableChangeTrackerState> emit) async{
    emit(TableChangeTrackerLoading());

    final failureOrTablesChanges = await insertInTableChangeTracker(event.tableName, event.rowId, event.status, event.userId);

    failureOrTablesChanges.fold(
      (failure) => emit(TableChangeTrackerError("Something went wrong when inserting")),
      (_) => emit(TableChangeTrackerInserted()),
    );
  }
}
