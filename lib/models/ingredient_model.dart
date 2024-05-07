class Ingredient {
  final String ingredientId;
  final String name;
  final double?
      amount; // Making amount nullable since it's provided as null in the JSON
  final String?
      unit; // Making unit nullable since it's provided as null in the JSON
  final String?
      purchaseDate; // Making purchaseDate nullable since it's provided as null in the JSON

  Ingredient({
    required this.ingredientId,
    required this.name,
    this.amount,
    this.unit,
    this.purchaseDate,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientId: json['ingredient_id'],
      name: json['name'],
      amount: json['amount']?.toDouble(),
      unit: json['unit'],
      purchaseDate: json['purchase_date'],
    );
  }
}
