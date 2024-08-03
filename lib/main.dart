import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/controllers/auth_controller.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'constants/dotenv_constants.dart';
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

  FirebaseOptions options = androidFirebaseOptions;

  if (kIsWeb) {
    print(kIsWeb);
    FirebaseOptions webFirebaseOptions = const FirebaseOptions(
        apiKey: "AIzaSyAbC68ON76diTqdgj4xwqZxCrB4wYKB4Kw",
        authDomain: "reciperescue-6da9c.firebaseapp.com",
        databaseURL:
            "https://reciperescue-6da9c-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "reciperescue-6da9c",
        storageBucket: "reciperescue-6da9c.appspot.com",
        messagingSenderId: "515262454466",
        appId: "1:515262454466:web:ddda1a88f0cbafc0c5b95b",
        measurementId: "G-ZE7J47PV08");
    options = webFirebaseOptions;
  }

  await Firebase.initializeApp(options: options)
      .then((value) => Get.put(AuthController()));
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );
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
              textTheme: TextTheme(
                bodyLarge: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                bodyMedium: GoogleFonts.poppins(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                // Define other styles as needed
              ),
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
