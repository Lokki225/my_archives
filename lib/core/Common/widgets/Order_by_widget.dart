import 'package:flutter/material.dart';

class OrderByWidget extends StatelessWidget {
  final String tooltipMessage;
  final String tableName;
  final List<String> options;
  final Function(String) onOptionSelected;

  const OrderByWidget({
    super.key,
    required this.tooltipMessage,
    required this.tableName,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: PopupMenuButton<String>(
        icon: Icon(Icons.filter_list, color: Colors.deepPurple, size: 30),
        onSelected: (String value) {
          onOptionSelected(value);
        },
        itemBuilder: (BuildContext context) {
          return options.map((String option) => PopupMenuItem<String>(
            value: option,
            child: Text(option, style: TextStyle(color: Colors.deepPurple)),
          )).toList();
        },
      ),
    );
  }
}
