part of 'home_page_recipes_bloc.dart';

@immutable
sealed class HomePageRecipesState {}

abstract class RecipesSuccefulState extends HomePageRecipesState {}

final class HomePageRecipesInitial extends HomePageRecipesState {}
