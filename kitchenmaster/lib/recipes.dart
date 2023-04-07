// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'indivRecipes.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class Recipe {
  final CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');

  List<String> generated = [];
  List<List> recipeDetails = [];
  List<String> savedRecipes = [];
  // List<bool> saved = [];

  void fetchRecipesName() async {
    QuerySnapshot querySnapshot = await recipes.get();

    querySnapshot.docs.forEach((document) {
      String name = document.get("Name");
      print(name);
    });
  }

  fetchSavedRecipes() async {
    savedRecipes = [];
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('savedRecipes');
    var querySnapshots = await savedRef.get();
    for (var snapshot in querySnapshots.docs) {
      savedRecipes.add(snapshot.get("name"));
    }
  }

  fetchMatchingRecipes(List<String> ingredients) async {
    QuerySnapshot querySnapshot = await recipes.get();
    List<dynamic> recipeDB;
    generated = [];
    recipeDetails = [];
    querySnapshot.docs.forEach((document) {
      //gets array of String type from Ingredient column in database
      recipeDB = document.get("Ingredients");
      //checks if the food items in fridge is a subset of items in recipe
      if (recipeDB.toSet().intersection(ingredients.toSet()).length != 0) {
        //prints the name of recipes that matches the food items in fridge
        generated.add(document.get("Name"));
        bool saved = savedRecipes.contains(document.get("Name"));
        recipeDetails.add([document, saved]);
        // saved.add(checkSaved(document.get("Name")));
      } else {}
    });
  }

  // Future<bool> checkSaved(String name) async {
  //   if (savedRecipes.contains(name)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<List<List>> getRecipes() async {
    debugPrint('getting recipes');
    List<String> ingredientList = [];
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await savedRef.doc(uid).get();
    if (docSnapshot.exists) {
      ingredientList = docSnapshot.data()!['inventory'].keys.toList();
      // You can then retrieve the value from the Map like this:
    }
    //fetchRecipesName();
    //ingredients passed in are case and space sensitive
    // List<String> smoothie1 = ["banana", "strawberry", "apple juice"];
    // List<String> smoothie2 = ["kiwi", "banana", "mango", "pineapple juice"];
    // List<String> smoothie3 = ["banana"];

    // fetchMatchingRecipes(smoothie3);
    // fetchMatchingRecipes(smoothie2);
    // print(ingredientList);
    await fetchSavedRecipes();
    await fetchMatchingRecipes(ingredientList);
    return await recipeDetails;
  }
}

class _RecipePageState extends State<RecipePage> {
  Recipe test = new Recipe();
  List<String> generatedRecipes = [];

  List<String> resetRecipes() {
    // test.generated = [];
    test.getRecipes();
    setState(() {});
    return [];
  }

  //update firebase
  void addSaved(String id, String recipeName, DocumentReference recipe) async {
    print("Saving recipe...");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('savedRecipes');
    DocumentReference newSavedRef = await savedRef.add({'id': id, 'name': recipeName, 'recipe': recipe});

    // final newAlertId = generateUniqueId(newAlertRef.id);
    print("Recipe saved!");
  }

  void removeSaved(String name) async {
    //delete in firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('savedRecipes');
    var querySnapshots = await savedRef.get();
    for (var snapshot in querySnapshots.docs) {
      if (snapshot.get('name') == name) {
        savedRef.doc(snapshot.id).delete().then((value) {
          print(snapshot.get('name'));
          debugPrint('Recipe removed successfully');
        }).catchError((error) {
          debugPrint('Failed to remove recipe: $error');
        });
      }
    }
  }

  ///// makes the procedures in order
  String addNewlineAfterStar(String inputString) {
    String outputString = '';
    for (int i = 0; i < inputString.length; i++) {
      if (inputString[i] == '*') {
        continue;
      }
      outputString += inputString[i];
      if (i < inputString.length - 1 && inputString[i + 1] == '*') {
        outputString += '\n';
      }
    }
    return outputString;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      SizedBox(height: 50),
      const Text('Recipes',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Inria Serif', fontSize: 35, fontWeight: FontWeight.normal, height: 1)),
      SizedBox(height: 30),
      ElevatedButton(
        child: Text('Generate Recipes'),
        onPressed: () async {
          //generatedRecipes = resetRecipes();
          setState(() {});
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
        child: FutureBuilder<List>(
          future: test.getRecipes(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const SizedBox(
                    child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                    height: 50.0,
                    width: 50.0,
                  )
                : SingleChildScrollView(
                    child: Column(
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
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    alignment: Alignment.centerLeft, // align text to left
                                                    primary: Colors.lightBlue,
                                                    textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  child: Text(snapshot.data?[index][0].get("Name") ?? "null"),
                                                  onPressed: () {
                                                    String recipeName = snapshot.data![index][0].get("Name");
                                                    List<dynamic> ingredients = snapshot.data![index][0].get("Ingredients");
                                                    String procedure = snapshot.data![index][0].get("Procedures");
                                                    procedure = addNewlineAfterStar(procedure);
                                                    String image = snapshot.data![index][0].get("Image");
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => indivRecipePage(
                                                                recipeName: recipeName,
                                                                ingredients: ingredients,
                                                                procedure: procedure,
                                                                image: image)));
                                                  },
                                                ),
                                              ),
                                              FavoriteButton(
                                                isFavorite: snapshot.data![index][1],
                                                valueChanged: (_isFavorite) {
                                                  if (_isFavorite & !snapshot.data![index][1]) {
                                                    var recipe =
                                                        FirebaseFirestore.instance.collection("Recipes").doc(snapshot.data?[index][0].get("Name"));
                                                    String id = UniqueKey().toString();
                                                    addSaved(id, snapshot.data?[index][0].get("Name"), recipe);
                                                  } else if (!_isFavorite) {
                                                    removeSaved(snapshot.data?[index][0].get("Name"));
                                                  }
                                                },
                                              )
                                            ]),
                                      ))));
                        },
                      ),
                    ),
                  );
          },
        ),
      )
    ]))));
  }
}
//
// new ListView.builder(
// itemCount: generatedRecipes.length,
// itemBuilder: (BuildContext context, int index) {
// // return ListView(
// //   children: snapshot.data!.docs.map((document) {
// return Card(
// elevation: 0,
// color: Color.fromARGB(0, 255, 255, 255),
// child: Center(
// child: SizedBox(
// width: 350,
// height: 60,
// child: Column(children: <Widget>[
// Row(children: <Widget>[
// TextButton(
// child: Text(generatedRecipes[index]),
// onPressed: () {
// // navigate to indiv recipe page
// },
// ),
// FavoriteButton(
// valueChanged: (_isFavorite) {
// if (_isFavorite) {
// RecipePage.addFavourites(
// generatedRecipes[index]);
// print(RecipePage.getFavourites());
// } else if (!_isFavorite) {
// RecipePage.removeFavourites(
// generatedRecipes[index]);
// print(RecipePage.getFavourites());
// }
// },
// )
// ])
// ]))));
// }),
