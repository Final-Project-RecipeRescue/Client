import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/components/text_field.dart';

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
        Text(
          "Enter an existing household ID:",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: TextEditingController(),
          hintText: "Household Id",
        ),
        // Add search functionality as needed
      ],
    );
  }
}
