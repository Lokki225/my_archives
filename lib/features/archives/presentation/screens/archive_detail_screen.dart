import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_archives/core/util/formatTimestampToDate.dart';
import '../../../../core/Common/widgets/resource_viewer_widget.dart';
import '../../../home/domain/entities/archive_entity.dart';

class ArchiveDetailScreen extends StatefulWidget {
  const ArchiveDetailScreen({super.key});

  @override
  State<ArchiveDetailScreen> createState() => _ArchiveDetailScreenState();
}

class _ArchiveDetailScreenState extends State<ArchiveDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the previous screen
    final archive = ModalRoute.of(context)?.settings.arguments as Archive;

    return Scaffold(
      appBar: AppBar(
        title: Text("MyArchives", style: TextStyle(color: Colors.white, fontSize: 25),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(archive.coverImage),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  archive.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Text(
                archive.description,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                'Created Date: ${formatTimestampToDate(archive.createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 8),
              Text(
                'Last Update Date: ${formatTimestampToDate(archive.updatedAt)}',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                'Resources',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: archive.resourcePaths.map((path) => resourceViewerWidget(path)).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
