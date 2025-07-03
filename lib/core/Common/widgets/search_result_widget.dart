import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

import '../../../features/home/domain/entities/archive_entity.dart';
import '../../../features/home/presentation/bloc/archive_bloc.dart';
import '../../../features/home/presentation/bloc/category_bloc.dart';
import '../../../features/home/presentation/bloc/folder_bloc.dart';
import '../../constants/constants.dart';
class SearchResultWidget extends StatefulWidget {
  final String query;
  final String queryFor;
  final List<Archive>? archives;
  final List<Folder>? folders;
  final List<Category>? categories;

  const SearchResultWidget({
    super.key,
    required this.query,
    required this.queryFor,
    required this.archives,
    required this.folders,
    required this.categories,
  });

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.queryFor == 'archives') {
      return ListView.builder(
        itemCount: widget.archives!.length,
        itemBuilder: (BuildContext context, int index) {
          final archive = widget.archives![index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: Colors.deepPurple.shade200, // Background color for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              elevation: 5, // Adds shadow effect
              child: ListTile(
                leading: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    'lib/assets/images/archive_cover.png',
                  ),
                ),
                subtitle: Text(archive.description, style: TextStyle(color: Colors.white70)),
                title: Text(
                  archive.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                trailing: Icon(Icons.more_vert, color: Colors.white), // Optional trailing icon
                onTap: () {
                  Navigator.pushNamed(context, '/ArchiveDetailScreen', arguments: archive);
                },
              ),
            ),
          );
        },
      );
    } else if (widget.queryFor == 'folders') {
      return ListView.builder(
        itemCount: widget.folders!.length,
        itemBuilder: (BuildContext context, int index) {
          final folder = widget.folders![index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: Colors.deepPurple.shade200, // Background color for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              elevation: 5, // Adds shadow effect
              child: ListTile(
                leading: Image.asset(
                  'lib/assets/images/folder_cover.png',
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  folder.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                trailing: Icon(Icons.more_vert, color: Colors.white), // Optional trailing icon
                onTap: () {
                  // Handle on-tap logic
                },
              ),
            ),
          );
        },
      );
    } else if (widget.queryFor == 'categories') {
      return ListView.builder(
        itemCount: widget.categories!.length,
        itemBuilder: (BuildContext context, int index) {
          final category = widget.categories![index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: Colors.deepPurple.shade200, // Background color for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              elevation: 5, // Adds shadow effect
              child: ListTile(
                leading: Icon(
                  Icons.category,
                  color: Colors.tealAccent,
                  size: 50,
                ),
                title: Text(
                  category.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),// Optional trailing icon
                onTap: () {
                  Navigator.pushNamed(context, '/CategoryDetailScreen', arguments: category);
                },
              ),
            ),
          );
        },
      );
    }

    return Center(
      child: Text(
        'Unexpected queryFor value: ${widget.queryFor}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
