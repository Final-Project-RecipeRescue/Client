import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reciperescue_client/blocs/home_page/home_page_recipes_event.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';
import 'package:reciperescue_client/blocs/home_page/repos/recipes_repo.dart';

part 'home_page_recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, HomePageRecipesState> {
  RecipesBloc() : super(HomePageRecipesInitial()) {
    on<FetchInitialRecipes>(fetchInitialRecipes);
    on<ShowRecipeDescription>(fetchDescription);
  }

  FutureOr<void> fetchInitialRecipes(
      FetchInitialRecipes event, Emitter<HomePageRecipesState> emit) async {
    try {
      emit(RecipesLoadingState());
      List<RecipesUiModel> recipes = await RecipesRepo.fetchHouseholdRecipes();
      emit(RecipesSuccefulState(recipes: recipes));
    } catch (e) {
      emit(RecipesErrorState());
      log(e.toString());
    }
  }

  FutureOr<void> fetchDescription(
      ShowRecipeDescription event, Emitter<HomePageRecipesState> emit) async {
    emit(DescriptionState());
  }
}
