part of 'home_page_recipes_bloc.dart';

@immutable
sealed class HomePageRecipesState {}

sealed class RecipesActionState extends HomePageRecipesState {}

final class HomePageRecipesInitial extends HomePageRecipesState {}

final class RecipesSuccefulState extends HomePageRecipesState {
  final List<RecipesUiModel> recipes;
  RecipesSuccefulState({required this.recipes});
}
