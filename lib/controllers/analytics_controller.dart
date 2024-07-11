import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/constants/dotenv_constants.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';

enum FilterDate {
  lastSixMonths('Last 6 Months'),
  lastWeek('Last Week');

  final String description;

  const FilterDate(this.description);

  static FilterDate fromDescription(String description) {
    for (FilterDate filter in FilterDate.values) {
      if (filter.description == description) {
        return filter;
      }
    }
    throw Exception('Invalid description for enum FilterDate');
  }
}

class AnalyticsController extends GetxController {
  RxList<double> co2Values = <double>[].obs;
  Rx<FilterDate> _selectedFilter = FilterDate.lastWeek.obs;
  final RxBool isLoading = RxBool(false);

  FilterDate get selectedFilter => _selectedFilter.value;

  set selectedFilter(FilterDate newValue) {
    _selectedFilter.value = newValue;
    update();
  }

  Future<List<double>> fetchData(FilterDate filterDate) async {
    isLoading.value = true;
    _selectedFilter.value = filterDate;
    co2Values.clear();
    final DateTime today = DateTime.now();
    DateTime startDate;
    DateTime endDate =
        today.add(Duration(days: 1)); // End date is exclusive, so add one day

    switch (filterDate) {
      case FilterDate.lastSixMonths:
        startDate = DateTime(today.year, today.month - 6, today.day);
        break;
      // case FilterDate.lastMonth:
      //   startDate = DateTime(today.year, today.month - 1, today.day);
      // break;
      case FilterDate.lastWeek:
        startDate = today.subtract(Duration(days: 6));
        break;
    }

    filterDate == FilterDate.lastWeek
        ? await _fetchByDays(startDate, endDate)
        : await _fetchByMonths(startDate, endDate, today);
    update();
    isLoading.value = false;
    return co2Values;
  }

  Future<void> _fetchByMonths(
      DateTime startDate, DateTime endDate, DateTime today) async {
    int monthDifference = 6;
    for (int i = 1; i <= monthDifference; i++) {
      DateTime monthStart =
          DateTime(today.year, today.month - monthDifference + i, 1);
      DateTime monthEnd =
          DateTime(today.year, today.month - monthDifference + i + 1, 1);
      final body = {
        "startDate": {
          "year": monthStart.year,
          "mount": monthStart.month,
          "day": monthStart.day
        },
        "endDate": {
          "year": monthEnd.year,
          "mount": monthEnd.month,
          "day": monthEnd.day
        }
      };

      http.Response response = await _doPostGasPollution(body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        num co2Value = 0.0;
        if (data["CO2"] != null) {
          co2Value = data["CO2"];
          co2Value = co2Value.toDouble();
          co2Value.round();
        }
        co2Values.add(co2Value as double);
      } else {
        throw Exception('Failed to fetch data for month: $monthStart');
      }
    }
  }

  Future<void> _fetchByDays(DateTime startDate, DateTime endDate) async {
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(Duration(days: 1))) {
      final body = {
        "startDate": {"year": date.year, "mount": date.month, "day": date.day},
        "endDate": {"year": date.year, "mount": date.month, "day": date.day + 1}
      };

      http.Response response = await _doPostGasPollution(body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        num co2Value = 0.0;
        if (data["CO2"] != null) {
          co2Value = data["CO2"];
          print(co2Value);
          co2Value = co2Value.toDouble();
          co2Value.round();
        }
        co2Values.add(co2Value as double);
      } else {
        throw Exception('Failed to fetch data for date: $date');
      }
    }
  }

  Future<http.Response> _doPostGasPollution(
      Map<String, Map<String, int>> body) async {
    var url =
        '${DotenvConstants.baseUrl}/users_household/get_gas_pollution_of_user_in_range_dates?user_email=${Authenticate().currentUser?.email}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }
}
