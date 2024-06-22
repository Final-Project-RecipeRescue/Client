import 'ingredient_model.dart';
import 'meal_model.dart';

class Household {
  final String householdId;
  final String householdName;
  final String? householdImage;
  final List<String> participants;
  final Map<String, List<Ingredient>> ingredients;
  final Map<DateTime, Map<String, Map<String, List<Meal>>>> meals;

  Household({
    required this.householdId,
    required this.householdName,
    this.householdImage,
    required this.participants,
    required this.ingredients,
    required this.meals,
  });

  factory Household.fromJson(Map<String, dynamic> json) {
    Map<String, List<IngredientHousehold>> ingredients = {};
    json['ingredients'].forEach((key, value) {
      ingredients[key] = List<IngredientHousehold>.from(
          value.map((item) => IngredientHousehold.fromJson(item)));
    });

    Map<DateTime, Map<String, Map<String, List<Meal>>>> meals = {};
    json['meals'].forEach((date, mealTypes) {
      Map<String, Map<String, List<Meal>>> mealMap = {};
      mealTypes.forEach((mealType, dishes) {
        mealMap[mealType] = {};
        dishes.forEach((dishId, mealDetails) {
          mealMap[mealType]![dishId] =
              List<Meal>.from(mealDetails.map((item) => Meal.fromJson(item)));
        });
      });
      meals[DateTime.parse(date)] = mealMap;
    });

    return Household(
      householdId: json['household_id'],
      householdName: json['household_name'],
      householdImage: json['household_image'],
      participants: List<String>.from(json['participants']),
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
      'participants': participants,
      'ingredients': ingredientsJson,
      'meals': mealsJson,
    };
  }

  @override
  String toString() {
    return 'Household(householdId: $householdId, householdName: $householdName, householdImage: $householdImage, participants: $participants, ingredients: ${ingredients.length}, meals: ${meals.length})';
  }
}
