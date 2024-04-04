import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/features/recipes/bloc/home_page_recipes_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authenticate auth = Authenticate();
  final RecipesBloc bloc = RecipesBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(FetchInitialRecipes());
  }

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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ${currentUser.email}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      child: Text('Sign Out'),
                    ),
                  ],
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
