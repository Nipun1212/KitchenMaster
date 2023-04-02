// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fridgemaster/recipes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'indivRecipes.dart';

class FavouritesPage extends StatefulWidget {
  FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  // List<String> favourites = RecipePage.getFavourites();

  @override
  void initState() {
    super.initState();
  }

  final CollectionReference recipes =
      FirebaseFirestore.instance.collection('Recipes');

  List savedRecipes = [];

  // Future<List> fetchSavedRecipes() async {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   final savedRef = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('savedRecipes');
  //   // var querySnapshots = await savedRef.get();
  //   // for (var snapshot in querySnapshots.docs) {
  //   //   return snapshot.get('recipe');
  //   // }
  //   // final recipeNames = savedRef.docs
  //   //     .map((doc) => doc.data()['savedrecipes'])
  //   //     .expand((recipes) => recipes)
  //   //     .map((recipe) => recipe['name']);
  //   // print(recipeNames);
  //   // return recipeNames;
  //   return savedRef.snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(children: <Widget>[
      SizedBox(height: 50),
      const Text('Saved Recipes',
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('savedRecipes')
                .snapshots(),
            builder: (context, snapshot) {
              // if (snapshot.hasError) {
              //   return const Text('Something went wrong');
              // }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                    elevation: 0,
                    color: Color.fromARGB(0, 255, 255, 255),
                    child: Center(
                        child: SizedBox(
                            width: 350,
                            height: 60,
                            child: Row(children: <Widget>[
                              TextButton(
                                child: Text(data["name"] ?? "null"),
                                onPressed: () async {
                                  print(data['recipe'].path);
                                  var recipe = FirebaseFirestore.instance
                                      .doc(data['recipe'].path);
                                  print("Recipe::: $recipe");
                                  recipe.get().then((value) {
                                    String recipeName = value.get("Name");
                                    List<dynamic> ingredients =
                                        value.get("Ingredients");
                                    String procedure = value.get("Name");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                indivRecipePage(
                                                    recipeName: recipeName,
                                                    ingredients: ingredients,
                                                    procedure: procedure)));
                                  });
                                  // String recipeName = snapshot
                                  //     .data![index]
                                  //     .get("Name");
                                  // List<dynamic> ingredients =
                                  //     snapshot.data![index]
                                  //         .get("Ingredients");
                                  // String procedure = snapshot
                                  //     .data![index]
                                  //     .get("Procedures");
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             indivRecipePage(
                                  //                 recipeName:
                                  //                     recipeName,
                                  //                 ingredients:
                                  //                     ingredients,
                                  //                 procedure:
                                  //                     procedure)));
                                },
                              ),
                            ]))));
              }).toList());
            },
          ))
    ]))));
  }
}




// Flexible(
//           fit: FlexFit.tight,
//           child: StreamBuilder(
//             stream:
//                 FirebaseFirestore.instance.collection('Recipes').snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               return ListView(
//                 children: snapshot.data!.docs
//                     .where((x) => x['saved'] == true)
//                     .map((document) {
//                   return Card(
//                       elevation: 0,
//                       color: Color.fromARGB(0, 255, 255, 255),
//                       child: Center(
//                           child: SizedBox(
//                               width: 350,
//                               height: 60,
//                               child: Column(children: <Widget>[
//                                 Row(children: <Widget>[
//                                   TextButton(
//                                     child: Text(document['Name']),
//                                     onPressed: () {
//                                       // navigate to indiv recipe page
//                                     },
//                                   ),
//                                   FavoriteButton(
//                                     isFavorite: true,
//                                     valueChanged: (_isFavorite) {
//                                       if (_isFavorite) {
//                                       } else if (!_isFavorite) {}
//                                     },
//                                   )
//                                 ])
//                               ]))));
//                 }).toList(),
//               );
//             },
//           ))
