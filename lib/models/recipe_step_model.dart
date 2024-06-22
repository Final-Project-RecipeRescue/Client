class RecipeStep {
  final List<String> equipment;
  final List<String> ingredients;
  final int length;
  final int number;
  final String description;

  RecipeStep({
    required this.equipment,
    required this.ingredients,
    required this.length,
    required this.number,
    required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      equipment: List<String>.from(json['equipment']),
      ingredients: List<String>.from(json['ingredients']),
      length: json['length'],
      number: json['number'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipment': equipment,
      'ingredients': ingredients,
      'length': length,
      'number': number,
      'description': description,
    };
  }
}
