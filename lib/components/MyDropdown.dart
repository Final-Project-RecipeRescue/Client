import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String selectedValue;
  final Iterable<String> items;
  final ValueChanged<String?> onChanged;

  const MyDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(selectedValue),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
