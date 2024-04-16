import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';

import '../colors/colors.dart';
import 'text_field.dart';

class AddFirstIngredients extends StatelessWidget {
  const AddFirstIngredients({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<QuestionnaireController>();

    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        children: [
          Text(
            "What's Already in ${controller.nameNewHousehold.value.text}'s Kitchen?",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(color: myGrey[900]),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
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
