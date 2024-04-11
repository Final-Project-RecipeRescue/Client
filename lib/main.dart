import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/controllers/auth_controller.dart';
import 'package:reciperescue_client/home_page_widget_tree.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:reciperescue_client/login_register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUcs7YdW4UrbFxesLGeEOI4JlERIp7WPk',
    appId: '1:515262454466:android:f1f3501ff2e14933c5b95b',
    messagingSenderId: '515262454466',
    projectId: 'reciperescue-6da9c',
    databaseURL:
        'https://reciperescue-6da9c-default-rtdb.europe-west1.firebasedatabase.app',
  );
  await Firebase.initializeApp(options: android)
      .then((value) => Get.put(AuthController()));
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  //c1adce95-a9cc-4ef9-8db0-8dc7400b60c3
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primary,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: myGrey,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: myGrey,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
