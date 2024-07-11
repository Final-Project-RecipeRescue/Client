import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/components/bar_chart.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/controllers/analytics_controller.dart';

class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});
  final AnalyticsController controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    print(controller.co2Values);
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              MyDropdown(
                selectedValue: controller.selectedFilter.description,
                items: FilterDate.values.map((e) => e.description).toList(),
                onChanged: (value) {
                  if (value != controller.selectedFilter.description) {
                    controller.fetchData(FilterDate.fromDescription(value!));
                  }
                },
              ),
              controller.isLoading.value
                  ? Lottie.asset('assets/images/loading_animation.json')
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: MyBarChart(
                          controller.co2Values, controller.selectedFilter),
                    )
            ],
          );
        }),
      ),
    );
  }
}
