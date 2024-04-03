import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reciperescue_client/authentication/auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:reciperescue_client/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMsg = '';
  bool isLogin = true;
  Authenticate auth = Authenticate();

  Duration get loginTime => const Duration(milliseconds: 2250);

  // final TextEditingController _controllerEmail = TextEditingController();
  // final TextEditingController _controllerPassword = TextEditingController();

  Future<String?> signInWithEmailAndPassword(LoginData loginData) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginData.name, password: loginData.password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> createUserWithEmailAndPassword(SignupData signupData) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: signupData.name ?? '', password: signupData.password ?? '');
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Widget _title() {
  //   return const Text('Welcome To RecipeRescue');
  // }

  // Widget _customTextField(String title, TextEditingController controller) {
  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(labelText: title),
  //   );
  // }

  // Widget _errorMessage() {
  //   return Text(errorMsg == '' ? '' : 'Error is: $errorMsg');
  // }

  // Widget _submitButton() {
  //   return ElevatedButton(
  //       onPressed: isLogin
  //           ? signInWithEmailAndPassword
  //           : createUserWithEmailAndPassword,
  //       child: Text(isLogin ? 'Login' : 'Register'));
  // }

  // Widget _googleButton() {
  //   return ElevatedButton(
  //       onPressed: signInWithGoogle, child: Text('Sign in with Google'));
  // }

  // Widget _loginOrRegisterButton() {
  //   return TextButton(
  //       onPressed: () {
  //         setState(() {
  //           isLogin = !isLogin;
  //         });
  //       },
  //       child: Text(isLogin ? 'Register instead' : 'Login instead'));
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: _title(),
  //     ),
  //     body: Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           _customTextField('email', _controllerEmail),
  //           _customTextField('password', _controllerPassword),
  //           _errorMessage(),
  //           _submitButton(),
  //           _loginOrRegisterButton(),
  //           _googleButton()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<String?>? recoverPassword(String email) async {
    // Add your implementation here
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
        ),

        // Your Login UI
        FlutterLogin(
          theme: LoginTheme(primaryColor: Colors.transparent),
          title: null,
          logo: const AssetImage(
            'assets/images/logo.png',
          ),
          onLogin: signInWithEmailAndPassword,
          onSignup: createUserWithEmailAndPassword,
          onRecoverPassword: recoverPassword,
          logoTag: "Hero",
          loginProviders: <LoginProvider>[
            LoginProvider(
                icon: FontAwesomeIcons.google,
                label: 'Google',
                callback: signInWithGoogle)
          ],
          onSubmitAnimationCompleted: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
          },
        ),
      ],
    );
  }
}
