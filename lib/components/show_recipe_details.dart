import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';

import '../colors/colors.dart';
import '../models/ingredient_model.dart';

class RecipeDetail extends StatelessWidget {
  final RecipesUiModel recipeModel;
  final HomePageController controller = Get.find<HomePageController>();
  RecipeDetail({required this.recipeModel});
  @override
  Widget build(BuildContext context) {
    print("dialog ${controller.ingredients.toString()}");
    return AlertDialog(
      title: Text(recipeModel.title),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: recipeModel.ingredients.length,
          itemBuilder: (context, index) {
            print("dialog ${recipeModel.ingredients[index]}");
            Color? colorTitle = controller.ingredients.value.contains(
                    Ingredient.fromJson(recipeModel.ingredients[index]))
                ? myGrey[800]
                : primary[800];
            return ListTile(
              title: Text(
                "${recipeModel.ingredients[index]['amount']} ${recipeModel.ingredients[index]['unit']} ${recipeModel.ingredients[index]['name']}",
                style: TextStyle(color: colorTitle),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Use this recipe'),
          onPressed: () {
            Navigator.of(context).pop();
            // controller.substractRecipeIngredients(
            //     recipeModel.ingredients.map((e) => ), recipeModel.id
            //     );
          },
        ),
      ],
    );
  }
}
