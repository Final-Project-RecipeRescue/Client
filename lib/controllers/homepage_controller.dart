import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/components/new_household.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';
import 'package:reciperescue_client/models/user_model.dart';

import '../constants/dotenv_constants.dart';
import '../create_household.dart';
import '../models/recipes_ui_model.dart';

class HomePageController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final Rx<List<RecipesUiModel>> recipes = Rx([]);
  final Rx<List<Ingredient>> ingredients = Rx([]);
  late UserModel user;

  Future<void> fetchHouseholdRecipes() async {
    String concatenatedIngredients =
        ingredients.value.map((e) => e.name).join(',');
    print('here $concatenatedIngredients');
    var url = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipesByIngredients?ingredients=$concatenatedIngredients');
    try {
      isLoading.value = true;
      hasError.value = false;
      var response = await http.get(url);
      print(response.body);
      List<dynamic> dataRecipes = jsonDecode(response.body);
      print(dataRecipes.length);
      if (response.statusCode == 200) {
        for (int i = 0; i < dataRecipes.length; i++) {
          print("data ${dataRecipes[i]['image_url']}");
          RecipesUiModel r = RecipesUiModel.fromMap(dataRecipes[i]);
          recipes.value.add(r);
        }
      } else {
        hasError.value = true;
      }
    } catch (error) {
      print("Error fetching data: $error");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // QuestionnaireController qCtrl = Get.find<QuestionnaireController>();
    // setIngredients(qCtrl.ingredients.value);
    // print('here with ${qCtrl.ingredients.value}');
    await fetchUserInfo();
    print(user);
    print(ingredients);
    await fetchHouseholdRecipes();
  }

  void setIngredients(List<Ingredient> value) {
    ingredients.value = value;
    update();
  }

  // void openHouseholdSettings() {
  //   Get.to(() => const CreateHousehold());
  // }
  Future<void> fetchUserInfo() async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_user?user_email=${Authenticate().currentUser!.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print(
            'Failed to fetch user information. Status code: ${response.statusCode}');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      user = UserModel.fromJson(data);
      await fetchHouseholdsIngredients();
    } catch (e) {
      print('Error: $e');
    }
  }

  //Currently the function takes the first household in the user's list. Waiting for nissan to create a new endpoint
  Future<void> fetchHouseholdsIngredients() async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_all_ingredients_in_household?user_email=${user.email}&household_id=${user.households[0]}');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print(
            'Failed to fetch household information. Status code: ${response.statusCode}');
      }
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<Ingredient> allIngredients = [];
      responseData.forEach((ingredientName, ingredientList) {
        ingredientList.forEach((ingredientData) {
          allIngredients.add(Ingredient.fromJson(ingredientData));
        });
      });

      ingredients.value = allIngredients;
    } catch (e) {
      print('Error: $e');
    }
  }
}
