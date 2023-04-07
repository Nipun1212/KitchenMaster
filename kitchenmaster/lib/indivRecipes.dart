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
      required this.procedure,
      required this.image});

  String image;
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

            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(
                widget.recipeName,
                style: TextStyle(color: Colors.white),
              ),
              // leading: const BackButton(
              //   color: Colors.white,
              //     onPressed: () => Navigator.pop(context)
              // ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  }
              ),
              // centerTitle: true,
            ),
              body: SingleChildScrollView(
            child: Container(
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  SizedBox(height: 35),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //     setState(() {});
                  //   }
                  // )),
                  Text(widget.recipeName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Inria Serif',
                          fontSize: 35,
                          fontWeight: FontWeight.normal,
                          height: 1)),
                  SizedBox(height: 30),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Padding(
                  //     padding:EdgeInsets.fromLTRB(20, 0, 0, 0),
                  //
                  //     child: Text("Ingredients: ",
                  //       style: TextStyle(
                  //         color: Color.fromRGBO(0, 0, 0, 1),
                  //         fontFamily: 'Inria Serif',
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.normal,
                  //         height: 1)
                  // ))),
                  Row(children:[
                    SizedBox(width: 10),
                    Expanded(
                      child:Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(border: Border.all(color: Colors.black),),
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Ingredients ",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Inria Serif',
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    height: 1))
                          ),)),
                    SizedBox(width: 10)]),
                  SizedBox(height: 20,),
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
                  //     Flexible(
                  //         fit: FlexFit.loose,
                  //         child: ListView.builder(
                  //             shrinkWrap: true,
                  //             itemCount: widget.ingredients.length,
                  //             itemExtent: 25,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               return ListTile(
                  //                 contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                  //                 // leading: Icon(Icons.arrow_right),
                  //                 title: Row(
                  //               children: [
                  //               Icon(Icons.arrow_right),
                  //               SizedBox(width: 8.0), // Add some horizontal spacing
                  //               Text(widget.ingredients[index]),
                  //               ],)
                  //               );
                  //             }
                  //         )),
                  // Text("Ingredients: ${widget.ingredients.toString()}",
                  //     style: TextStyle(
                  //         color: Color.fromRGBO(0, 0, 0, 1),
                  //         fontFamily: 'Inria Serif',
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.normal,
                  //         height: 1)),
                  SizedBox(height: 30),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Padding(
                  //     padding:EdgeInsets.fromLTRB(20, 0, 0, 10),
                  //     child: Text("Procedure: ",
                  //       style: TextStyle(
                  //         color: Color.fromRGBO(0, 0, 0, 1),
                  //         fontFamily: 'Inria Serif',
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.normal,
                  //         height: 1)
                  // ))),
                      Row(children:[
                        SizedBox(width: 10),
                        Expanded(
                            child:Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black),),
                              alignment: AlignmentDirectional.center,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Procedure ",
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Inria Serif',
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          height: 1))
                              ),)),
                        SizedBox(width: 10)]),
                      SizedBox(height: 20,),
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
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.network("${widget.image}",
                              ))),
                      SizedBox(height: 30),
                ])))));
  }
}
