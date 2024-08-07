import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/components/autocomplete_textfield.dart';
import 'package:reciperescue_client/components/ingredient_details.dart';
import 'package:reciperescue_client/controllers/household_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import '../colors/colors.dart';
import '../models/ingredient_model.dart';
import 'ingredients_list_view.dart';

class AddFirstIngredients extends StatefulWidget {
  const AddFirstIngredients({Key? key}) : super(key: key);

  @override
  _AddFirstIngredientsState createState() => _AddFirstIngredientsState();
}

class _AddFirstIngredientsState extends State<AddFirstIngredients> {
  QuestionnaireController qController = Get.find();
  HouseholdController hController = Get.find();
  int ingredient_index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: GetBuilder<QuestionnaireController>(builder: (controller) {
          return Column(children: [
            Obx(() => Text(
                  "What's already in ${hController.newHouseholdName.value}'s kitchen?",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: myGrey[900]),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            // GetBuilder<InitializerController>(builder: (controller) {
            //   return
            TextfieldAutocomplete<Ingredient>(
              items: Get.find<InitializerController>().systemIngredients,
              onSubmitted: (Ingredient ingredient) {
                IngredientHousehold ingredientHousehold = IngredientHousehold(
                    ingredientId: ingredient.ingredientId,
                    name: ingredient.name,
                    amount: 1.0,
                    unit: 'g');
                showIngredientDialog(context, ingredientHousehold, () {}, () {
                  if (qController.ingredients.value.contains(ingredient)) {
                    qController.modifyIngredientValues(
                        ingredientHousehold, false);
                  } else {
                    if (ingredientHousehold.amount != 0) {
                      qController.addIngredient(
                          ingredientHousehold.ingredientId,
                          ingredientHousehold.name,
                          ingredientHousehold.amount,
                          ingredientHousehold.unit);
                    }
                  }
                });
                // },
                // );
              },
              hint: 'Search ingredients',
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(() {
              return IngredientListView(
                itemCount: qController.ingredients.value.length,
                ingredients: qController.ingredients.value,
                onClick: (index) {
                  print(qController.ingredients.value);
                  showIngredientDialog(
                    context,
                    qController.ingredients.value[index],
                    () => qController.removeIngredient(index),
                    () => qController.modifyIngredient(index),
                  );
                },
                isDeleteLogo: false,
              );
            })
          ]);
        }));
    // );
    //           IngredientListView(
    //             itemCount: qController.itemCount.value,
    //             ingredients: qController.ingredients.value,
    //             onClick: (index) {
    //               // setState(() {
    //               showIngredientDialog(
    //                   context,
    //                   qController.ingredients.value[index],
    //                   () => qController.removeIngredient(index),
    //                   () => qController.modifyIngredient(index));
    //             },
    //             isDeleteLogo: false,
    //           ),
    //         ],
    //       )),
    // );
    // return Scaffold(
    //   body: Column(
    //     children: [
    // GetBuilder<InitializerController>(builder: (controller) {
    //   return TextfieldAutocomplete<Ingredient>(
    //     items: controller.systemIngredients,
    //     onSubmitted: (Ingredient ingredient) {
    //       IngredientHousehold ingredientHousehold = IngredientHousehold(
    //         ingredientId: ingredient.ingredientId,
    //         name: ingredient.name,
    //         amount: 1.0,
    //         unit: 'g',
    //       );
    //       showIngredientDialog(context, ingredientHousehold, () {}, () {
    //         if (qController.ingredients.value.contains(ingredient)) {
    //           qController.modifyIngredientValues(
    //             ingredientHousehold,
    //             false,
    //           );
    //         } else {
    //           qController.addIngredient(
    //             ingredientHousehold.ingredientId,
    //             ingredientHousehold.name,
    //             ingredientHousehold.amount,
    //             ingredientHousehold.unit,
    //           );
    //         }
    //       });
    //     },
    //   );
    // }),
    // Expanded(
    //   child: GetBuilder<QuestionnaireController>(builder: (controller) {
    //     return

    // );
    //   }),
    // ),
  }

  Future<void> showIngredientDialog(context, IngredientHousehold ingredient,
      void Function() onDelete, void Function() onAccept) {
    qController.ingredientAmountController.text = ingredient.amount.toString();
    qController.ingredientUnitController.text = ingredient.unit ?? '';
    return AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.noHeader,
            body: IngredientDetails(
              ingredient: ingredient,
              onDelete: () {
                Navigator.pop(context);
              },
              amountController: qController.ingredientAmountController,
              unitController: qController.ingredientUnitController,
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: onAccept,
            btnCancelOnPress: onDelete,
            btnCancelText: 'Delete',
            btnOkText: 'Add',
            btnCancelColor: primary[900],
            btnCancelIcon: Icons.delete)
        .show();
  }
}
