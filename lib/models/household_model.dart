import 'ingredient_model.dart';
import 'meal_model.dart';
import 'user_model.dart'; // Import the UserModel class

class Household {
  final String householdId;
  final String householdName;
  final String? householdImage;
  final List<UserModel> participants; // Change the type to List<UserModel>
  final Map<String, List<IngredientHousehold>> ingredients;
  final Map<DateTime, Map<String, Map<String, List<Meal>>>> meals;

  Household({
    required this.householdId,
    required this.householdName,
    this.householdImage,
    required this.participants,
    required this.ingredients,
    required this.meals,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Household && other.householdId == householdId;
  }

  @override
  int get hashCode => householdId.hashCode;

  factory Household.fromJson(Map<String, dynamic> json) {
    print('im a json $json');
    Map<String, List<IngredientHousehold>> ingredients = {};
    json['ingredients'].forEach((key, value) {
      ingredients[key] = List<IngredientHousehold>.from(
          value.map((item) => IngredientHousehold.fromJson(item)));
    });

    Map<DateTime, Map<String, Map<String, List<Meal>>>> meals = {};
    json['meals'].forEach((date, mealTypes) {
      var mealsDate = DateTime.parse(date);
      meals[mealsDate] = {};
      mealTypes.forEach((mealType, dishes) {
        meals[mealsDate]?[mealType] = {};
        dishes.forEach((dishId, mealDetails) {
          meals[mealsDate]?[mealType]?[dishId] =
              List<Meal>.from(mealDetails.map((item) => Meal.fromJson(item)));
        });
      });
    });
    return Household(
      householdId: json['household_id'],
      householdName: json['household_name'],
      householdImage: json['household_image'],
      participants: List<UserModel>.from(
          json['participants'].map((item) => UserModel.fromJson(item))),
      ingredients: ingredients,
      meals: meals,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ingredientsJson = {};
    ingredients.forEach((key, value) {
      ingredientsJson[key] = value.map((item) => item.toJson()).toList();
    });

    Map<String, dynamic> mealsJson = {};
    meals.forEach((date, mealTypes) {
      Map<String, dynamic> mealTypeJson = {};
      mealTypes.forEach((mealType, dishes) {
        Map<String, dynamic> dishJson = {};
        dishes.forEach((dishId, mealDetails) {
          dishJson[dishId] = mealDetails.map((item) => item.toJson()).toList();
        });
        mealTypeJson[mealType] = dishJson;
      });
      mealsJson[date.toIso8601String()] = mealTypeJson;
    });

    return {
      'household_id': householdId,
      'household_name': householdName,
      'household_image': householdImage,
      'participants': participants.map((item) => item.toJson()).toList(),
      'ingredients': ingredientsJson,
      'meals': mealsJson,
    };
  }

  @override
  String toString() {
    return 'Household(householdId: $householdId, householdName: $householdName, householdImage: $householdImage, participants: $participants, ingredients: ${ingredients.length}, meals: ${meals.length})';
  }
}
