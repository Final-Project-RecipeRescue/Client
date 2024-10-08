import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/components/autocomplete_textfield.dart';
import 'package:reciperescue_client/components/ingredient_details.dart';
import 'package:reciperescue_client/components/ingredients_list_view.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/manage_ingredients_controller.dart';

import 'models/household_model.dart';
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
      body:
          //   Obx(
          // () =>
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Text(
                    "🍴 ${hController.currentHousehold.householdName}'s Ingredients",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: primary,
                    ),
                    textAlign: TextAlign.start,
                  )),
            ),
            GetBuilder<InitializerController>(builder: (controller) {
              return TextfieldAutocomplete<Ingredient>(
                hint: "Add ingredients",
                items: controller.systemIngredients,
                onSubmitted: (Ingredient ingredient) {
                  IngredientHousehold ingredientHousehold = IngredientHousehold(
                      ingredientId: ingredient.ingredientId,
                      name: ingredient.name,
                      amount: 1.0,
                      unit: 'g');
                  showIngredientDialog(context, ingredientHousehold, () {}, () {
                    hController.addIngredient(
                        ingredientHousehold.ingredientId,
                        ingredientHousehold.name,
                        ingredientHousehold.amount,
                        ingredientHousehold.unit);
                    // }
                  });
                },
              );
            }),
            Expanded(
              child: GetBuilder<HomePageController>(builder: (controller) {
                return Obx(() => IngredientListView(
                      itemCount: controller.ingredients.value.length,
                      ingredients: controller.ingredients.value,
                      // onDelete: (index) {
                      //   hController.selectedIngredientsIndex = index;
                      //   controller.removeIngredient(index);
                      // },
                      onClick: (index) {
                        hController.selectedIngredientsIndex = index;
                        IngredientHousehold focusedIngredient =
                            hController.ingredients.value[index];
                        showIngredientDialog(context, focusedIngredient, () {
                          hController.removeIngredient(focusedIngredient);
                        }, () {
                          if (hController.ingredients.value
                              .contains(focusedIngredient)) {
                            hController.modifyIngredientValues(
                                focusedIngredient, true);
                          } else {
                            if (focusedIngredient.amount != 0) {
                              hController.addIngredient(
                                  focusedIngredient.ingredientId,
                                  focusedIngredient.name,
                                  focusedIngredient.amount,
                                  focusedIngredient.unit);
                            }
                          }
                        });
                      },
                      isDeleteLogo: false,
                    ));
              }),
            )
          ],
        ),
      ),
      // )
    );
  }

  Future<void> showIngredientDialog(context, IngredientHousehold ingredient,
      void Function() onDelete, void Function() onAccept) {
    hController.ingredientAmountController.text = ingredient.amount.toString();
    hController.ingredientUnitController.text = ingredient.unit ?? '';
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
              amountController: hController.ingredientAmountController,
              unitController: hController.ingredientUnitController,
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: onAccept,
            btnCancelOnPress: onDelete,
            btnCancelText: 'Delete',
            btnCancelColor: primary[900],
            btnCancelIcon: Icons.delete)
        .show();
  }
}
