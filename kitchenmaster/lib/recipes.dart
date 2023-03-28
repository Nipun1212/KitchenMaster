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

class Recipe {
  final CollectionReference recipes =
      FirebaseFirestore.instance.collection('Recipes');

  List<String> generated = [];
  List<String> procedures = []; // for displaying the procedures

  void fetchRecipesName() async {
    QuerySnapshot querySnapshot = await recipes.get();

    querySnapshot.docs.forEach((document) {
      String name = document.get("Name");
      print(name);
    });
  }

  void fetchMatchingRecipes(List<String> ingredients) async {
    QuerySnapshot querySnapshot = await recipes.get();
    List<dynamic> recipeDB;
    querySnapshot.docs.forEach((document) {
      //gets array of String type from Ingredient column in database
      recipeDB = document.get("Ingredients");
      //checks if the food items in fridge is a subset of items in recipe
      if (recipeDB.toSet().length ==
          recipeDB.toSet().intersection(ingredients.toSet()).length) {
        //prints the name of recipes that matches the food items in fridge
        print(document.get("Name"));
        generated.add(document.get("Name"));
        procedures.add(document.get("Procedures"));
      } else {}
    });
  }

  ////USE THIS FUNCTION TO SET SAVED RECIPE TO FIREBASE//////
  void setSaved(String RecipeName, bool State) {
    //RecipeName : name of food item eg Kiwi Fruit Smoothie
    // State: set state to either True or False
    recipes.doc(RecipeName).update({"Saved": State});
  }

  List<String> getRecipes() {
    debugPrint('getting recipes');
    //fetchRecipesName();
    //ingredients passed in are case and space sensitive
    List<String> smoothie1 = ["banana", "strawberry", "apple juice"];
    List<String> smoothie2 = ["kiwi", "banana", "mango", "pineapple juice"];
    fetchMatchingRecipes(smoothie2);
    return generated;
  }
}

class _RecipePageState extends State<RecipePage> {
  Recipe test = new Recipe();
  List<String> generatedRecipes = [];

  List<String> resetRecipes() {
    setState(() {});
    // test.generated = [];
    return test.getRecipes();
  }

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
      ElevatedButton(
        child: Text('Reset Inventory'),
        onPressed: () async {
          generatedRecipes = resetRecipes();
          setState(() {
            // generatedRecipes = test.getRecipes();
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      Flexible(
        fit: FlexFit.tight,
        // child: StreamBuilder(
        //   stream:
        //       FirebaseFirestore.instance.collection('Recipes').snapshots(),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (!snapshot.hasData) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        child: new ListView.builder(
            itemCount: generatedRecipes.length,
            itemBuilder: (BuildContext context, int index) {
              // return ListView(
              //   children: snapshot.data!.docs.map((document) {
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
                                child: Text(generatedRecipes[index]),
                                onPressed: () {
                                  // navigate to indiv recipe page
                                },
                              ),
                              FavoriteButton(
                                valueChanged: (_isFavorite) {
                                  if (_isFavorite) {
                                    RecipePage.addFavourites(
                                        generatedRecipes[index]);
                                    print(RecipePage.getFavourites());

                                    ///UPDATES RECIPE AS SAVED TO FIREBASE
                                    test.setSaved(
                                        generatedRecipes[index], true);
                                  } else if (!_isFavorite) {
                                    RecipePage.removeFavourites(
                                        generatedRecipes[index]);
                                    print(RecipePage.getFavourites());

                                    ///UPDATES RECIPE AS not SAVED TO FIREBASE
                                    test.setSaved(
                                        generatedRecipes[index], false);
                                  }
                                },
                              )
                            ])
                          ]))));
            }),
      )
    ]))));
  }
}
