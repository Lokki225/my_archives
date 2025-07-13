import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/home/presentation/bloc/archive_bloc.dart';
import '../../../features/home/presentation/bloc/category_bloc.dart';

class SummaryActivityWidget extends StatefulWidget {
  final int totalFolders;
  final int totalCategories;
  const SummaryActivityWidget({super.key, required this.totalFolders, required this.totalCategories});

  @override
  State<SummaryActivityWidget> createState() => _SummaryActivityWidgetState();
}

class _SummaryActivityWidgetState extends State<SummaryActivityWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        if (state is ArchiveLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ArchiveLoaded) {
          final totalArchives = state.archives.length;

          return Container(
            padding: EdgeInsets.all(15),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade200,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Activity Resume",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.totalFolders.toString(),
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.totalFolders == 1 ? "Folder" : "Folders",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            totalArchives.toString(),
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            totalArchives == 1 ? "Archive" : "Archives",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.totalCategories.toString(),
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.totalCategories == 1 ? "Category" : "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ]
                ),
              ],
            ),
          );
        }
        return Container();
      }
    );
  }
}
