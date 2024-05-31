import 'package:get/get.dart';

class ManageIngredientsController extends GetxController {
  // Future<bool> createHousehold() async {
  //   try {
  //     final Uri url = Uri.parse(
  //         '${DotenvConstants.baseUrl}/users_household/createNewHousehold?user_mail=${Authenticate().currentUser!.email}&household_name=${nameNewHousehold.value.text}');

  //     List<Ingredient> ingredients =
  //         Get.find<QuestionnaireController>().ingredients.value;
  //     print("ingredients here: $ingredients");
  //     List<Map<String, dynamic>> householdIngredients =
  //         ingredients.map((ingredient) {
  //       return {
  //         'IngredientName': ingredient.name,
  //         'IngredientAmount': ingredient.amount ?? 1,
  //       };
  //     }).toList();

  //     Map<String, dynamic> requestBody = {'ingredients': householdIngredients};

  //     String requestBodyJson = jsonEncode(requestBody);

  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: requestBodyJson,
  //     );

  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     print('Error making POST request: $error');
  //     return false;
  //   }
  // }
}
