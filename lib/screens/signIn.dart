import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/authPage.dart';
import 'package:myapp/screens/bottomBar.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BottomBar();
        } else {
          return AuthPage();
        }
      },
    ));
  }
}

// 아래는 로그인 위젯 스테이트풀

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({super.key, required this.onClickedSignUp});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "싸피 마스코트는 내가 뽑겠어",
              style: TextStyle(color: Colors.blue, fontSize: 50),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: 300,
            child: TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            width: 300,
            child: TextField(
              controller: passwordController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            width: 300,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              icon: Icon(Icons.lock_open, size: 32),
              label: Text(
                '로그인',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                signIn();
              },
            ),
          ),
          SizedBox(
            height: 24,
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black),
                text: 'No account?  ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: '회원가입',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary))
                ]),
          )
        ],
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }
}
