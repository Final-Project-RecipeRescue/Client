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
        return Column(
          children: [
            Obx(() => Text(
                  "What's Already in ${hController.newHouseholdName.value}'s Kitchen?",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: myGrey[900]),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            TextfieldAutocomplete<Ingredient>(
              items: Get.find<InitializerController>()
                  .systemIngredients
                  .map((e) => e.name),
              onSubmitted: (Ingredient ingredient) {
                showIngredientDialog(context, ingredient, () {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(() => IngredientListView(
                  itemCount: controller.itemCount.value,
                  ingredients: controller.ingredients.value,
                  // onDelete: (index) {
                  //   setState(() {
                  //     ingredient_index = index;
                  //     qController.removeIngredient(index);
                  //   });
                  // },
                  onClick: (index) {
                    // setState(() {
                    showIngredientDialog(
                        context,
                        controller.ingredients.value[index],
                        () => controller.removeIngredient(index));
                    // qController.update();
                    // });
                  },
                  isDeleteLogo: false,
                )),
          ],
        );
      }),
    );
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
            btnOkOnPress: () {
              qController.addIngredient(ingredient.ingredientId,
                  ingredient.name, ingredient.amount, ingredient.unit);
            },
            btnCancelOnPress: onDelete,
            btnCancelText: 'Delete',
            btnCancelColor: primary[900],
            btnCancelIcon: Icons.delete)
        .show();
  }
}
