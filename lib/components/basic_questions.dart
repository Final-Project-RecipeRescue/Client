import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/components/text_field.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:csc_picker/csc_picker.dart';

class BasicQuestions extends StatefulWidget {
  const BasicQuestions({Key? key}) : super(key: key);

  @override
  _BasicQuestionsState createState() => _BasicQuestionsState();
}

class _BasicQuestionsState extends State<BasicQuestions> {
  late QuestionnaireController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(QuestionnaireController());
  }

  String? email = Authenticate().currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's start by getting to know you better 😊",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: myGrey[900]),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        MyTextField(controller: controller.firstName, hintText: "First Name"),
        const SizedBox(height: 20),
        MyTextField(controller: controller.lastName, hintText: "Last Name"),
        const SizedBox(height: 20),
        MyTextField(
          hintText: "Email",
          initialValue: email,
          readOnly: true,
        ),
        const SizedBox(height: 40),
        CSCPicker(
          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
          onCountryChanged: (value) {
            setState(() {
              controller.setCountry(value);
            });
          },
          onStateChanged: (value) {
            if (value != null) {
              setState(() {
                controller.setState(value);
              });
            }
          },
          onCityChanged: (value) {},
          showStates: true,
          showCities: false,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(
              color: myGrey,
              width: 1.0,
            ),
          ),
        )
      ],
    );
  }
}
