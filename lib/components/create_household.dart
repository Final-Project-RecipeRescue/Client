import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import 'text_field.dart';

class NewHousehold extends StatefulWidget {
  const NewHousehold({super.key});

  @override
  State<NewHousehold> createState() => _NewHouseholdState();
}

class _NewHouseholdState extends State<NewHousehold> {
  QuestionnaireController controller = Get.find<QuestionnaireController>();

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
