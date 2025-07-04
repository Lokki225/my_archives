
import 'package:flutter/material.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';

class CategoryTagListWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoryTagListWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}
