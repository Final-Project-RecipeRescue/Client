import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/blocs/home_page/home_page_recipes_event.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/recipe_home_page.dart';
import 'package:reciperescue_client/blocs/home_page/home_page_recipes_bloc.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:reciperescue_client/models/user_model.dart';

import 'routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authenticate auth = Authenticate();
  QuestionnaireController qController = Get.put(QuestionnaireController());
  HomePageController hController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: auth.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final currentUser = snapshot.data;
              if (currentUser != null) {
                return Container(
                  color: myGrey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ${currentUser.email}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          auth.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                      DropdownButton(
                        items: hController.user!.households
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          hController.fetchHouseholdsIngredients(value!);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              'sort by',
                              style: GoogleFonts.poppins(),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Alphabetical',
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(color: primary)),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/images/sort_icon.svg',
                              semanticsLabel: 'sort',
                              height: 24,
                              width: 24,
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => hController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : hController.hasError.value
                                ? const Text('Error fetching data')
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    child: ListView.builder(
                                        itemCount:
                                            hController.recipes.value.length,
                                        itemBuilder: (context, index) =>
                                            Column(children: [
                                              GestureDetector(
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Recipe(
                                                    recipeModel: hController
                                                        .recipes.value[index],
                                                  ),
                                                ),
                                              )
                                            ]))),
                      )
                    ],
                  ),
                );
              } else {
                return const LoginPage();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
