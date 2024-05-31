class Ingredient {
  final String ingredientId;
  final String name;
  late double? amount;
  late String? unit;
  final String? purchaseDate;

  Ingredient({
    required this.ingredientId,
    required this.name,
    required this.amount,
    this.unit,
    this.purchaseDate,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'],
      amount: json['amount']?.toDouble(),
      unit: json['unit'],
      purchaseDate: json['purchase_date'],
    );
  }

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return (other is Ingredient &&
            other.name.toLowerCase() == name.toLowerCase()) ||
        (other is Ingredient && other.ingredientId == ingredientId);
  }

  @override
  int get hashCode => ingredientId.hashCode;

  @override
  String toString() {
    return 'Ingredient{ingredientId: $ingredientId, name: $name, amount: $amount, unit: $unit, purchaseDate: $purchaseDate}';
  }
}
