part of 'home_page_recipes_bloc.dart';

@immutable
abstract class HomePageRecipesState {}

abstract class RecipesActionState extends HomePageRecipesState {}

final class HomePageRecipesInitial extends HomePageRecipesState {}

final class RecipesSuccefulState extends HomePageRecipesState {
  final List<RecipesUiModel> recipes;
  RecipesSuccefulState({required this.recipes});
}

final class RecipesErrorState extends HomePageRecipesState {}

final class RecipesLoadingState extends HomePageRecipesState {}

final class DescriptionState extends RecipesActionState {}
