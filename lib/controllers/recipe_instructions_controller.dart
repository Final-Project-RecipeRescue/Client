import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:reciperescue_client/constants/dotenv_constants.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/controllers/analytics_controller.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/models/household_model.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';

import '../authentication/auth.dart';

class RecipeInstructionsController extends GetxController {
  RxList<String> steps = <String>[].obs;
  late RecipesUiModel recipe;
  final numOfDishes = 0.obs;
  late Household household;

  RecipeInstructionsController(RecipesUiModel value) {
    this.recipe = value;
  }

  int getNumOfDishes() => numOfDishes.value;

  void setNumOfDishes(int value) {
    numOfDishes.value = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    household = Get.find<HomePageController>().currentHousehold;
    fetchInstruction(recipe.id);
  }

  void fetchInstruction(int recipeId) async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipeInstructions/$recipeId');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print(
            'Failed to fetch user information. Status code: ${response.statusCode}');
      }
      var body = jsonDecode(response.body);
      print(body[0]['steps']);
      for (dynamic step in body[0]['steps']) {
        steps.add(step['description']);
        print(step);
      }
      steps.refresh();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> substractRecipeIngredients(
      int recipeId, double dishesNum) async {
    print(dishesNum);
    // /users_household/use_recipe_by_recipe_id?user_email=example%40example.example&household_id=2f249d7a-bca5-4ae1-87e3-cf3cba2b02b3&meal=Lunch&dishes_num=1&recipe_id=634435
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/use_recipe_by_recipe_id?user_email=${Authenticate().currentUser!.email}'
        '&household_id=${household.householdId}&meal=Lunch&dishes_num=$dishesNum&recipe_id=$recipeId');

    try {
      final response = await http.post(url);

      print('In home page: ${response.body}');
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);

        //TODO Remove the ingredients from the household
        update();
      }
    } catch (e) {
      print('Error: $e');
    } finally {}
  }

  void incrementNumOfDishes() {
    numOfDishes.value++;
    update();
  }

  void decrementNumOfDishes() {
    numOfDishes.value--;
    update();
  }
}
