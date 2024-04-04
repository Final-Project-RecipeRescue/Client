import 'package:flutter/material.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/home_page.dart';
import 'package:reciperescue_client/login_register_page.dart';
import 'package:reciperescue_client/main.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Authenticate().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            // return const LoginPage();
            return HomePage();
          }
        });
  }
}
