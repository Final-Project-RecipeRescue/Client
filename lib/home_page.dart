import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/components/MySlider.dart';
import 'package:reciperescue_client/components/recipe_home_page.dart';
import 'package:reciperescue_client/components/recipe_instruction.dart';
import 'package:reciperescue_client/components/show_recipe_details.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/routes/routes.dart';

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
                      Text(
                        'Welcome, ${currentUser.email}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          auth.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                      Obx(() => MyDropdown(
                            selectedValue: hController.selectedHousehold.value,
                            items: hController.user.value.households,
                            onChanged: (value) async {
                              if (value !=
                                  hController.selectedHousehold.value) {
                                await hController.fetchHousehold(
                                    Authenticate().currentUser?.email, value!);
                                await hController
                                    .fetchHouseholdsIngredients(value!);
                                await hController.fetchHouseholdRecipes();
                              }
                            },
                          )),
                      Expanded(
                        child: MySlider(),
                      ),
                      Obx(
                        () => hController.isLoading.value
                            ? Center(
                                child: Lottie.asset(
                                    'assets/images/loading_animation.json'))
                            : hController.hasError.value
                                ? Text(hController.recipesFetchErrorMsg)
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    child: RefreshIndicator(
                                      onRefresh: Get.find<DashboardController>()
                                          .fetchRecipesOnHomePage,
                                      child: ListView.builder(
                                          itemCount:
                                              hController.recipes.value.length,
                                          itemBuilder: (context, index) =>
                                              Column(children: [
                                                GestureDetector(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: Recipe(
                                                        recipeModel: hController
                                                            .recipes
                                                            .value[index],
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
    print(hController.recipes.value[index].toString());
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
