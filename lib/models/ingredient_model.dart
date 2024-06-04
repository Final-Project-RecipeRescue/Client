abstract class Ingredient {
  final String ingredientId;
  final String name;

  Ingredient({
    required this.ingredientId,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
        'fromJson() has not been implemented for Ingredient');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ingredient && other.ingredientId == ingredientId ||
        other is Ingredient && other.name.toLowerCase() == name.toLowerCase();
  }

  @override
  int get hashCode => ingredientId.hashCode ^ name.toLowerCase().hashCode;

  Map<String, dynamic> toJson();
}

class IngredientSystem extends Ingredient {
  IngredientSystem({
    required String ingredientId,
    required String name,
  }) : super(ingredientId: ingredientId, name: name);

  factory IngredientSystem.fromJson(Map<String, dynamic> json) {
    return IngredientSystem(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ingredient_id': ingredientId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'IngredientSystem{ingredientId: $ingredientId, name: $name}';
  }
}

class IngredientHousehold extends Ingredient {
  double amount;
  String? unit;
  String? purchaseDate;

  IngredientHousehold({
    required String ingredientId,
    required String name,
    required this.amount,
    required this.unit,
    this.purchaseDate,
  }) : super(ingredientId: ingredientId, name: name);

  factory IngredientHousehold.fromJson(Map<String, dynamic> json) {
    return IngredientHousehold(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
      amount: json['amount']?.toDouble() ?? 0.0,
      unit: json['unit'] as String?,
      purchaseDate: json['purchase_date'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ingredient_id': ingredientId,
      'name': name,
      'amount': amount,
      'unit': unit,
      'purchase_date': purchaseDate,
    };
  }

  @override
  String toString() {
    return 'IngredientHousehold{ingredientId: $ingredientId, name: $name, amount: $amount, unit: $unit, purchaseDate: $purchaseDate}';
  }
}
