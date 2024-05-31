import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/components/autocomplete_textfield.dart';
import 'package:reciperescue_client/components/ingredient_details.dart';
import 'package:reciperescue_client/components/ingredients_list_view.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/manage_ingredients_controller.dart';

import 'models/ingredient_model.dart';

class ManageIngredientsPage extends StatefulWidget {
  const ManageIngredientsPage({super.key});

  @override
  State<ManageIngredientsPage> createState() => _ManageIngredientsPageState();
}

class _ManageIngredientsPageState extends State<ManageIngredientsPage> {
  HomePageController hController = Get.find<HomePageController>();
  ManageIngredientsController miController =
      Get.put(ManageIngredientsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Column(
        children: [
          MyDropdown(
              selectedValue: hController.selectedHousehold.value,
              items: hController.user.value.households,
              onChanged: (householdId) {
                if (hController.selectedHousehold.value != householdId) {
                  hController.fetchHouseholdsIngredients(householdId!);
                }
              }),
          GetBuilder<InitializerController>(builder: (controller) {
            return TextfieldAutocomplete<Ingredient>(
              items: controller.systemIngredients.map((e) => e.name),
              onSubmitted: (Ingredient ingredient) {
                // hController.addIngredient(ingredient.ingredientId,
                //     ingredient.name, ingredient.amount, ingredient.unit);
                showIngredientDialog(context, ingredient, () {});
              },
            );
          }),
          Expanded(
            child: GetBuilder<HomePageController>(builder: (controller) {
              return IngredientListView(
                itemCount: controller.ingredients.value.length,
                ingredients: controller.ingredients.value,
                // onDelete: (index) {
                //   hController.selectedIngredientsIndex = index;
                //   controller.removeIngredient(index);
                // },
                onClick: (index) {
                  hController.selectedIngredientsIndex = index;
                  Ingredient focusedIngredient =
                      hController.ingredients.value[index];
                  print('focused ${focusedIngredient.toString()}');
                  showIngredientDialog(context, focusedIngredient, () {
                    hController.removeIngredient(focusedIngredient);
                  });
                },
                isDeleteLogo: false,
              );
            }),
          )
        ],
      ),
    ));
  }

  Future<void> showIngredientDialog(
      context, Ingredient ingredient, void Function() onDelete) {
    return AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.noHeader,
            body: IngredientDetails(
              ingredient: ingredient,
              onDelete: () {
                // onDelete();
                Navigator.pop(context);
              },
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () => hController.addIngredient(
                ingredient.ingredientId,
                ingredient.name,
                ingredient.amount,
                ingredient.unit),
            btnCancelOnPress: onDelete,
            btnCancelText: 'Delete',
            btnCancelColor: primary[900],
            btnCancelIcon: Icons.delete)
        .show();
  }
}
