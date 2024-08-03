import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/components/bar_chart.dart';
import 'package:reciperescue_client/components/MyDropdown.dart';
import 'package:reciperescue_client/controllers/analytics_controller.dart';

import 'colors/colors.dart';
import 'components/meals_table.dart';
import 'components/rank_pollution_table.dart';
import 'components/toggle_buttons.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalyticsController controller = Get.put(AnalyticsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📊 Analytics',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: primary,
          ),
        ),
        backgroundColor: myGrey[100],
      ),
      backgroundColor: myGrey[100],
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MyToggleButtons(
                      () => controller.fetchData(controller.selectedFilter)),
                  controller.isLoading.value
                      ? Lottie.asset('assets/images/loading_animation.json')
                      : Column(
                          children: [
                            MyDropdown(
                              selectedValue:
                                  controller.selectedFilter.description,
                              items: FilterDate.values
                                  .map((e) => e.description)
                                  .toList(),
                              onChanged: (value) {
                                if (value !=
                                    controller.selectedFilter.description) {
                                  controller.fetchData(
                                      FilterDate.fromDescription(value!));
                                }
                              },
                            ),
                            controller.selectedFilterDataDomain ==
                                    FilterDataDomain.household
                                ? GasPollutionTable(
                                    users: controller.getHouseholdUsers(),
                                  )
                                : HouseholdMealsTable(
                                    filterDate: controller.selectedFilter,
                                    mealMap: controller.updateHouseholdMeals(),
                                  ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Set the background color to white
                                borderRadius: BorderRadius.circular(
                                    16.0), // Apply border radius
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12, // Shadow color
                                    blurRadius: 10.0, // Shadow blur radius
                                    offset: Offset(0, 5), // Shadow offset
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: MyBarChart(
                                          controller.co2Values,
                                          controller.selectedFilter,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
