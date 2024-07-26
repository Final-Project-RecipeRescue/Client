import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/analytics_controller.dart';

import '../colors/colors.dart';

class MyToggleButtons extends StatefulWidget {
  void Function() onToggle;

  MyToggleButtons(this.onToggle, {super.key});

  @override
  _MyToggleButtonsState createState() => _MyToggleButtonsState();
}

class _MyToggleButtonsState extends State<MyToggleButtons> {
  bool isPersonal = true;
  bool isHousehold = false;
  AnalyticsController controller = Get.find<AnalyticsController>();

  void toggleButton1() {
    setState(() {
      isPersonal = true;
      isHousehold = false;
      controller.selectedFilterDataDomain = FilterDataDomain.personal;
    });
  }

  void toggleButton2() {
    setState(() {
      isPersonal = false;
      isHousehold = true;
      controller.selectedFilterDataDomain = FilterDataDomain.household;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            onPressed: controller.isLoading.value ? null : toggleButton1,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width / 4,
                  MediaQuery.of(context).size.height / 20),
              backgroundColor: isPersonal ? primary : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Personal',
              style: TextStyle(color: isPersonal ? Colors.white : primary),
            ),
          ),
          TextButton(
            onPressed: controller.isLoading.value ? null : toggleButton2,
            style: ElevatedButton.styleFrom(
              backgroundColor: isHousehold ? primary : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Household',
              style: TextStyle(color: isHousehold ? Colors.white : primary),
            ),
          ),
        ],
      ),
    );
  }
}
