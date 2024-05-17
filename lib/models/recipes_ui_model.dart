// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:reciperescue_client/models/ingredient_model.dart';

class RecipesUiModel {
  final int id;
  final String title;
  // final String description;
  // final String preparationTime;
  final String image_url;
  final int? likes;
  final List<dynamic> ingredients;

  RecipesUiModel(
      {required this.id,
      required this.title,
      // required this.description,
      // required this.preparationTime,
      required this.ingredients,
      required this.image_url,
      this.likes});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipe_id': id,
      'title': title,
      'image_url': image_url,
      'likes': likes,
      'ingredients': ingredients
    };
  }

  factory RecipesUiModel.fromMap(Map<String, dynamic> map) {
    RecipesUiModel recipe = RecipesUiModel(
        id: map['recipe_id'] as int,
        title: map['recipe_name'] as String,
        image_url: map['image_url'] ?? 'https://picsum.photos/250?image=9',
        likes: map['likes'] as int? ?? 0,
        ingredients: map['ingredients'] as List<dynamic>);
    return recipe;
  }

  String toJson() => json.encode(toMap());

  factory RecipesUiModel.fromJson(String source) =>
      RecipesUiModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipesUiModel{id: $id, title: $title, image: $image_url, likes: $likes}, ingredients: $ingredients';
  }
}
