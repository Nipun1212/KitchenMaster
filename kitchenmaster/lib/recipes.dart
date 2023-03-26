// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key? key}) : super(key: key);
  static List<String> favourites = [];

  static List<String> getFavourites() {
    return favourites;
  }

  static void addFavourites(String newValue) {
    favourites.add(newValue);
  }

  static void removeFavourites(String value) {
    favourites.remove(value);
  }

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(children: <Widget>[
      SizedBox(height: 50),
      const Text('Recipes',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Inria Serif',
              fontSize: 35,
              fontWeight: FontWeight.normal,
              height: 1)),
      SizedBox(height: 30),
      Flexible(
          fit: FlexFit.tight,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Recipes').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                      elevation: 0,
                      color: Color.fromARGB(0, 255, 255, 255),
                      child: Center(
                          child: SizedBox(
                              width: 350,
                              height: 60,
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  TextButton(
                                    child: Text(document['Name']),
                                    onPressed: () {
                                      // navigate to indiv recipe page
                                    },
                                  ),
                                  FavoriteButton(
                                    valueChanged: (_isFavorite) {
                                      if (_isFavorite) {
                                        RecipePage.addFavourites(
                                            document['Name']);
                                        print(RecipePage.getFavourites());
                                      } else if (!_isFavorite) {
                                        RecipePage.removeFavourites(
                                            document['Name']);
                                        print(RecipePage.getFavourites());
                                      }
                                    },
                                  )
                                ])
                              ]))));
                }).toList(),
              );
            },
          ))
    ]))));
  }
}
