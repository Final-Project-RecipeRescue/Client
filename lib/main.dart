import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/controllers/auth_controller.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/dashboard_binding.dart';
import 'package:reciperescue_client/login_register_page.dart';

import 'constants/dotenv_constants.dart';
import 'models/ingredient_model.dart';
import 'routes/routes.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions androidFirebaseOptions = FirebaseOptions(
    apiKey: DotenvConstants.apiKey,
    appId: DotenvConstants.appId,
    messagingSenderId: DotenvConstants.messagingSenderId,
    projectId: DotenvConstants.projectId,
    databaseURL: DotenvConstants.databaseUrl,
  );

  await Firebase.initializeApp(options: androidFirebaseOptions)
      .then((value) => Get.put(AuthController()));
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  //c1adce95-a9cc-4ef9-8db0-8dc7400b60c3
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  InitializerController controller = Get.put(InitializerController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: controller.fetchSystemIngredients(),
        builder: (context, snapshot) {
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
            initialRoute: Routes.getHomeRoute(),
            // getPages: Routes.routes,
            getPages: Routes.routes,
            // home: const LoginPage(),
          );
        });
  }
}
