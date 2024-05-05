import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/login_register_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          backgroundColor: myGrey[100],
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: myGrey,
            onPressed: () {
              Get.offAll(() => const LoginPage());
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
