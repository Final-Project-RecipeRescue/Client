// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RecipesUiModel {
  final int id;
  final String title;
  // final String description;
  // final String preparationTime;
  final String? image;
  final int? likes;

  RecipesUiModel(
      {required this.id,
      required this.title,
      // required this.description,
      // required this.preparationTime,
      this.image,
      this.likes});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image': image,
      'likes': likes,
    };
  }

  factory RecipesUiModel.fromMap(Map<String, dynamic> map) {
    return RecipesUiModel(
      id: map['id'] as int,
      title: map['recipe_name'] as String,
      image: map['image'] as String?,
      likes: map['likes'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipesUiModel.fromJson(String source) =>
      RecipesUiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
