import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import '../colors/colors.dart';
import 'text_field.dart';

class AddFirstIngredients extends StatefulWidget {
  const AddFirstIngredients({Key? key}) : super(key: key);

  @override
  _AddFirstIngredientsState createState() => _AddFirstIngredientsState();
}

class _AddFirstIngredientsState extends State<AddFirstIngredients> {
  late QuestionnaireController controller;

  @override
  void initState() {
    super.initState();
    // Instantiate the controller when the widget is initialized
    controller = Get.put(QuestionnaireController());
    print(controller.countryValue.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        children: [
          Obx(() => Text(
                "What's Already in ${controller.newHouseholdName.value}'s Kitchen?",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: myGrey[900]),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: controller.firstIngredients,
            hintText: "Enter Ingredients",
            onEditingComplete: () =>
                controller.addIngredients(controller.firstIngredients.text),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Obx(() => AnimationLimiter(
                  child: ListView.builder(
                    itemCount: controller.itemCount.value,
                    itemBuilder: ((context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: ListTile(
                              title: Text(controller.ingredients.value[index]),
                              trailing: GestureDetector(
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  controller.removeIngredient(index);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
