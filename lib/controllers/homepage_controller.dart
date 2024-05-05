import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import '../models/recipes_ui_model.dart';

class HomePageController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool hasError = RxBool(false);
  final Rx<List<RecipesUiModel>> recipes = Rx([]);
  final Rx<List<String>> ingredients = Rx([]);

  Future<void> fetchHouseholdRecipes() async {
    String concatenatedIngredients = ingredients.value.join(',');
    print('here $concatenatedIngredients');
    var url = Uri.parse(
        'http://10.0.2.2:8000/recipes/getRecipesByIngredients?ingredients=$concatenatedIngredients');
    try {
      isLoading.value = true;
      hasError.value = false;
      var response = await http.get(url);
      List<dynamic> dataRecipes = jsonDecode(response.body);
      print(dataRecipes.length);
      if (response.statusCode == 200) {
        for (int i = 0; i < dataRecipes.length; i++) {
          print(dataRecipes[i]['image_url']);
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
  void onInit() {
    super.onInit();
    QuestionnaireController qCtrl = Get.find<QuestionnaireController>();
    setIngredients(qCtrl.ingredients.value);
    fetchHouseholdRecipes();
  }

  void setIngredients(List<String> value) {
    ingredients.value = value;
    update();
  }
}
