import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../constants/dotenv_constants.dart';

// HTTP Methods
const String HTTP_METHOD_GET = 'GET';
const String HTTP_METHOD_POST = 'POST';
const String HTTP_METHOD_PUT = 'PUT';
const String HTTP_METHOD_DELETE = 'DELETE';

Future<void> performHttpRequest(
    String url, Map<String, dynamic> parameters, String method,
    [Map<String, dynamic>? body] // Optional body parameter
    ) async {
  try {
    Uri uri = Uri.parse(url).replace(queryParameters: parameters);
    http.Response response;

    switch (method) {
      case HTTP_METHOD_GET:
        response = await http.get(uri);
        break;
      case HTTP_METHOD_POST:
        response = await http.post(uri, body: jsonEncode(body), headers: {
          'Content-Type': 'application/json',
        });
        break;
      case HTTP_METHOD_PUT:
        response = await http.put(uri, body: jsonEncode(body), headers: {
          'Content-Type': 'application/json',
        });
        break;
      case HTTP_METHOD_DELETE:
        response = await http.delete(uri, headers: {
          'Content-Type': 'application/json',
        });
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Request successful');
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during HTTP request: $e');
  }
}

class ProfileController extends GetxController {
  var isEditMode = false.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var country = ''.obs;
  var state = ''.obs;
  var households = <String>[].obs;
  var userName = ''.obs;
  var userImage = ''.obs; // Initialize as an empty string
  var countryController = TextEditingController();
  var stateController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var newHouseholdController = TextEditingController();

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void setUserImage(String path) {
    userImage.value = path;
  }

  Future<void> saveProfile() async {
    final url =
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/updatePersonalUserInfo';
    final parameters = <String, dynamic>{};
    final body = <String, dynamic>{
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': email.value,
      'country': countryController.text,
      'state': stateController.text,
    };
    await performHttpRequest(url, parameters, HTTP_METHOD_PUT, body);
  }

  Future<void> addHousehold(String householdId) async {
    if (householdId.isNotEmpty) {
      final url =
          '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/addUserToHousehold';
      final parameters = {
        'user_email': email.value,
        'household_id': householdId,
      };
      await performHttpRequest(url, parameters, HTTP_METHOD_POST);
      households.add(householdId);
    }
  }

  Future<void> removeHousehold(int index) async {
    final householdId = households[index];
    final url =
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/removeUserFromHousehold';
    final parameters = {
      'user_email': email.value,
      'household_id': householdId,
    };
    await performHttpRequest(url, parameters, HTTP_METHOD_DELETE);
    households.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with actual data if available
    firstName.value = 'John';
    lastName.value = 'bd616751-cc28-41b5-9719-fbf1b1f52df3';
    email.value = 'koko@koko.com';
    country.value = 'USA';
    state.value = '67fc717d-67b4-43e0-a8dc-cb5189a9c383';
    households.assignAll(
        ['Household 1', 'Household 2', 'Household 3']); // Example households
    firstNameController.text = firstName.value;
    lastNameController.text = lastName.value;
    countryController.text = country.value;
    stateController.text = state.value;
  }
}
