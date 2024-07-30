import 'package:flutter/material.dart';

import 'authentication/auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final Authenticate auth = Authenticate();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              auth.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
