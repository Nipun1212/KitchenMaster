// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'indivRecipes.dart';
import 'package:filter_list/filter_list.dart';

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

  fetchMatchingRecipes(List<String> ingredients, List<String> filterList) async {
    QuerySnapshot querySnapshot = await recipes.get();
    List<dynamic> recipeDB;
    List<dynamic> type;
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
        print(document.get("Name"));
        print(filterList.isEmpty);
        type = document.get("Type");
        print(type.toSet().intersection(filterList.toSet()).length);
        if (filterList.isEmpty | (type.toSet().intersection(filterList.toSet()).length == filterList.length)) {
          // if (filterList.isEmpty | filterList.contains(document.get('Type'))) {
          recipeDetails.add([document, saved]);
        }
        // saved.add(checkSaved(document.get("Name")));
      } else {}
    });
  }

  Future<List<List>> getRecipes(List<String> filterList) async {
    debugPrint('getting recipes');
    List<String> ingredientList = [];
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await savedRef.doc(uid).get();
    if (docSnapshot.exists) {
      ingredientList = docSnapshot.data()!['inventory'].keys.toList();
      // You can then retrieve the value from the Map like this:
    }
    await fetchSavedRecipes();
    await fetchMatchingRecipes(ingredientList, filterList);
    return await recipeDetails;
  }
}

class _RecipePageState extends State<RecipePage> {
  Recipe test = new Recipe();
  List<String> generatedRecipes = [];
  List<String> filterList = ["vegetarian", "vegan", "halal", "no beef", "no dairy"];
  List<String> selectedFilterList = [];

  List<String> resetRecipes() {
    // test.generated = [];
    test.getRecipes(selectedFilterList);
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

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: filterList,
      selectedListData: selectedFilterList,
      choiceChipLabel: (filter) => filter,
      validateSelectedItem: (filterList, filter) => filterList!.contains(filter),
      onItemSearch: (filter, query) {
        return filter.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        // Navigator.pop(context);
        selectedFilterList = List.from(list!);
        print(selectedFilterList);
        resetRecipes();
        setState(() {});
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff6961), //Colors.red,
          title: const Text(
            "Recipes",
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openFilterDialog,
          backgroundColor: Colors.black,
          child: Icon(Icons.filter_alt),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ElevatedButton(
                  child: Text('Generate Recipes', style: TextStyle(fontSize: 20),),
                onPressed: () async {
                  //generatedRecipes = resetRecipes();
                  setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),]),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List>(
                  future: test.getRecipes(selectedFilterList),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SizedBox(
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: CircularProgressIndicator()),
                      height: 50.0,
                      width: 50.0,
                    )
                        : SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 15,

                        children: List.generate(
                          snapshot.data!.length,
                              (index) {
                            return SizedBox(
                              width:
                              (MediaQuery.of(context).size.width - 32) / 2,
                              child:Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.00),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      child: Image.network(
                                        snapshot.data![index][0]
                                            .get("Image"),
                                        fit: BoxFit.cover,
                                        color: Colors.black.withOpacity(0.5),
                                        colorBlendMode: BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        textStyle: TextStyle(
                                          fontFamily: 'Inria Serif',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      child: Text(
                                        snapshot.data![index][0].get("Name"),
                                      ),
                                      onPressed: () {
                                        String recipeName = snapshot.data![index][0].get("Name");
                                        List<dynamic> ingredients =
                                        snapshot.data![index][0].get("Ingredients");
                                        String procedure = snapshot.data![index][0].get("Procedures");
                                        procedure = addNewlineAfterStar(procedure);
                                        String image = snapshot.data![index][0].get("Image");
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 300 ),
                                            pageBuilder: (context, animation, secondaryAnimation) => indivRecipePage(
                                              recipeName: recipeName,
                                              ingredients: ingredients,
                                              procedure: procedure,
                                              image: image,
                                            ),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              return ScaleTransition(
                                                scale: Tween<double>(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: FavoriteButton(
                                      isFavorite:
                                      snapshot.data![index][1],
                                      valueChanged: (_isFavorite) {
                                        if (_isFavorite &
                                        !snapshot.data![index][1]) {
                                          var recipe = FirebaseFirestore
                                              .instance
                                              .collection("Recipes")
                                              .doc(snapshot.data![index][0]
                                              .get("Name"));
                                          String id =
                                          UniqueKey().toString();
                                          addSaved(
                                              id,
                                              snapshot.data![index][0]
                                                  .get("Name"),
                                              recipe);
                                        } else if (!_isFavorite) {
                                          removeSaved(snapshot.data![index]
                                          [0]
                                              .get("Name"));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ), );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}