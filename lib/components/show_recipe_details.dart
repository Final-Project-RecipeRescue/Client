import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Column(children: [
      Center(
        child: Text(
          recipeModel.title,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(color: myGrey[1000]),
              fontSize: 18,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: recipeModel.ingredients.length,
          itemBuilder: (context, index) {
            Ingredient ing =
                IngredientHousehold.fromJson(recipeModel.ingredients[index]);
            print('here!! $ing  ${controller.ingredients.value.contains(ing)}');
            Color? colorTitle = controller.ingredients.value.contains(ing)
                ? myGrey[800]
                : primary[800];
            Widget? icon = controller.ingredients.value.contains(ing)
                ? const Icon(Icons.done)
                : const SizedBox();
            return ListTile(
              title: Row(children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      textAlign: TextAlign.start,
                      "${recipeModel.ingredients[index]['amount']} ${recipeModel.ingredients[index]['unit']} ${recipeModel.ingredients[index]['name']}",
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: colorTitle),
                    ),
                  ),
                ),
                icon
              ]),
            );
          },
        ),
      ),
    ]);
  }
}
