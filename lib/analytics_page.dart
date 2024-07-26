import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/components/bar_chart.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/controllers/analytics_controller.dart';

import 'colors/colors.dart';
import 'components/rank_pollution_table.dart';
import 'components/toggle_buttons.dart';
import 'controllers/homepage_controller.dart';

class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalyticsController controller = Get.put(AnalyticsController());
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyToggleButtons(
                    () => controller.fetchData(controller.selectedFilter)),
                GasPollutionTable(
                  users: controller.getHouseholdUsers(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CO2 per 100g',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const Spacer(),
                    MyDropdown(
                      selectedValue: controller.selectedFilter.description,
                      items:
                          FilterDate.values.map((e) => e.description).toList(),
                      onChanged: (value) {
                        if (value != controller.selectedFilter.description) {
                          controller
                              .fetchData(FilterDate.fromDescription(value!));
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: controller.isLoading.value
                      ? Lottie.asset('assets/images/loading_animation.json')
                      : MyBarChart(
                          controller.co2Values, controller.selectedFilter),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
