import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/change_tracker/table_change_tracker_repository_impl.dart';
import 'package:my_archives/features/authentification/presentation/bloc/table_change_tracker_bloc.dart';

import '../../../features/change_tracker/table_change_tracker_local_datasource.dart';
import '../../../features/change_tracker/table_change_tracker_repository.dart';
import '../../../features/change_tracker/GetTableChangeTracker.dart';
import '../../../features/change_tracker/InsertInTableChangeTracker.dart';
import '../../../injection_container.dart';
import '../../database/local.dart';

class UserActivityTable extends StatefulWidget {
  final int userId;
  const UserActivityTable({super.key, required this.userId});

  @override
  State<UserActivityTable> createState() => _UserActivityTableState();
}

class _UserActivityTableState extends State<UserActivityTable> {
  @override
  void initState() {
    super.initState();
    // context.read<TableChangeTrackerBloc>()
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => TableChangeTrackerBloc(
        getTableChangeTracker: GetTableChangeTracker(repo: TableChangeTrackerRepositoryImpl(localDataSource: TableChangeTrackerLocalDataSourceImpl(localDb: sL<LocalDatabase>()))),
        insertInTableChangeTracker: InsertInTableChangeTracker(repo: TableChangeTrackerRepositoryImpl(localDataSource: TableChangeTrackerLocalDataSourceImpl(localDb: sL<LocalDatabase>()))),
      )..add(TableChangeTrackerFetchEvent(userId: widget.userId)),
      child: BlocListener<TableChangeTrackerBloc, TableChangeTrackerState>(
        listener: (context, state) {
          if (state is TableChangeTrackerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }

          if (state is TableChangeTrackerInitial) {
            context.read<TableChangeTrackerBloc>().add(TableChangeTrackerFetchEvent(userId: widget.userId));
          }
        },
        child: BlocBuilder<TableChangeTrackerBloc, TableChangeTrackerState>(
          builder: (context, state) {
            if (state is TableChangeTrackerLoading || state is TableChangeTrackerInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TableChangeTrackerLoaded) {
              Iterable<ActivityRow> rows = state.tableChanges.map((activity) => ActivityRow(
                date: activity.timestamp,
                table: activity.tableName,
                rowId: activity.id,
                action: activity.status,
              ));

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: WidgetStateProperty.all(Colors.deepPurpleAccent),
                    headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Table', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Row ID', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Status', style: TextStyle(color: Colors.white))),
                    ],
                    rows: rows.map((activity) {
                      Color color;
                      Icon icon;
                      switch (activity.action) {
                        case 'Deleted':
                          color = Colors.red;
                          icon = Icon(Icons.delete_forever, color: Colors.white, size: 18,);
                          break;
                        case 'Modified':
                          color = Colors.orange;
                          icon = Icon(Icons.mode_edit_outlined, color: Colors.white, size: 18);
                          break;
                        case 'Created':
                          color = Colors.green;
                          icon = Icon(Icons.add_circle_outline, color: Colors.white, size: 18);
                          break;
                        default:
                          color = Colors.green.shade100;
                          icon = Icon(Icons.error, color: Colors.white, size: 18);
                      }

                      return DataRow(
                        cells: [
                          DataCell(Text(activity.date.toIso8601String().split('T').first, style: TextStyle(color: Colors.white))),
                          DataCell(Text(activity.table, style: TextStyle(color: Colors.white),)),
                          DataCell(Text(activity.rowId.toString(), style: TextStyle(color: Colors.white))),
                          DataCell(
                            Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  icon,
                                  SizedBox(width: 5,),
                                  Text(
                                    activity.action,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        color: WidgetStateProperty.all(Colors.deepPurple.shade200),
                      );
                    }).toList(),
                  ),
                ),
              );
            }

            return Center(child: Text('Unknow Error',));
          }
        ),
      ),
    );
  }
}

class ActivityRow {
  final DateTime date;
  final String table;
  final int rowId;
  final String action;

  ActivityRow({required this.date, required this.table, required this.rowId, required this.action});
}
