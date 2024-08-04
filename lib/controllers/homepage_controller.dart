import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';
import 'package:reciperescue_client/models/meal_model.dart';
import 'package:reciperescue_client/models/user_model.dart';

import '../constants/dotenv_constants.dart';
import '../models/household_model.dart';
import '../models/recipes_ui_model.dart';

class HomePageController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final Rx<List<RecipesUiModel>> recipes = Rx([]);
  late List<RecipesUiModel> recipesSortedByMix;
  final Rx<List<IngredientHousehold>> ingredients = Rx([]);
  final Rx<List<Household>> userHouseholdsList = Rx([]);
  var itemCount = 0.obs;
  late Rx<UserModel> user = Rx(UserModel());
  final Rx<HomepageSortType> selectedSort = Rx(HomepageSortType.byMix);
  final selectedHousehold = ''.obs;
  int _selectedIngredientsIndex = 0;
  String _recipesFetchErrorMsg = '';
  final Rx<Household> _currentHousehold = Household(
    householdId: '',
    householdName: '',
    participants: [],
    ingredients: {},
    meals: {},
  ).obs;
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

  Household get currentHousehold => _currentHousehold.value;

  set currentHousehold(Household household) {
    _currentHousehold.value = household;
    ingredients.value = currentHousehold.ingredients.values
        .expand((ingredientList) => ingredientList)
        .toList();
    update();
  }

  Future<void> fetchHouseholdRecipes() async {
    String concatenatedIngredients =
        ingredients.value.map((e) => e.name).join(',');
    List<RecipesUiModel> tempRecipes = [];
    print('household id: ${currentHousehold.householdId}');
    var urlWithoutMissedIngredients = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getAllRecipesThatHouseholdCanMake?user_email=${Authenticate().currentUser!.email}&household_id=${currentHousehold.householdId}');
    var urlWithMissedIngredients = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipesByIngredients?ingredients=$concatenatedIngredients');

    await _fetchData(urlWithoutMissedIngredients);
    if (recipes.value.isEmpty && !hasError.value) {
      await _fetchData(urlWithMissedIngredients);
    }
    recipesSortedByMix = recipes.value;
    print(recipesSortedByMix.toString());
  }

  Future<void> _fetchData(Uri url) async {
    List<RecipesUiModel> tempRecipes = [];
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
        print('recipes ${dataRecipes}');

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
    await fetchHouseholds(Authenticate().currentUser!.email);
    currentHousehold = userHouseholdsList.value[0];
    var elapsedHousehold = DateTime.now().difference(now).inMilliseconds;
    print("on init fetchHousehold in ${elapsedHousehold}ms");

    now = DateTime.now();
    await fetchHouseholdsIngredients(currentHousehold.householdId);
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

  Future<void> fetchHouseholds(String? userEmail) async {
    isLoading.value = true;
    final url = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getAllHouseholdsByUserEmail?user_email=$userEmail');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response data: ${response.body}');

        final List<Household> households = data.entries.map((entry) {
          return Household.fromJson(entry.value);
        }).toList();

        userHouseholdsList.value = households;

        update();
      } else {
        print('Failed to load households: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching households: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserInfo() async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getUser?user_email=${Authenticate().currentUser!.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print(
            'Failed to fetch user information. Status code: ${response.statusCode}');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      user.value = UserModel.fromJson(data);
      refresh();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchHouseholdsIngredients(String householdId) async {
    isLoading(true);
    hasError(false);
    // selectedHousehold(householdId);

    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getAllIngredientsInHousehold?user_email=${user.value.email}&household_id=${currentHousehold.householdId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        //TODO handle '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'
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
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/removeIngredientFromHousehold?user_email=${user.value.email}&household_id=${currentHousehold.householdId}');

    final Map<String, dynamic> requestBody = {
      "ingredient_id": ingredientToRemove.ingredientId,
      "name": ingredientToRemove.name,
      "amount": ingredientToRemove.amount,
      "unit": ingredientToRemove.unit
    };

    print(requestBody.toString());

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
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/addIngredientToHouseholdByIngredientName?user_email=${user.value.email}&household_id=${currentHousehold.householdId}');

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
      ingredients.value.remove(ingredient);
      update();
      Get.snackbar('Success', 'Ingredient added successfully',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primary);
      Get.snackbar('Error', response.body.toString(),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primary[900]);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void modifyIngredientValues(IngredientHousehold ingredient, bool isNewValue) {
    updateIngredientInDB(ingredient.toJson());
    int index =
        ingredients.value.indexWhere((element) => element == ingredient);
    if (isNewValue) {
      ingredients.value[index].amount = ingredient.amount;
    } else {
      ingredients.value[index].amount =
          ingredients.value[index].amount + ingredient.amount;
    }
    update();
  }

  Future<void> updateIngredientInDB(Map<String, dynamic> ingredientJson) async {
    try {
      final Uri url = Uri.parse(
          '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/updateIngredientInHousehold?user_email=${Authenticate().currentUser!.email}&household_id=${currentHousehold.householdId}');

      Map<String, dynamic> data = {
        "ingredient_data": {
          "ingredient_id": ingredientJson['ingredient_id'].toString(),
          "name": ingredientJson['name'],
          "amount": ingredientJson['amount'],
          "unit": ingredientJson['unit']
        },
        "date": {
          "year": DateTime.now().year,
          "month": DateTime.now().month,
          "day": DateTime.now().day
        }
      };

      // Send the HTTP POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Check the response status
      if (response.statusCode == 200) {
        Get.snackbar(
            'Success', 'Ingredient updated successfully in the database.',
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primary);
      } else {
        Get.snackbar('Error', 'Failed to update ingredient',
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primary[900]);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating ingredient',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primary[900]);
    }
  }

  Future<void> sort(HomepageSortType sortType) async {
    List<RecipesUiModel> sortedList = List.from(recipes.value);
    selectedSort.value = sortType;
    print(selectedSort.value);
    switch (sortType) {
      case HomepageSortType.byPollution:
        sortedList
            .sort((a, b) => b.sumGasPollution.compareTo(a.sumGasPollution));
        break;
      case HomepageSortType.byMix:
        sortedList = recipesSortedByMix;
        break;
      case HomepageSortType.byDateExpiration:
        sortedList.sort((a, b) =>
            a.closestExpirationDays.compareTo(b.closestExpirationDays));
        break;
    }
    recipes.value = sortedList;
    update();
  }

  Household getHousehold(String? value) {
    return userHouseholdsList.value
        .where((element) => element.householdName == value)
        .first;
  }
}

enum HomepageSortType {
  byPollution('Pollution'),
  byMix('Mix'),
  byDateExpiration('DateExpiration');

  final String description;

  const HomepageSortType(this.description);

  static HomepageSortType fromDescription(String sortType) {
    for (HomepageSortType st in HomepageSortType.values) {
      if (st.description == sortType) {
        return st;
      }
    }
    throw Exception('Invalid description for enum HomepageSortType');
  }
}
