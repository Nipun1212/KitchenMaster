// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    errorText: errorTextvalue.isEmpty
                        ? null
                        : 'Passwords do not match!',
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
              Container(
                width: 300,
                height: 51.5,
                child: ElevatedButton(
                  onPressed: () {
                    if ((regEmail.text.isNotEmpty) &&
                        (regName.text.isNotEmpty) &&
                        (regPassword.text.isNotEmpty) &&
                        (regPassword.text == regConfirm.text)) {
                      createUserAuth();
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

  Future createUserDatabase(
      {required String name,
      required String email,
      required String password}) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final user = UserInfo(
      id: FirebaseAuth.instance.currentUser!.uid,
      name: name,
      email: email,
      password: password,
    );
    final json = user.toJson();

    await docUser.set(json);
  }

  Future createUserAuth() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: regEmail.text.trim(),
        password: regPassword.text.trim(),
      );
      if (credential.user != null) {
        credential.user?.sendEmailVerification();
      }
      setState(() {
        errorMessage = "";
      });
    } on FirebaseAuthException catch (e) {
      debugPrint("Error Message: " + e.code);
      if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        setState(() {
          errorMessage = "An account already exists for that email";
        });
      } else if (e.code == 'weak-password') {
        debugPrint('Password not strong enough');
        setState(() {
          errorMessage = "Password not strong enough";
        });
      }
    }
    if (errorMessage == "") {
      createUserDatabase(
          name: regName.text.trim(),
          email: regEmail.text.trim(),
          password: regPassword.text.trim());
      debugPrint("Register Success");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Account successfully created. An email has been sent for verification."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                child: const Text('OK'),
              ),
            ],
          );
        });
    }
  }
}

class UserInfo {
  String id;
  final String name;
  final String email;
  final String password;

  UserInfo({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };
}
