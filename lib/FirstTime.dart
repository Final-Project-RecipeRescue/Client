import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/app_bar.dart';
import 'package:reciperescue_client/components/create_household.dart';
import 'package:reciperescue_client/components/custom_button.dart';
import 'package:reciperescue_client/components/search_household.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({Key? key}) : super(key: key);

  @override
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  final QuestionnaireController controller = Get.put(QuestionnaireController());
  String? countryValue = "";
  String? stateValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Obx(() => Stepper(
            type: StepperType.horizontal,
            currentStep: controller.currentStep.value,
            onStepContinue: () {
              if (controller.currentStep.value < stepList().length - 1) {
                controller.currentStep.value++;
              } else {
                print("create user");
              }
            },
            onStepCancel: () {
              if (controller.currentStep.value > 0) {
                controller.currentStep.value--;
              }
            },
            steps: stepList(),
          )),
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
          content: const Text('3'),
          isActive: controller.currentStep.value >= 2,
        ),
      ];

  Widget buildBasicDetailsFormsWidget() {
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
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          initialValue: Authenticate().currentUser?.email,
          readOnly: true,
        ),
        const SizedBox(height: 10),
        CSCPicker(
          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
              stateValue = null;
            });
          },
          onStateChanged: (value) {
            setState(() {
              stateValue = value;
            });
          },
          onCityChanged: (value) {
            setState(() {});
          },
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
        ),
      ],
    );
  }

  buildJoinCreateHousehold() {
    bool hasHousehold =
        false; // Assuming the user doesn't have a household initially

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Do any of your friends or family members already have a household?",
        style: GoogleFonts.poppins(
          textStyle: TextStyle(color: myGrey[900]),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          MyButton(
            text: 'yes',
            onPressed: () {
              setState(() {
                controller.isJoinExistingHousehold.value = true;
              });
            },
          ),
          const Spacer(),
          MyButton(
            text: 'no',
            onPressed: () {
              setState(() {
                controller.isJoinExistingHousehold.value = false;
              });
            },
          )
        ],
      ),
      Obx(
        () => controller.isJoinExistingHousehold.value
            ? const SearchHousehold()
            : const NewHousehold(),
      )
    ]);
  }
}
