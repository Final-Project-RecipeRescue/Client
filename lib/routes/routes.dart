import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/analytics_page.dart';
import 'package:reciperescue_client/components/create_or_join_household.dart';
import 'package:reciperescue_client/components/custom_button.dart';
import 'package:reciperescue_client/components/recipe_instruction.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'package:reciperescue_client/dashboard_binding.dart';
import 'package:reciperescue_client/home_page.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:reciperescue_client/manage_ingredients_page.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';

class Routes {
  static String home = "/";
  static String newHousehold = "/newHousehold";
  static String profile = "/profile";
  static String manageIngredients = "/manageIngredients";
  static String searchRecipes = "/searchRecipes";
  static String analytics = "/analytics";
  static String recipeInstructions = "/recipeInstructions";

  static String getHomeRoute() => home;
  static String getNewHousehold() => newHousehold;
  static String getProfile() => profile;
  static String getManageIngredients() => manageIngredients;
  static String getSearchRecipes() => searchRecipes;
  static String getAnalytics() => analytics;

  static Widget getHomePage() => const HomePage();
  static Widget getProfilePage() => const Text("profile");
  static Widget getManageIngredientsPage() => const ManageIngredientsPage();
  static Widget getAnalyticsPage() => AnalyticsPage();
  static Widget getSearchRecipesPage() => const Text("search recipes");
  static Widget getRecipeInstructionsPage(RecipesUiModel value) =>
      RecipeInstructions(value);
  static Widget getJoinOrCreateHouseholdPage() =>
      GetBuilder<DashboardController>(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Household'),
          ),
          body: SafeArea(
            child: Column(children: [
              JoinOrCreateHousehold(),
              MyButton(text: "Submit", onPressed: () {})
            ]),
          ),
        );
      });

  static List<GetPage> routes = [
    GetPage(
        name: home, page: () => const LoginPage(), binding: DashboardBinding()),
    GetPage(
        name: newHousehold,
        page: () => getJoinOrCreateHouseholdPage(),
        binding: DashboardBinding()),
  ];

  static List<Widget> dashboardPages = [
    getProfilePage(),
    getManageIngredientsPage(),
    getHomePage(),
    getSearchRecipesPage(),
    getAnalyticsPage(),
    getJoinOrCreateHouseholdPage(),
  ];
}
