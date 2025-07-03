import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentification/presentation/bloc/auth_bloc.dart';
import '../../../home/domain/entities/category_entity.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the previous screen
    final category = ModalRoute.of(context)?.settings.arguments as Category;
    return Scaffold(
      appBar: AppBar(
        title: Text("MyArchives", style: TextStyle(color: Colors.white, fontSize: 25),),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Category {${category.title}} Details Screen"),
      ),
    );
  }
}
