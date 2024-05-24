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
  var itemCount = 0.obs;
  late Rx<UserModel> user = Rx(UserModel());
  final selectedHousehold = ''.obs;

  Future<void> fetchHouseholdRecipes() async {
    String concatenatedIngredients =
        ingredients.value.map((e) => e.name).join(',');
    print(concatenatedIngredients);
    List<RecipesUiModel> tempRecipes = [];

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
          tempRecipes.add(r);
        }
        recipes.value = tempRecipes;
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
    await fetchHouseholdsIngredients(user.value.households[0]);
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
      user.value = UserModel.fromJson(data);
      update();
      await fetchHouseholdsIngredients(user.value.households[0]);
    } catch (e) {
      print('Error: $e');
    }
  }

  //Currently the function takes the first household in the user's list. Waiting for nissan to create a new endpoint
  Future<void> fetchHouseholdsIngredients(String householdId) async {
    isLoading(true);
    hasError(false);
    selectedHousehold(householdId);
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_all_ingredients_in_household?user_email=${user.value!.email}&household_id=$selectedHousehold');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //TODO handle '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'
        print('In home page: ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List<Ingredient> allIngredients = [];
        responseData.forEach((ingredientName, ingredientList) {
          ingredientList.forEach((ingredientData) {
            allIngredients.add(Ingredient.fromJson(ingredientData));
          });
        });

        ingredients.value = allIngredients;
        update();
      }
    } catch (e) {
      hasError(true);
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> substractRecipeIngredients(
      List<Ingredient> ingredients, int recipeId) async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/use_recipe_by_recipe_id?user_email=${user.value.email}&household_id=${user.value.households[0]}');

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

  Future<void> removeIngredient(int index) async {
    Ingredient ingredientToRemove = ingredients.value[index];
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/remove_ingredient_from_household?user_email=${user.value.email}&household_id=$selectedHousehold');

    final Map<String, dynamic> requestBody = {
      "ingredient_id": ingredientToRemove.ingredientId,
      "name": ingredientToRemove.name,
      "amount": ingredientToRemove.amount,
      "unit": ingredientToRemove.unit
    };

    print('here!! $requestBody');

    final http.Response response = await http.delete(
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
      ingredients.value.removeAt(index);
      itemCount(ingredients.value.length);
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
