// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController regName = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController regPassword = TextEditingController();
  TextEditingController regConfirm = TextEditingController();
  String errorTextvalue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          const Text('Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 40,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1)),
          const SizedBox(height: 30),
          Text('User Registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 40,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1)),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 5),
            child: TextFormField(
              controller: regName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter Name",
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
              controller: regEmail,
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
              controller: regPassword,
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
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 5),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  if (value != regPassword.text) {
                    errorTextvalue = value;
                  } else {
                    errorTextvalue = '';
                  }
                });
              },
              controller: regConfirm,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              cursorColor: Colors.black,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText:
                    errorTextvalue.isEmpty ? null : 'Passwords do not match!',
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 51.5,
            child: ElevatedButton(
              onPressed: () {
                if (regPassword.text == regConfirm) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  // make alert dialog to print 'successfully created account'
                }
              },
              child: Text(
                'DONE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'IM FELL English SC',
                    fontSize: 30,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          ),
        ])));
  }
}
