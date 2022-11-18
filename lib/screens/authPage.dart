import 'package:flutter/material.dart';
import 'package:myapp/screens/signIn.dart';
import 'package:myapp/screens/signUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(
          onClickedSignUp: toggle,
        )
      : SignupPage(
          onClickedSignIn: toggle,
        );

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
