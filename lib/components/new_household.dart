import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import '../create_household.dart';

class NewHousehold extends StatefulWidget {
  const NewHousehold({super.key});

  @override
  State<NewHousehold> createState() => _NewHouseholdState();
}

class _NewHouseholdState extends State<NewHousehold> {
  final QuestionnaireController controller = Get.put(QuestionnaireController());
  late TextEditingController _householdNameController;
  @override
  void initState() {
    super.initState();
    _householdNameController = controller.nameNewHousehold;
    _householdNameController.addListener(() {
      controller.updateHouseholdName(_householdNameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreateHousehold();
  }
}
