import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnaireController extends GetxController {
  var currentStep = 0.obs;
  var countryValue = "".obs;
  var stateValue = "".obs;
  var householdName = "".obs;
  var householdId = "".obs;
  var newHouseholdName = "".obs;
  final isJoinExistingHousehold = Rx(true);

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController existingHousehold = TextEditingController();
  TextEditingController nameNewHousehold = TextEditingController();
  TextEditingController firstIngredients = TextEditingController();

  var itemCount = 0.obs;
  Rx<List<String>> ingredients = Rx<List<String>>([]);

  void addIngredients(String ingredient) {
    ingredients.value.add(ingredient);
    itemCount.value = ingredients.value.length;
    firstIngredients.clear();
    print('${ingredients} ${itemCount.value}');
  }

  void removeIngredient(int index) {
    ingredients.value.removeAt(index);
    itemCount.value = ingredients.value.length;
  }

  @override
  void onClose() {
    super.onClose();
    firstName.dispose();
    lastName.dispose();
    existingHousehold.dispose();
    nameNewHousehold.dispose();
    firstIngredients.dispose();
  }
}
