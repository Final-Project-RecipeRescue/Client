import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/recipe_home_page.dart';

class HomePage extends StatelessWidget {
  final Authenticate auth = Authenticate();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: auth.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final currentUser = snapshot.data;
              if (currentUser != null) {
                return Container(
                  color: backgroundgray[100],
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
                      Row(
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
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: const [
                            Recipe(),
                            Recipe(),
                            Recipe(),
                            Recipe(),
                            Recipe()
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Text('User not signed in');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
