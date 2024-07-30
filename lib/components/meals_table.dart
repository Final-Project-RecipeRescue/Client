import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/analytics_controller.dart';
import '../models/meal_model.dart';

class HouseholdMealsTable extends StatelessWidget {
  final Map<DateTime, Map<String, Map<String, List<Meal>>>> mealMap;
  final FilterDate filterDate;

  HouseholdMealsTable({required this.mealMap, required this.filterDate});

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    DateTime now = DateTime.now();
    DateTime filterDateStart;

    switch (filterDate) {
      case FilterDate.lastSixMonths:
        filterDateStart = DateTime(now.year, now.month - 6, now.day);
        break;
      case FilterDate.lastWeek:
        filterDateStart = now.subtract(const Duration(days: 7));
        break;
    }

    mealMap.forEach((date, mealTypes) {
      if (date.isAfter(filterDateStart)) {
        mealTypes.forEach((mealType, mealsById) {
          mealsById.forEach((mealId, meals) {
            meals.forEach((meal) {
              rows.add(DataRow(cells: [
                DataCell(Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                )),
                DataCell(Text(
                  mealType,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                )),
                DataCell(Text(
                  meal.co2Score.toStringAsFixed(2),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                )),
              ]));
            });
          });
        });
      }
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey, width: 2.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('🍽️ Household Meals',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
                children: [
                  DataTable(
                    columnSpacing: 20.0,
                    columns: [
                      DataColumn(
                          label: Text('Date',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ))),
                      DataColumn(
                          label: Text('Meal Type',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ))),
                      DataColumn(
                          label: Text('CO2 Score',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ))),
                    ],
                    rows: rows,
                  )
                ],
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
