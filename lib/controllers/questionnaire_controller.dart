import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/controllers/household_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

import '../constants/dotenv_constants.dart';
import '../home_page.dart';
import '../models/recipes_ui_model.dart';
import '../models/user_model.dart';

class QuestionnaireController extends GetxController {
  var currentStep = 0.obs;
  var countryValue = "".obs;
  var stateValue = "".obs;
  var householdName = "".obs;
  var householdId = "".obs;
  var newHouseholdName = "".obs;
  final isJoinExistingHousehold = Rx(true);
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final Rx<List<RecipesUiModel>> recipes = Rx([]);

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController existingHousehold = TextEditingController();
  TextEditingController nameNewHousehold = TextEditingController();
  // TextEditingController firstIngredients = TextEditingController();

  late UserModel userModel;

  var itemCount = 0.obs;
  Rx<List<Ingredient>> ingredients = Rx<List<Ingredient>>([]);

  void addIngredients(String ingredient) {
    List<Ingredient> systemIngredients =
        Get.find<InitializerController>().systemIngredients;
    Ingredient? ingredientObj =
        systemIngredients.firstWhere((obj) => obj.name == ingredient);
    ingredients.value.add(ingredientObj);
    itemCount.value = ingredients.value.length;
    // firstIngredients.clear();
  }

  void removeIngredient(int index) {
    ingredients.value.removeAt(index);
    itemCount.value = ingredients.value.length;
  }

  Future<bool> createUser() async {
    // Define the URL to which you want to send the POST request
    late String url = '${DotenvConstants.baseUrl}/users_household/add_user';
    print("first_name: ${firstName.value.text}");
    print("last_name: ${lastName.value.text}");
    print("email: ${Authenticate().currentUser!.email}");
    print("country: ${countryValue.value}");
    print("state: ${stateValue.value}");

    // Define the JSON body data
    Map<String, dynamic> body = {
      "first_name": firstName.value.text,
      "last_name": lastName.value.text,
      "email": Authenticate().currentUser!.email,
      "country": countryValue.value,
      "state": stateValue.value
    };

    // Convert the body map to JSON format
    String jsonBody = jsonEncode(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print(response.body);
        userModel = UserModel(
            firstName: firstName.text,
            lastName: lastName.text,
            email: Authenticate().currentUser!.email,
            country: countryValue.value,
            state: stateValue.value);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error making POST request: $error');
    }
    return json.decode('Error');
  }

  @override
  void onClose() {
    super.onClose();
    firstName.dispose();
    lastName.dispose();
    existingHousehold.dispose();
    nameNewHousehold.dispose();
    // firstIngredients.dispose();
  }

  void updateHouseholdName(String text) {
    newHouseholdName.value = text;
  }

  void setCountry(String value) {
    countryValue.value = value;
    update();
  }

  void setState(String value) {
    stateValue.value = value;
    update();
  }

  void initNewUserAndHousehold() async {
    if (await createUser() &&
        await Get.find<HouseholdController>().createHousehold()) {
      Get.to(() => HomePage);
    } else {
      Get.offAll(() => const LoginPage());
    }
  }
}
