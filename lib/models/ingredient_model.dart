class Ingredient {
  final int ingredientId;
  final String name;
  final double? amount;
  final String? unit;
  final String? purchaseDate;

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
    return 'Ingredient{ingredientId: $ingredientId, name: $name, amount: $amount, unit: $unit, purchaseDate: $purchaseDate}';
  }
}
