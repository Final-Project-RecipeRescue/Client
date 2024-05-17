import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';
import 'package:reciperescue_client/models/user_model.dart';

import '../constants/dotenv_constants.dart';
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
    var url = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipesByIngredients?ingredients=$concatenatedIngredients');
    try {
      isLoading.value = true;
      hasError.value = false;
      var response = await http.get(url);

      List<dynamic> dataRecipes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (int i = 0; i < dataRecipes.length; i++) {
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
    await fetchUserInfo();
    print("on init $user");
    print("on init $ingredients");
    await fetchHouseholdRecipes();
  }

  List<Ingredient> getIngredients() => ingredients.value;

  void setIngredients(List<Ingredient> value) {
    ingredients.value = value;
    update();
  }

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
      update();
      await fetchHouseholdsIngredients(user!.households[0]);
    } catch (e) {
      print('Error: $e');
    }
  }

  //Currently the function takes the first household in the user's list. Waiting for nissan to create a new endpoint
  Future<void> fetchHouseholdsIngredients(String householdId) async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_all_ingredients_in_household?user_email=${user.email}&household_id=$householdId');

    try {
      final response = await http.get(url);
      print(response.body);
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

  Future<void> substractRecipeIngredients(
      List<Ingredient> ingredients, int recipeId) async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/use_recipe_by_recipe_id?user_email=${user!.email}&household_id=${user!.households[0]}');

    List<Map<String, dynamic>> recipeIngredients =
        ingredients.map((ingredient) {
      return {
        'IngredientName': ingredient.name,
        'IngredientAmount': ingredient.amount ?? 1,
      };
    }).toList();

    final Map<String, dynamic> requestBody = {
      'recipe_id': recipeId,
      'meal_type': "Lunch",
      'dishes_num': 1,
      'ingredients': recipeIngredients,
    };

    print(requestBody);

    final http.Response response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request was successful
      print('Request successful: ${response.body}');
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
