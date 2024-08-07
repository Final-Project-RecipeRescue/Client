import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/dotenv_constants.dart';
import '../authentication/auth.dart';
import '../models/user_model.dart';
import '../models/household_model.dart';

// HTTP Methods
const String HTTP_METHOD_GET = 'GET';
const String HTTP_METHOD_POST = 'POST';
const String HTTP_METHOD_PUT = 'PUT';
const String HTTP_METHOD_DELETE = 'DELETE';

Future<http.Response?> performHttpRequest(
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
      return response;
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during HTTP request: $e');
    return null;
  }
}

class ProfileController extends GetxController {
  late Rx<UserModel> user = Rx(UserModel());
  var isEditMode = false.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var country = ''.obs;
  var state = ''.obs;
  var households = <String>[].obs;
  final Rx<List<Household>> userHouseholdsList = Rx([]);
  var userImage = ''.obs; // Initialize as an empty string
  var countryController = TextEditingController();
  var stateController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var newHouseholdController = TextEditingController();
  var loading = true.obs; // Ensure loading is true initially

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

    try {
      loading.value = true;
      final response =
          await performHttpRequest(url, parameters, HTTP_METHOD_PUT, body);

      if (response != null && response.statusCode == 200) {
        print('Profile updated successfully.');
        firstName.value = firstNameController.text;
        lastName.value = lastNameController.text;
        country.value = countryController.text;
        state.value = stateController.text;
      } else {
        print('Failed to update profile: ${response?.statusCode}');
      }
    } catch (e) {
      print('Error saving profile: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> addHousehold(String householdId) async {
    if (householdId.isNotEmpty) {
      final url =
          '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/addUserToHousehold';
      final parameters = {
        'user_email': email.value,
        'household_id': householdId,
      };

      try {
        loading.value = true;
        final response =
            await performHttpRequest(url, parameters, HTTP_METHOD_POST);

        if (response != null && response.statusCode == 200) {
          fetchHouseholds(email.value);
          print('Household added successfully.');
        } else {
          print('Failed to add household: ${response?.statusCode}');
        }
      } catch (e) {
        print('Error adding household: $e');
      } finally {
        loading.value = false;
      }
    } else {
      print('Household ID cannot be empty.');
    }
  }

  Future<void> removeHousehold(int index) async {
    if (index < 0 || index >= userHouseholdsList.value.length) {
      print('Invalid index: $index');
      return;
    }

    final Household householdToRemove = userHouseholdsList.value[index];
    final url =
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/removeUserFromHousehold';
    final parameters = {
      'user_email': email.value,
      'household_id': householdToRemove.householdId,
    };

    try {
      loading.value = true;
      final response =
          await performHttpRequest(url, parameters, HTTP_METHOD_DELETE);

      if (response != null && response.statusCode == 200) {
        print('Household removed successfully.');
        households.remove(householdToRemove.householdName);
        userHouseholdsList.value.remove(householdToRemove);
      } else {
        print('Failed to remove household: ${response?.statusCode}');
      }
    } catch (e) {
      print('Error removing household: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchUserInfo() async {
    final Uri url = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getUser?user_email=${Authenticate().currentUser!.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print(
            'Failed to fetch user information. Status code: ${response.statusCode}');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      user.value = UserModel.fromJson(data);
      refresh();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchHouseholds(String? userEmail) async {
    final url = Uri.parse(
        '${DotenvConstants.baseUrl}/usersAndHouseholdManagement/getAllHouseholdsByUserEmail?user_email=$userEmail');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response data: ${response.body}');

        final List<Household> fetchedHouseholds = data.entries.map((entry) {
          return Household.fromJson(entry.value);
        }).toList();

        userHouseholdsList.value = fetchedHouseholds;
        households.value = fetchedHouseholds
            .map((household) => household.householdName)
            .toList();
        update();
      } else {
        print('Failed to load households: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching households: $e');
    }
  }

  @override
  Future<void> onInit() async {
    loading.value = true;
    super.onInit();
    await initializeProfile();
  }

  Future<void> initializeProfile() async {
    try {
      await fetchUserInfo();
      firstName.value = user.value.firstName;
      lastName.value = user.value.lastName;
      email.value = Authenticate().currentUser!.email ?? '';
      country.value = user.value.country ?? '';
      state.value = user.value.state ?? '';
      await fetchHouseholds(email.value);
      firstNameController.text = firstName.value;
      lastNameController.text = lastName.value;
      countryController.text = country.value;
      stateController.text = state.value;
    } finally {
      loading.value = false; // Set loading to false once initialization is done
    }
  }
}
