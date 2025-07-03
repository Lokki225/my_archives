import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

void showFormModal({
  required BuildContext context,
  String? initialTitle,
  required String screen,
  Map<String, dynamic>? formFieldsVal, // Form fields to prefill data
  Function(String screenName, Map<String, dynamic> formFieldsVal)? onSave,
})
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController(text: initialTitle ?? formFieldsVal?['title'] ?? "");

  Color _selectedColor = formFieldsVal?['color'] != null
      ? Color(int.parse(formFieldsVal!['color'], radix: 16))
      : Colors.teal; // Default color fallback

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.deepPurple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _getForm(
          screen,
          initialTitle,
          _formKey,
          _titleController,
          _selectedColor,
          context,
          formFieldsVal ?? {},
          onSave,
        ),
      );
    },
  );
}

Widget _getForm(
    String screenName,
    String? initialTitle,
    GlobalKey<FormState> formKey,
    TextEditingController titleController,
    Color selectedColor,
    BuildContext context,
    Map<String, dynamic> formFieldsVal,
    Function(String screenName, Map<String, dynamic> formFieldsVal)? onSave,
) {


  return Text("Unexpected error");
}
