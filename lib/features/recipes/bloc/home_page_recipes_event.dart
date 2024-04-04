part of 'home_page_recipes_bloc.dart';

@immutable
sealed class RecipesEvent {}

class FetchInitialRecipes extends RecipesEvent {}
