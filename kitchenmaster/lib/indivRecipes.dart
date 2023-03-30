// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class indivRecipePage extends StatefulWidget {
  indivRecipePage({Key? key}) : super(key: key);

  @override
  State<indivRecipePage> createState() => _indivRecipePageState();
}

class _indivRecipePageState extends State<indivRecipePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(children: const <Widget>[
                    SizedBox(height: 50),
                    Text('Individual Recipe',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inria Serif',
                            fontSize: 35,
                            fontWeight: FontWeight.normal,
                            height: 1)),
                    SizedBox(height: 30),
    ]))));
  }
}
