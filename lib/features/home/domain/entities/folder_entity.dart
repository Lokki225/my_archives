
import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'category_entity.dart';

class Folder extends Equatable{
  final int id;
  final String title;
  final String color;
  final int userId;
  final List<Category> relatedCategories;
  final int createdAt;
  final int updatedAt;

  const Folder({
    required this.id,
    required this.title,
    required this.color,
    required this.userId,
    required this.relatedCategories,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, color, userId, relatedCategories, createdAt, updatedAt];

  Map<String, int> getColorFromString(String colorString) {
    final regex = RegExp(
      r'alpha: ([\d.]+), red: ([\d.]+), green: ([\d.]+), blue: ([\d.]+)',
    );

    final match = regex.firstMatch(colorString);
    if (match == null) {
      throw FormatException("Invalid color string format");
    }

    return {
      "a": (double.parse(match.group(1)!) * 255).round(),
      "r": (double.parse(match.group(2)!) * 255).round(),
      "g": (double.parse(match.group(3)!) * 255).round(),
      "b": (double.parse(match.group(4)!) * 255).round(),
    };
  }

  Color getColorFromHexaString(String colorString) {
    final int colorInt = int.parse(colorString, radix: 16);
    return Color(colorInt);
  }

}