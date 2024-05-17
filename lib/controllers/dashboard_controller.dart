import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 2;

  setTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
