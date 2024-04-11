import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/FirstTime.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/home_page.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  Authenticate auth = Authenticate();
  @override
  void onReady() {
    super.onReady();
    FirebaseAuth firebaseAuth = auth.firebaseAuth;
    _user = Rx<User?>(Authenticate().currentUser);
    //bind a stream to the user so whatever changes for the user's instance - the app will be notified
    _user.bindStream(firebaseAuth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Map<String, dynamic> user = await AuthController.instance.getUser();
      if (user['message'] == 'User not exist') {
        Get.offAll(() => const FirstTime());
      } else {
        Get.offAll(() => HomePage());
      }
    }
  }

  Future<String?> signInWithEmailAndPassword(LoginData loginData) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginData.name, password: loginData.password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> createUserWithEmailAndPassword(SignupData signupData) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: signupData.name ?? '', password: signupData.password ?? '');
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?>? recoverPassword(String email) async {
    // Add your implementation here
    return null;
  }

  Future<Map<String, dynamic>> getUser() async {
    final url = Uri.parse(
        'http://10.0.2.2:8000/users_household/get_user?user_email=${_user.value?.email.toString()}');
    final response = await http.post(url);
    print(response);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }
}
