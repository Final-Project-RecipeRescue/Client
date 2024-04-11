import 'package:flutter/material.dart';

class SearchHousehold extends StatefulWidget {
  const SearchHousehold({super.key});

  @override
  State<SearchHousehold> createState() => _SearchHouseholdState();
}

class _SearchHouseholdState extends State<SearchHousehold> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Enter an existing household ID:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
        // Add search functionality as needed
      ],
    );
  }
}
