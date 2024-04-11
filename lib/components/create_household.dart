import 'package:flutter/material.dart';

class NewHousehold extends StatefulWidget {
  const NewHousehold({super.key});

  @override
  State<NewHousehold> createState() => _NewHouseholdState();
}

class _NewHouseholdState extends State<NewHousehold> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Create a new household:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Household Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        // Add more fields as needed for creating a new household
      ],
    );
  }
}
