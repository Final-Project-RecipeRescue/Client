import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/components/recipe_home_page.dart';
import 'package:reciperescue_client/components/recipe_instruction.dart';
import 'package:reciperescue_client/components/show_recipe_details.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/models/household_model.dart';
import 'package:reciperescue_client/routes/routes.dart';

import 'components/MySlider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authenticate auth = Authenticate();
  QuestionnaireController qController = Get.put(QuestionnaireController());
  HomePageController hController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: auth.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final currentUser = snapshot.data;
              if (currentUser != null) {
                return Container(
                  color: myGrey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() => RichText(
                                text: TextSpan(
                                    text: 'Hello, \n',
                                    style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
                                        color: primary),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: hController.user.value.firstName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.normal,
                                        color: primary),
                                  )
                                ]))),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => MyDropdown(
                            selectedValue:
                                hController.currentHousehold.householdName,
                            items: hController.userHouseholdsList.value
                                .map((e) => e.householdName),
                            onChanged: (value) async {
                              Household chosenHousehold =
                                  hController.getHousehold(value);
                              print(chosenHousehold);
                              if (chosenHousehold !=
                                  hController.currentHousehold) {
                                hController.currentHousehold = chosenHousehold;
                                // await hController.fetchHouseholds(
                                //     Authenticate().currentUser?.email);
                                await hController.fetchHouseholdsIngredients(
                                    chosenHousehold.householdId);
                                await hController.fetchHouseholdRecipes();
                              }
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: MySlider(
                            startValue: "Pollution",
                            endValue: "Date\nExpired",
                            items: hController.recipes.value,
                            onSwipeStart: () {
                              hController.sort(HomepageSortType.byPollution);
                            },
                            onSwipeMiddle: () {
                              hController.sort(HomepageSortType.byMix);
                            },
                            onSwipeEnd: () {
                              hController
                                  .sort(HomepageSortType.byDateExpiration);
                            }),
                      ),
                      Obx(
                        () => hController.isLoading.value
                            ? Expanded(
                                child: Center(
                                    child: Lottie.asset(
                                        'assets/images/loading_animation.json')),
                              )
                            : hController.hasError.value
                                ? Text(hController.recipesFetchErrorMsg)
                                : Expanded(
                                    child: RefreshIndicator(
                                    onRefresh: () async {
                                      await Get.find<DashboardController>()
                                          .fetchRecipesOnHomePage();
                                      return hController
                                          .sort(hController.selectedSort.value);
                                    },
                                    child: ListView.builder(
                                        itemCount:
                                            hController.recipes.value.length,
                                        itemBuilder: (context, index) =>
                                            Column(children: [
                                              GestureDetector(
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: Recipe(
                                                      recipeModel: hController
                                                          .recipes.value[index],
                                                    ),
                                                  ),
                                                  onTap: () => _buildDialog(
                                                      context, index))
                                            ])),
                                  )),
                      )
                    ],
                  ),
                );
              } else {
                return const LoginPage();
              }
            } else {
              return Lottie.asset('assets/images/loading_animation.json');
            }
          },
        ),
      ),
    );
  }

  Future<void> _buildDialog(context, int index) {
    return AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.noHeader,
            body: RecipeDetail(recipeModel: hController.recipes.value[index]),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () =>
                // hController.substractRecipeIngredients(
                //     hController.recipes.value[index].id),
                Get.to(() => Routes.getRecipeInstructionsPage(
                    hController.recipes.value[index])),
            btnOkText: 'Cook it!',
            btnCancelOnPress: () {},
            btnCancelColor: Colors.amber)
        .show();
  }
}
