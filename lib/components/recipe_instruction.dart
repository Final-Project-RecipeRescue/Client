import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/recipe_image.dart';
import 'package:reciperescue_client/components/user_egg.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/recipe_instructions_controller.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';
import 'package:reciperescue_client/models/user_model.dart';

class RecipeInstructions extends StatefulWidget {
  final RecipesUiModel value;
  late final RecipeInstructionsController controller;

  RecipeInstructions(this.value, {super.key}) {
    controller = Get.put(RecipeInstructionsController(value));
  }

  @override
  State<RecipeInstructions> createState() => _RecipeInstructionsState();
}

class _RecipeInstructionsState extends State<RecipeInstructions> {
  int dishCount = 0;
  Set<String> selectedParticipants = {};

  void _incrementDishes() {
    setState(() {
      dishCount++;
    });
  }

  void _decrementDishes() {
    setState(() {
      dishCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecipeImage(imageUrl: widget.value.imageUrl),
                const SizedBox(height: 10),
                Text(
                  widget.value.title,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView.separated(
                    itemCount: widget.controller.steps.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1, // Adjust divider height as needed
                      color: myGrey[50], // Customize divider color
                    ),
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: index.isEven ? myGrey[50] : primary[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Consistent padding around content
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content vertically
                          children: [
                            const SizedBox(
                                width: 12.0), // Spacing between icon and text
                            Expanded(
                              child: Text(
                                widget.controller.steps[index],
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.controller.household.participants.length,
                    itemBuilder: (context, index) {
                      List<UserModel> participants =
                          widget.controller.household.participants.toList();
                      return SizedBox(
                        height: 20,
                        width: 80,
                        child: UserEgg(
                          user: UserModel(
                              firstName: participants[index].firstName,
                              lastName: participants[index].lastName),
                          onSelect: () {
                            addParticipant(participants[index].email!);
                            _incrementDishes();
                            print(selectedParticipants);
                          },
                          onDeselect: () {
                            removePaticipant(participants[index].email!);
                            _decrementDishes;
                            print(selectedParticipants);
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await widget.controller.substractRecipeIngredients(
                        widget.value.id,
                        selectedParticipants.length.toDouble(),
                        selectedParticipants.toList())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Bon Apetit!'),
                          backgroundColor: primary[300],
                          duration: const Duration(
                              seconds:
                                  5), // Duration the Snackbar will be shown
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('You need at least one participant!'),
                          backgroundColor: primary[900],
                          duration: const Duration(
                              seconds:
                                  5), // Duration the Snackbar will be shown
                        ),
                      );
                    }
                  },
                  child: const Text('Let`s Cook!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addParticipant(String participant) {
    selectedParticipants.add(participant);
  }

  void removePaticipant(String participant) {
    selectedParticipants.remove(participant);
  }
}
