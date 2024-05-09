import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:reciperescue_client/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMsg = '';
  Duration get loginTime => const Duration(milliseconds: 2250);

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
            theme: LoginTheme(pageColorLight: Colors.transparent),
            title: null,
            logo: const AssetImage(
              'assets/images/logo.png',
            ),
            onLogin: AuthController.instance.signInWithEmailAndPassword,
            onSignup: AuthController.instance.createUserWithEmailAndPassword,
            onRecoverPassword: AuthController.instance.recoverPassword,
            logoTag: "Hero",
            loginProviders: <LoginProvider>[
              LoginProvider(
                  icon: FontAwesomeIcons.google,
                  label: 'Google',
                  callback: AuthController.instance.signInWithGoogle)
            ],
            onSubmitAnimationCompleted: () {
              print('Im Here Bro');
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => HomePage(),
              // ));
            }),
      ],
    );
  }
}
