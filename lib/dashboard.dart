import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/dashboard_controller.dart';
import 'colors/colors.dart';
import 'routes/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
            child: IndexedStack(
          index: controller.tabIndex,
          children: Routes.dashboardPages,
        )),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: myGrey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.kitchen),
              label: 'Ingredients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analytics',
            ),
          ],
          currentIndex: controller.tabIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            controller.setTabIndex(index);
          },
        ),
      );
    });
  }
}
