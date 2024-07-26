class Meal {
  final List<String> users;
  final double numberOfDishes;
  final double co2Score;

  Meal(
      {required this.users,
      required this.numberOfDishes,
      required this.co2Score});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
        users: List<String>.from(json['users']),
        numberOfDishes: json['number_of_dishes']?.toDouble() ?? 0.0,
        co2Score: json['sum_gas_pollution']['CO2']?.toDouble() ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'number_of_dishes': numberOfDishes,
      'co2score': co2Score
    };
  }
}
