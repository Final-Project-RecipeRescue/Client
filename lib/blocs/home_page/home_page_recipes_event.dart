import 'package:flutter/material.dart';

@immutable
sealed class RecipesEvent {}

class FetchInitialRecipes extends RecipesEvent {}

class ShowRecipeDescription extends RecipesEvent {}
