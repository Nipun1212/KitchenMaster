// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fridgemaster/recipes.dart';
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

  Future<List> fetchSavedRecipes() async {
    print("fetching saved");
    QuerySnapshot querySnapshot = await recipes.get();
    List<dynamic> recipeDB;
    savedRecipes = [];
    querySnapshot.docs.forEach((document) {
      // check if saved function is saved
      if (document["saved"]) {
        //prints the name of recipes that matches the food items in fridge
        print(document.get("Name"));
        savedRecipes.add(document);
      } else {}
    });
    // if (savedRecipes.length <= 0){
    // }
    // else {
    return await savedRecipes;
    // }
  }

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
        child: FutureBuilder<List>(
          future: fetchSavedRecipes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  child: Text("No Recipes Saved to Favourites Yet!"));
            } else {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return Card(
                              elevation: 0,
                              color: Color.fromARGB(0, 255, 255, 255),
                              child: Center(
                                  child: SizedBox(
                                      width: 350,
                                      height: 60,
                                      child: Row(children: <Widget>[
                                        TextButton(
                                          child: Text(snapshot.data?[index]
                                                  .get("Name") ??
                                              "null"),
                                          onPressed: () {
                                            String recipeName = snapshot
                                                .data![index]
                                                .get("Name");
                                            List<dynamic> ingredients = snapshot
                                                .data![index]
                                                .get("Ingredients");
                                            String procedure = snapshot
                                                .data![index]
                                                .get("Procedures");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        indivRecipePage(
                                                            recipeName:
                                                                recipeName,
                                                            ingredients:
                                                                ingredients,
                                                            procedure:
                                                                procedure)));
                                          },
                                        ),
                                        // FavoriteButton(
                                        //   valueChanged: (_isFavorite) {
                                        //     if (_isFavorite) {
                                        //       snapshot.data![index].update({"saved": true});
                                        //     } else if (!_isFavorite) {
                                        //       snapshot.data![index].update({"saved": false});
                                        //     }
                                        //   },
                                        // )
                                      ]))));
                        },
                      ),
                    );
            }
          },
        ),
      )
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
