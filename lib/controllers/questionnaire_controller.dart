import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/household_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/dashboard.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';
import 'package:reciperescue_client/routes/routes.dart';

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
  TextEditingController ingredientUnitController = TextEditingController();
  TextEditingController ingredientAmountController = TextEditingController();

  // TextEditingController firstIngredients = TextEditingController();

  late Rx<UserModel> user = Rx(UserModel());

  var itemCount = 0.obs;
  final Rx<List<IngredientHousehold>> ingredients =
      Rx<List<IngredientHousehold>>([]);

  void addIngredient(String id, String name, double amount, String? unit) {
    IngredientHousehold ingredientObj = IngredientHousehold(
        ingredientId: id, name: name, amount: amount, unit: unit);
    ingredients.value.add(ingredientObj);
    itemCount.value = ingredients.value.length;
    update();
  }

  void removeIngredient(int index) {
    ingredients.value.removeAt(index);
    itemCount.value = ingredients.value.length;
    update();
  }

  Future<bool> createUser() async {
    // Define the URL to which you want to send the POST request
    late String url =
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/addUser';
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
        user.value = UserModel(
            firstName: firstName.text,
            lastName: lastName.text,
            email: Authenticate().currentUser!.email,
            country: countryValue.value,
            state: stateValue.value);
        Get.put(HomePageController()).user = user;
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
        await Get.find<HouseholdController>().createHousehold(this)) {
      Get.offAll(() => const Dashboard());
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  modifyIngredient(int index) {
    Ingredient ingredientToModify = ingredients.value[index];
    update();
  }

  void modifyIngredientValues(
      IngredientHousehold ingredientHousehold, bool isNewValue) {
    int index = ingredients.value
        .indexWhere((element) => element == ingredientHousehold);
    if (isNewValue) {
      ingredients.value[index].amount = ingredientHousehold.amount;
    } else {
      ingredients.value[index].amount =
          ingredients.value[index].amount + ingredientHousehold.amount;
    }
    // TODO Update also the firebase
    update();
  }
}
