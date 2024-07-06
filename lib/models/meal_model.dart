class Meal {
  final List<String> users;
  final double numberOfDishes;

  Meal({
    required this.users,
    required this.numberOfDishes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      users: List<String>.from(json['users']),
      numberOfDishes: json['number_of_dishes']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'number_of_dishes': numberOfDishes,
    };
  }
}
