import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/models/ingredient_model.dart';
import '../constants/dotenv_constants.dart';

class InitializerController extends GetxController {
  RxList<Ingredient> systemIngredients = <Ingredient>[].obs;
  RxList<String> systemIngredientsNames = <String>[].obs;

  Future<void> fetchSystemIngredients() async {
    var url = Uri.parse(
        '${DotenvConstants.baseUrl}/ingredients/getAllSystemIngredients');

    var response = await http.get(url);
    print(response.body);
    List<dynamic> dataIngredients = jsonDecode(response.body);
    for (int i = 0; i < dataIngredients.length; i++) {
      Ingredient r = Ingredient.fromJson(dataIngredients[i]);
      systemIngredients.add(r);
      systemIngredientsNames.add(r.name);
    }
    print(systemIngredients.length);
  }
}
