import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/components/app_bar.dart';
import 'package:reciperescue_client/components/basic_questions.dart';
import 'package:reciperescue_client/components/create_or_join_household.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import 'colors/colors.dart';
import 'components/add_first_ingredients.dart';
import 'components/display_household.dart';
import 'controllers/household_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to include the Google Fonts package

class FirstTime extends StatefulWidget {
  const FirstTime({Key? key}) : super(key: key);

  @override
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  QuestionnaireController controller = Get.put(QuestionnaireController());
  String? countryValue = "";
  String? stateValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Obx(
        () => Stepper(
          type: StepperType.horizontal,
          currentStep: controller.currentStep.value,
          onStepContinue: () async {
            if (controller.currentStep.value < stepList().length - 1) {
              controller.currentStep.value++;
            } else {
              controller.initNewUserAndHousehold();
            }
          },
          onStepCancel: () {
            if (controller.currentStep.value > 0) {
              controller.currentStep.value--;
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MyButton(
                  text: 'Cancel',
                  onPressed: controls.onStepCancel ?? () {},
                  outlineColor: primary,
                  buttonColor: Colors.white,
                  textColor: primary,
                ),
                MyButton(
                  text: 'Continue',
                  onPressed: controls.onStepContinue ?? () {},
                  textColor: Colors.white,
                ),
              ],
            );
          },
          steps: stepList(),
        ),
      ),
    );
  }

  List<Step> stepList() => [
        Step(
          state: controller.currentStep.value > 0
              ? StepState.complete
              : StepState.indexed,
          title: const Text(''),
          content: buildBasicDetailsFormsWidget(),
          isActive: controller.currentStep.value >= 0,
        ),
        Step(
          state: controller.currentStep.value > 1
              ? StepState.complete
              : StepState.indexed,
          title: const Text(''),
          content: buildJoinCreateHousehold(),
          isActive: controller.currentStep.value >= 1,
        ),
        Step(
          state: controller.currentStep.value > 2
              ? StepState.complete
              : StepState.indexed,
          title: const Text(''),
          content: buildIngredientsOrHouseholdDisplay(),
          isActive: controller.currentStep.value >= 2,
        ),
      ];

  Widget buildBasicDetailsFormsWidget() {
    return const BasicQuestions();
  }

  Widget buildJoinCreateHousehold() {
    return JoinOrCreateHousehold();
  }

  Widget buildIngredientsOrHouseholdDisplay() {
    return Obx(
      () => Get.find<HouseholdController>().isJoinExistingHousehold.value
          ? const DisplayHousehold()
          : const AddFirstIngredients(),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color outlineColor;
  final Color buttonColor;
  final Color textColor;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.outlineColor = Colors.transparent, // Default outline color
    this.buttonColor = primary, // Default button color
    this.textColor = primary, // Default text color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        height: MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
          border: Border.all(color: outlineColor), // Set the outline color
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor, // Set the text color
            ),
          ),
        ),
      ),
    );
  }
}
