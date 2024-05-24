import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/ingredient_details.dart';
import 'package:reciperescue_client/components/show_recipe_details.dart';

import '../models/ingredient_model.dart';

class IngredientListView extends StatelessWidget {
  final int itemCount;
  final List<Ingredient> ingredients;
  final bool isDeleteLogo;
  final ValueChanged<int> onDelete;

  const IngredientListView(
      {super.key,
      required this.itemCount,
      required this.ingredients,
      required this.onDelete,
      required this.isDeleteLogo});

  @override
  Widget build(BuildContext context) {
    return itemCount > 0
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(ingredients[index].name),
                              ),
                              // Add ItemCount widget if necessary
                            ],
                          ),
                          // trailing: isDeleteLogo
                          //     ?
                          //     : null,
                          onTap: () {
                            showIngredientDialog(context, index, () {
                              onDelete(index);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : const Text('No items in this list');
  }

  Future<void> showIngredientDialog(
      context, int index, void Function() onDelete) {
    return AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.noHeader,
            body: IngredientDetails(
              ingredient: ingredients[index],
              onDelete: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
            btnCancelOnPress: onDelete,
            btnCancelText: 'Delete',
            btnCancelColor: primary[900],
            btnCancelIcon: Icons.delete)
        .show();
  }
}
