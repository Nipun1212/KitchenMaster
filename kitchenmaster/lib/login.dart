// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register.dart';
import 'inventory.dart';
import 'profile.dart';
import 'navBar.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController enterEmail = TextEditingController();
  TextEditingController enterPassword = TextEditingController();
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
                Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => InventoryPage()));
                    // MaterialPageRoute(builder: (context) => ProfilePage()));
                    MaterialPageRoute(builder: (context) => NavBar()));
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
}