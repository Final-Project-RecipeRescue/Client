// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/controllers/household_controller.dart';

import 'components/text_field.dart';

class CreateHousehold extends StatelessWidget {
  HouseholdController controller = Get.find<HouseholdController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Create a new household:",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: controller.nameNewHousehold,
          hintText: "Household Name",
        ),
        const SizedBox(height: 10),
        // Add more fields as needed for creating a new household
      ],
    );
  }
}
