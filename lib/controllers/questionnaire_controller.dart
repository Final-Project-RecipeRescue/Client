import 'package:get/get.dart';

class QuestionnaireController {
  var currentStep = 0.obs;
  var countryValue = "".obs;
  var stateValue = "".obs;
  var householdName = "".obs;
  var householdId = "".obs;
  final isJoinExistingHousehold = Rx(true);
}
