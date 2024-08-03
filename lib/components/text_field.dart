import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool? readOnly;
  final String? initialValue;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;

  const MyTextField({
    super.key,
    this.controller,
    this.hintText = 'Enter text',
    this.initialValue,
    this.readOnly,
    this.onEditingComplete,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        initialValue: initialValue,
        readOnly: readOnly ?? false,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
