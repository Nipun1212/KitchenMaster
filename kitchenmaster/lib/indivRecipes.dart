// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class indivRecipePage extends StatefulWidget {
  indivRecipePage(
      {super.key,
      required this.recipeName,
      required this.ingredients,
      required this.procedure});

  String recipeName;
  List<dynamic> ingredients;
  String procedure;

  @override
  State<indivRecipePage> createState() => _indivRecipePageState();
}

class _indivRecipePageState extends State<indivRecipePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
          SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            }
          )),
          Text(widget.recipeName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 35,
                  fontWeight: FontWeight.normal,
                  height: 1)),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text("Ingredients: ",
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1)
          ))),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:Text("• ${widget.ingredients[index]}",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inria Serif',
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      height: 1)));
            }
          )),
          // Text("Ingredients: ${widget.ingredients.toString()}",
          //     style: TextStyle(
          //         color: Color.fromRGBO(0, 0, 0, 1),
          //         fontFamily: 'Inria Serif',
          //         fontSize: 20,
          //         fontWeight: FontWeight.normal,
          //         height: 1)),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text("Procedure: ",
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inria Serif',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1)
          ))),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:EdgeInsets.fromLTRB(20, 0, 0, 0),
              child:Text("${widget.procedure}",
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inria Serif',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1)
          ))),
          SizedBox(height: 30),
        ]))));
  }
}
