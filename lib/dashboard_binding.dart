import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
