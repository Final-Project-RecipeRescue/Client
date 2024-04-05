import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/components/recipe_home_page.dart';
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
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
                      BlocConsumer<RecipesBloc, HomePageRecipesState>(
                        bloc: bloc,
                        listenWhen: (previous, current) =>
                            current is RecipesActionState,
                        buildWhen: (previous, current) =>
                            current is! RecipesActionState,
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          switch (state.runtimeType) {
                            case const (RecipesSuccefulState):
                              final successState =
                                  state as RecipesSuccefulState;
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: successState.recipes.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      Recipe(
                                        recipeModel:
                                            successState.recipes[index],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            default:
                              return const Center(
                                  child: Text("Error fetching recipes"));
                          }
                        },
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
