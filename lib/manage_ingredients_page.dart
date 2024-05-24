import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/components/ingredients_list_view.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';

class ManageIngredientsPage extends StatefulWidget {
  const ManageIngredientsPage({super.key});

  @override
  State<ManageIngredientsPage> createState() => _ManageIngredientsPageState();
}

class _ManageIngredientsPageState extends State<ManageIngredientsPage> {
  HomePageController controller = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Column(
        children: [
          MyDropdown(
              selectedValue: controller.selectedHousehold.value,
              items: controller.user.value.households,
              onChanged: (householdId) {
                if (controller.selectedHousehold.value != householdId) {
                  controller.fetchHouseholdsIngredients(householdId!);
                }
              }),
          Expanded(
            child: Obx(() => IngredientListView(
                  itemCount: controller.ingredients.value.length,
                  ingredients: controller.ingredients.value,
                  onDelete: (index) {
                    controller.removeIngredient(index);
                  },
                  isDeleteLogo: false,
                )),
          )
        ],
      ),
    ));
  }
}
