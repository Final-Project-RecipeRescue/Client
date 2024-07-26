import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/models/ingredient_model.dart';
import '../constants/dotenv_constants.dart';

class InitializerController extends GetxController {
  RxList<IngredientSystem> systemIngredients = <IngredientSystem>[].obs;
  int _selectedIngredientsIndex = 0;

  int get selectedIngredientsIndex => _selectedIngredientsIndex;

  set selectedIngredientsIndex(int index) {
    _selectedIngredientsIndex = index;
    update();
  }

  Future<void> fetchSystemIngredients() async {
    var url = Uri.parse(
        '${DotenvConstants.baseUrl}/ingredients/getAllSystemIngredients');
    List<IngredientSystem> fetchedIngredients = [];
    var response = await http.get(url);
    List<dynamic> dataIngredients = jsonDecode(response.body);
    for (int i = 0; i < dataIngredients.length; i++) {
      IngredientSystem r = IngredientSystem.fromJson(dataIngredients[i]);
      fetchedIngredients.add(r);
    }
    systemIngredients(fetchedIngredients);
  }

  @override
  void onInit() {
    super.onInit();
    fetchSystemIngredients();
  }
}
