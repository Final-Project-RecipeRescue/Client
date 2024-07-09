import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';
import 'package:reciperescue_client/models/user_model.dart';

import '../constants/dotenv_constants.dart';
import '../models/household_model.dart';
import '../models/recipes_ui_model.dart';

class HomePageController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final Rx<List<RecipesUiModel>> recipes = Rx([]);
  final Rx<List<IngredientHousehold>> ingredients = Rx([]);
  var itemCount = 0.obs;
  late Rx<UserModel> user = Rx(UserModel());
  final selectedHousehold = ''.obs;
  int _selectedIngredientsIndex = 0;
  String _recipesFetchErrorMsg = '';
  late Household currentHousehold;
  TextEditingController ingredientUnitController = TextEditingController();
  TextEditingController ingredientAmountController = TextEditingController();

  int get selectedIngredientsIndex => _selectedIngredientsIndex;

  set selectedIngredientsIndex(int index) {
    _selectedIngredientsIndex = index;
    update();
  }

  String get recipesFetchErrorMsg => _recipesFetchErrorMsg;

  set recipesFetchErrorMsg(String errorMsg) {
    _recipesFetchErrorMsg = errorMsg;
    update();
  }

  Future<void> fetchHouseholdRecipes() async {
    String concatenatedIngredients =
        ingredients.value.map((e) => e.name).join(',');
    print(concatenatedIngredients);
    List<RecipesUiModel> tempRecipes = [];

    var urlWithoutMissedIngredients = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_all_recipes_that_household_can_make?user_email=${Authenticate().currentUser!.email}&household_id=${currentHousehold.householdId}');
    var urlWithMissedIngredients = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipesByIngredients?ingredients=$concatenatedIngredients');

    await _fetchData(urlWithoutMissedIngredients, tempRecipes);
    if (tempRecipes.isEmpty && !hasError.value) {
      await _fetchData(urlWithMissedIngredients, tempRecipes);
    }
  }

  Future<void> _fetchData(Uri url, List<RecipesUiModel> tempRecipes) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      var response = await http.get(url);
      List<dynamic> dataRecipes = [];
      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (decodedResponse is List<dynamic>) {
          dataRecipes = decodedResponse;
        } else if (decodedResponse is Map<String, dynamic>) {
          if (decodedResponse['detail'] ==
              'from this ingredients list there is no recipes') {
            return;
          }
        }

        for (var recipeData in dataRecipes) {
          RecipesUiModel recipe = RecipesUiModel.fromMap(recipeData);
          tempRecipes.add(recipe);
        }

        recipes.value = tempRecipes;
      } else {
        hasError.value = true;
      }
      update();
    } catch (error) {
      print("Error fetching data: $error");
      recipesFetchErrorMsg = error.toString();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    var now = DateTime.now();

    await fetchUserInfo();
    var elapsedUserInfo = DateTime.now().difference(now).inMilliseconds;
    print("on init fetchUserInfo in ${elapsedUserInfo}ms");

    now = DateTime.now();
    await fetchHousehold(user.value.email, user.value.households[0]);
    var elapsedHousehold = DateTime.now().difference(now).inMilliseconds;
    print("on init fetchHousehold in ${elapsedHousehold}ms");

    now = DateTime.now();
    await fetchHouseholdsIngredients(user.value.households[0]);
    var elapsedIngredients = DateTime.now().difference(now).inMilliseconds;
    print("on init fetchHouseholdsIngredients in ${elapsedIngredients}ms");

    now = DateTime.now();
    await fetchHouseholdRecipes();
    var elapsedRecipes = DateTime.now().difference(now).inMilliseconds;
    print("on init fetchHouseholdRecipes in ${elapsedRecipes}ms");
  }

  List<Ingredient> getIngredients() => ingredients.value;

  void setIngredients(List<IngredientHousehold> value) {
    ingredients.value = value;
    update();
  }

  Future<void> fetchHousehold(String? userEmail, String householdId) async {
    final url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/get_household_user_by_id?user_email=$userEmail&household_id=$householdId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        currentHousehold = Household.fromJson(data);

        update();
      } else {
        print('Failed to load household: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching household: $e');
    }
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
    } catch (e) {
      print('Error: $e');
    }
  }

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
        List<IngredientHousehold> allIngredients = [];
        responseData.forEach((ingredientName, ingredientList) {
          ingredientList.forEach((ingredientData) {
            allIngredients.add(IngredientHousehold.fromJson(ingredientData));
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

  Future<void> removeIngredient(IngredientHousehold ingredient) async {
    // Ingredient ingredientToRemove = ingredients.value[index];
    IngredientHousehold ingredientToRemove = ingredient;
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/remove_ingredient_from_household?user_email=${user.value.email}&household_id=$selectedHousehold');

    final Map<String, dynamic> requestBody = {
      "ingredient_id": ingredientToRemove.ingredientId,
      "name": ingredientToRemove.name,
      "amount": ingredientToRemove.amount,
      "unit": ingredientToRemove.unit
    };

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
      // ingredients.value.removeAt(index);
      ingredients.value.remove(ingredientToRemove);
      itemCount(ingredients.value.length);
      update();
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void addIngredient(String id, String name, double amount, String? unit) {
    IngredientHousehold ing = IngredientHousehold(
        ingredientId: id, name: name, amount: amount, unit: unit);
    ingredients.value.add(ing);
    print('in homepage controller the ingredients are : ${ingredients.value}');
    addIngredientToDB(ing);
    update();
  }

  Future<void> addIngredientToDB(Ingredient ingredient) async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/users_household/add_ingredient_to_household_by_ingredient_name?user_email=${user.value.email}&household_id=$selectedHousehold');

    // final Map<String, dynamic> requestBody = {
    //   'ingredient_id': recipeId,
    //   'name': "Lunch",
    //   'amount': 1,
    //   'unit': recipeIngredients,
    // };

    // print(requestBody);

    final http.Response response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(ingredient.toJson()),
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

  void modifyIngredientValues(IngredientHousehold ingredient, bool isNewValue) {
    int index =
        ingredients.value.indexWhere((element) => element == ingredient);
    if (isNewValue) {
      ingredients.value[index].amount = ingredient.amount;
    } else {
      ingredients.value[index].amount =
          ingredients.value[index].amount + ingredient.amount;
    }
    // TODO Update also the firebase
    update();
  }
}
