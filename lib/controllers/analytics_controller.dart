import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/constants/dotenv_constants.dart';
import 'package:reciperescue_client/models/user_model.dart';

import '../models/meal_model.dart';
import 'homepage_controller.dart';

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

enum FilterDataDomain {
  personal('Personal'),
  household('Household');

  final String description;

  const FilterDataDomain(this.description);

  static FilterDataDomain fromDescription(String description) {
    for (FilterDataDomain filter in FilterDataDomain.values) {
      if (filter.description == description) {
        return filter;
      }
    }
    throw Exception('Invalid description for enum FilterDataType');
  }
}

class AnalyticsController extends GetxController {
  RxList<double> co2Values = <double>[].obs;
  final Rx<FilterDate> _selectedFilter = FilterDate.lastWeek.obs;
  final Rx<FilterDataDomain> _selectedFilterDataDomain =
      FilterDataDomain.personal.obs;
  final RxBool isLoading = RxBool(false);

  FilterDate get selectedFilter => _selectedFilter.value;

  set selectedFilter(FilterDate newValue) {
    _selectedFilter.value = newValue;
    update();
  }

  FilterDataDomain get selectedFilterDataDomain =>
      _selectedFilterDataDomain.value;

  set selectedFilterDataDomain(FilterDataDomain newValue) {
    _selectedFilterDataDomain.value = newValue;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    fetchData(FilterDate.lastWeek);
    ever(_selectedFilterDataDomain, (_) => fetchData(_selectedFilter.value));
  }

  Future<List<double>> fetchData(FilterDate filterDate) async {
    print('$_selectedFilter   $_selectedFilterDataDomain');
    isLoading.value = true;
    _selectedFilter.value = filterDate;
    co2Values.clear();
    final DateTime today = DateTime.now();
    DateTime startDate;
    DateTime endDate = today
        .add(const Duration(days: 1)); // End date is exclusive, so add one day

    switch (filterDate) {
      case FilterDate.lastSixMonths:
        startDate = DateTime(today.year, today.month - 6, today.day);
        break;
      // case FilterDate.lastMonth:
      //   startDate = DateTime(today.year, today.month - 1, today.day);
      // break;
      case FilterDate.lastWeek:
        startDate = today.subtract(const Duration(days: 6));
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
          "month": monthStart.month,
          "day": monthStart.day
        },
        "endDate": {
          "year": monthEnd.year,
          "month": monthEnd.month,
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
    DateTime newEndDate = endDate.add(const Duration(days: 1));
    for (DateTime date = startDate.add(const Duration(days: 1));
        date.isBefore(newEndDate);
        date = date.add(const Duration(days: 1))) {
      DateTime tempNextDay = date.add(const Duration(days: 1));
      final body = {
        "startDate": {"year": date.year, "month": date.month, "day": date.day},
        "endDate": {
          "year": tempNextDay.year,
          "month": tempNextDay.month,
          "day": tempNextDay.day
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
        print(co2Value);
        co2Values.add(co2Value as double);
      } else {
        throw Exception('Failed to fetch data for date: $date');
      }
    }
    print(co2Values);
  }

  Future<http.Response> _doPostGasPollution(
      Map<String, Map<String, int>> body) async {
    String url;
    url = _selectedFilterDataDomain.value == FilterDataDomain.personal
        ? '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getGasPollutionOfUserInRangeDates?user_email=${Authenticate().currentUser?.email}'
        : '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getGasPollutionOfHouseholdInRangeDates?user_email=${Authenticate().currentUser?.email}&household_id=${Get.find<HomePageController>().currentHousehold.householdId}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  List<UserModel> getHouseholdUsers() {
    return Get.find<HomePageController>().currentHousehold.participants;
  }

  Map<DateTime, Map<String, Map<String, List<Meal>>>> updateHouseholdMeals() {
    return Get.find<HomePageController>()
        .getHousehold(
            Get.find<HomePageController>().currentHousehold.householdName)
        .meals;
  }
}
