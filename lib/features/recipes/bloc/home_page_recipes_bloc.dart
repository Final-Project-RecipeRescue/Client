import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8000/recipes/getRecipesByIngredients?ingredients=banana');
      var response = await http.get(url);
      List<dynamic> dataRecipes = jsonDecode(response.body);
      List<RecipesUiModel> recipes = [];
      print(dataRecipes.length);

      for (int i = 0; i < dataRecipes.length; i++) {
        print(dataRecipes[i]['image_url']);
        RecipesUiModel r = RecipesUiModel.fromMap(dataRecipes[i]);
        recipes.add(r);
      }

      emit(RecipesSuccefulState(recipes: recipes));
    } catch (e) {
      log(e.toString());
    }
  }
}
