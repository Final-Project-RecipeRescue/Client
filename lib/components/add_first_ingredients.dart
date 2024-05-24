import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/components/autocomplete_textfield.dart';
import 'package:reciperescue_client/controllers/household_controller.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import '../colors/colors.dart';
import 'ingredients_list_view.dart';

class AddFirstIngredients extends StatefulWidget {
  const AddFirstIngredients({Key? key}) : super(key: key);

  @override
  _AddFirstIngredientsState createState() => _AddFirstIngredientsState();
}

class _AddFirstIngredientsState extends State<AddFirstIngredients> {
  late QuestionnaireController qController;
  HouseholdController hController = Get.find<HouseholdController>();

  @override
  void initState() {
    super.initState();
    // Instantiate the controller when the widget is initialized
    qController = Get.put(QuestionnaireController());
    print(qController.countryValue.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
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
          TextfieldAutocomplete(
              items: Get.find<InitializerController>()
                  .systemIngredients
                  .value
                  .map((e) => e.name)),
          const SizedBox(
            height: 40,
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height / 3,
          //   child: Obx(() => AnimationLimiter(
          //         child: ListView.builder(
          //           itemCount: qController.itemCount.value,
          //           itemBuilder: ((context, index) {
          //             print('ingredients: ${qController.ingredients.value}');
          //             return AnimationConfiguration.staggeredList(
          //               position: index,
          //               duration: const Duration(milliseconds: 375),
          //               child: SlideAnimation(
          //                 verticalOffset: 50.0,
          //                 child: FadeInAnimation(
          //                   child: ListTile(
          //                     title: Row(
          //                       children: [
          //                         Text(qController
          //                             .ingredients.value[index].name),
          //                         // ItemCount(
          //                         //   initialValue: 1,
          //                         //   minValue: qController
          //                         //       .ingredients.value[index].amount,
          //                         //   maxValue: 100,
          //                         //   decimalPlaces: 0,
          //                         //   onChanged: (value) {
          //                         //     // Handle counter value changes
          //                         //     print('Selected value: $value');
          //                         //   },
          //                         // ),
          //                       ],
          //                     ),
          //                     trailing: GestureDetector(
          //                       child: const Icon(
          //                         Icons.delete,
          //                         color: Colors.red,
          //                       ),
          //                       onTap: () {
          //                         qController.removeIngredient(index);
          //                       },
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }),
          //         ),
          //       )),
          // )
          Obx(() => IngredientListView(
                itemCount: qController.itemCount.value,
                ingredients: qController.ingredients.value,
                onDelete: (index) {
                  qController.removeIngredient(index);
                },
                isDeleteLogo: true,
              )),
        ],
      ),
    );
  }
}
