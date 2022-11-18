import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/main.dart';

class SignupPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignupPage({
    super.key,
    required this.onClickedSignIn,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namecontroller = TextEditingController();
  final whocontroller = TextEditingController();
  final agecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(
              "싸피 마스코트는 내가 뽑겠어",
              style: TextStyle(color: Colors.blue, fontSize: 50),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            child: TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && EmailValidator.validate(email)
                      ? null
                      : '이메일을 제대로 써주세요!',
              decoration: InputDecoration(
                  hintText: "이메일",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? '비밀번호는 6자 이상 써주세요!'
                  : null,
              decoration: InputDecoration(
                  hintText: "비밀번호",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            child: TextFormField(
              controller: namecontroller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null ? null : '닉네임을 적어주세요!',
              decoration: InputDecoration(
                  hintText: "닉네임",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            child: TextFormField(
              controller: agecontroller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null ? null : '나이를 적어주세요!',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                // for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: "나이",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            child: TextFormField(
              controller: whocontroller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null ? null : '아직 합격하지 않으셨다면 0을 적어주세요',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                // for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: "몇기냐?",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
            child: Text("가입하기"),
            onPressed: () {
              final user = User(
                  email: emailController.text,
                  password: passwordController.text,
                  name: namecontroller.text,
                  age: int.parse(agecontroller.text),
                  who: int.parse(whocontroller.text));

              signUp();
              createUser(user);
              setState(() {
                widget.onClickedSignIn;
              });
            },
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black),
                text: 'already have account?  ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: '로그인',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary))
                ]),
          )
        ]),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil(((route) => route.isFirst));
  }

  // 아래는 Firebase Store에 넣어주는 create user method

  Future createUser(User user) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc('${user.id}');
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}

class User {
  String id;
  final String email;
  final String password;
  final String name;
  final int age;
  final int who;

  User({
    this.id = '',
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.who,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'id': id,
        'name': name,
        'who': who,
      };
}
