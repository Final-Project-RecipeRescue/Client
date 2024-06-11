import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:reciperescue_client/constants/dotenv_constants.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/models/recipes_ui_model.dart';

class RecipeInstructionsController extends GetxController {
  RxList<String> steps = <String>[].obs;
  late RecipesUiModel recipe;

  RecipeInstructionsController(RecipesUiModel value) {
    this.recipe = value;
  }

  @override
  void onInit() {
    super.onInit();
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
}
