// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:reciperescue_client/models/ingredient_model.dart';
// import '../authentication/auth.dart';
// import '../constants/dotenv_constants.dart';
// import 'questionnaire_controller.dart';

// class HouseholdController extends GetxController {
//   final isJoinExistingHousehold = Rx(true);
//   var householdId = "".obs;
//   var newHouseholdName = "".obs;

//   TextEditingController existingHousehold = TextEditingController();
//   TextEditingController nameNewHousehold = TextEditingController();

//   void updateHouseholdName() {
//     newHouseholdName.value = nameNewHousehold.text;
//   }

//   Future<bool> createHousehold() async {
//     try {
//       final Uri url = Uri.parse(
//           '${DotenvConstants.baseUrl}/users_household/createNewHousehold?user_mail=${Authenticate().currentUser!.email}&household_name=${nameNewHousehold.value.text}');

//       List<Ingredient> ingredients =
//           Get.find<QuestionnaireController>().ingredients.value;
//       print("ingredients here: $ingredients");
//       List<Map<String, dynamic>> householdIngredients =
//           ingredients.map((ingredient) {
//         return {
//           'IngredientName': ingredient.name,
//           'IngredientAmount': ingredient.amount ?? 1,
//         };
//       }).toList();

//       Map<String, dynamic> requestBody = {'ingredients': householdIngredients};

//       String requestBodyJson = jsonEncode(requestBody);

//       final response = await http.post(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: requestBodyJson,
//       );

//       if (response.statusCode == 200) {
//         print(response.body);
//         return true;
//       } else {
//         return false;
//       }
//     } catch (error) {
//       print('Error making POST request: $error');
//       return false;
//     }
//   }
// }
