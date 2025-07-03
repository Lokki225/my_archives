
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../util/get_file_extension.dart';// optional, for opening files

const imageExtensions = ['jpg', 'jpeg', 'png'];
const pdfExtensions = ['pdf'];
const docExtensions = ['doc', 'docx'];
const textExtensions = ['txt'];
const excelExtensions = ['xls', 'xlsx'];

Widget resourceViewerWidget(String filePath) {
  final ext = getFileExtension(filePath);

  if (imageExtensions.contains(ext)) {
    return GestureDetector(
      onTap: () => OpenFile.open(filePath, type: 'image'),
      child: Image.file(
        File(filePath),
        height: 200,
        width: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
      ),
    );
  }

  IconData icon;
  if (pdfExtensions.contains(ext)) {
    icon = Icons.picture_as_pdf;
  } else if (docExtensions.contains(ext)) {
    icon = Icons.description;
  } else if (textExtensions.contains(ext)) {
    icon = Icons.text_snippet;
  } else if (excelExtensions.contains(ext)) {
    icon = Icons.table_chart;
  } else {
    icon = Icons.insert_drive_file;
  }

  return GestureDetector(
    onTap: () => OpenFile.open(filePath),
    child: Column(
      children: [
        Icon(icon, size: 48, color: Colors.tealAccent),
        SizedBox(height: 4),
        Text(
          filePath.split('/').last,
          style: TextStyle(fontSize: 12, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
