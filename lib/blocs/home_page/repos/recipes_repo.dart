import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/constants/dotenv_constants.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';

class RecipesRepo {
  static Future<List<RecipesUiModel>> fetchHouseholdRecipes() async {
    var url = Uri.parse(
        '${DotenvConstants.baseUrl}/recipes/getRecipesByIngredients?ingredients=banana');
    var response = await http.get(url);
    List<dynamic> dataRecipes = jsonDecode(response.body);
    List<RecipesUiModel> recipes = [];
    print(dataRecipes.length);

    for (int i = 0; i < dataRecipes.length; i++) {
      print(dataRecipes[i]['image_url']);
      RecipesUiModel r = RecipesUiModel.fromMap(dataRecipes[i]);
      recipes.add(r);
    }

    return recipes;
  }
}
