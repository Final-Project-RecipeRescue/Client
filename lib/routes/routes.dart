import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/components/create_or_join_household.dart';
import 'package:reciperescue_client/components/custom_button.dart';
import 'package:reciperescue_client/components/new_household.dart';
import 'package:reciperescue_client/create_household.dart';
import 'package:reciperescue_client/home_page.dart';

class Routes {
  static String home = "/";
  static String newHousehold = "/newHousehold";
  static String getHomeRoute() => home;
  static String getNewHousehold() => newHousehold;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(
        name: newHousehold,
        page: () => Scaffold(
              appBar: AppBar(
                title: const Text('Household'),
              ),
              body: SafeArea(
                child: Column(children: [
                  JoinOrCreateHousehold(),
                  MyButton(text: "Submit", onPressed: () {})
                ]),
              ),
            ))
  ];
}
