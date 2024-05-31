import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 2.obs;

  setTabIndex(int index) {
    tabIndex.value = index;
    update();
  }

  fetchRecipesOnHomePage() {
    HomePageController controller = Get.find();
    print('initing home controller');
    controller.fetchHouseholdRecipes();
  }

  void fetchHouseholdIngredients() {
    HomePageController controller = Get.find();
    controller.fetchHouseholdsIngredients(controller.selectedHousehold.value);
  }
}
