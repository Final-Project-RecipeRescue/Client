import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/components/app_bar.dart';
import 'package:reciperescue_client/components/basic_questions.dart';
import 'package:reciperescue_client/components/create_or_join_household.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import 'components/add_first_ingredients.dart';
import 'components/display_household.dart';
import 'controllers/household_controller.dart';

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
      body: Obx(() => Stepper(
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
          content: buildIngredientsOrHouseholdDisplay(),
          isActive: controller.currentStep.value >= 2,
        ),
      ];

  Widget buildBasicDetailsFormsWidget() {
    return const BasicQuestions();
  }

  buildJoinCreateHousehold() {
    return JoinOrCreateHousehold();
  }

  buildIngredientsOrHouseholdDisplay() {
    return Obx(
      () => Get.find<HouseholdController>().isJoinExistingHousehold.value
          ? const DisplayHousehold()
          : const AddFirstIngredients(),
    );
  }
}
