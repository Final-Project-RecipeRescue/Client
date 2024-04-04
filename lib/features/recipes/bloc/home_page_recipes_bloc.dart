import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reciperescue_client/features/recipes/bloc/model/recipes_ui_model.dart';

part 'home_page_recipes_event.dart';
part 'home_page_recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, HomePageRecipesState> {
  RecipesBloc() : super(HomePageRecipesInitial()) {
    on<FetchInitialRecipes>(fetchInitialRecipes);
  }

  FutureOr<void> fetchInitialRecipes(
      FetchInitialRecipes event, Emitter<HomePageRecipesState> emit) async {
    var url = Uri.parse(
        'http://10.0.2.2:8000/recipes/getRecipesByIngredients?ingredients=banana');
    var response = await http.get(url);
    List<dynamic> dataRecipes = jsonDecode(response.body);
    print(dataRecipes);
    List<dynamic> recipes = [];
    for (dynamic recipe in dataRecipes) {
      recipes.add(RecipesUiModel.fromMap(recipe));
    }
  }
}
