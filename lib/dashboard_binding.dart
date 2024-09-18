import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/manage_ingredients_controller.dart';
import 'package:reciperescue_client/controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<ManageIngredientsController>(
        () => ManageIngredientsController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
