// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register.dart';
import 'inventory.dart';
import 'profile.dart';
import 'navBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser?.uid != null){
      var userUid = FirebaseAuth.instance.currentUser?.uid;
      debugPrint("User UID: " + userUid!);
      //Navigator.push(context,
      //    MaterialPageRoute(builder: (context) => NavBar()));
    }
  }

  TextEditingController enterEmail = TextEditingController();
  TextEditingController enterPassword = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            width: 303,
            height: 200,
            child: Image.asset('assets/logo.png'),
          ),
          const Text('KitchenMaster',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 40,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1)),
          const SizedBox(height: 30),
          Text('LOG IN',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 26,
                  fontWeight: FontWeight.normal,
                  height: 1)),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 5),
            child: TextFormField(
              controller: enterEmail,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 5),
            child: TextFormField(
              controller: enterPassword,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              cursorColor: Colors.black,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ])),
          const SizedBox(height: 30),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'New to KitchenMaster? ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'Sign Up Now!',
              style: TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
            ),
          ])),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 51.5,
            child: ElevatedButton(
              onPressed: () {
                debugPrint("Email: "+enterEmail.text.trim());
                debugPrint("Password: "+enterPassword.text.trim());
                signIn();
              },
              child: Text(
                'OK',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'IM FELL English SC',
                    fontSize: 30,
                    letterSpacing:0,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          ),
        ]),
      ),
    );
  }
  Future signIn() async {
    try { 
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: enterEmail.text.trim(), 
        password: enterPassword.text.trim(),
      );
      setState(() {
        errorMessage = "";
      });
    } on FirebaseAuthException catch (e) {
      debugPrint("Error Message: "+e.code);
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      setState(() {
        errorMessage = "Incorrect Email/Password";
      });
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && errorMessage == "")
    { 
      debugPrint(user.uid);
      debugPrint("Success");
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => NavBar()));
    }
  }
}
