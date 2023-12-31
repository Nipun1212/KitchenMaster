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
  late Future<Map> recipeImages;

  @override
  void initState() {
    super.initState();
    recipeImages = retrieveImageList();
  }

  final CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');

  List savedRecipes = [];

  void addSaved(String id, String recipeName, DocumentReference recipe) async {
    print("Saving recipe...");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('savedRecipes');
    DocumentReference newSavedRef = await savedRef.add({'id': id, 'name': recipeName, 'recipe': recipe});

    // final newAlertId = generateUniqueId(newAlertRef.id);
    print("Recipe saved!");
  }

  Future<void> removeSaved(String name) async {
    //delete in firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final savedRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('savedRecipes');
    var querySnapshots = await savedRef.get();
    for (var snapshot in querySnapshots.docs) {
      if (snapshot.get('name') == name) {
        savedRef.doc(snapshot.id).delete().then((value) {
          // print(snapshot.get('name'));
          print("recipe removed!");
          debugPrint('Recipe removed successfully');
        }).catchError((error) {
          debugPrint('Failed to remove recipe: $error');
        });
      }
    }
  }

  Future<Map> retrieveImageList() async {
    Map<String, String> savedRecipeImages = {};
    var recipe = FirebaseFirestore.instance.collection('Recipes').doc();
    QuerySnapshot querySnapshot = await recipes.get();
    querySnapshot.docs.forEach((document) {
      String name = document.get("Name");
      String image = document.get("Image");
      savedRecipeImages[name] = image;
    });
    return savedRecipeImages;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: recipeImages,
        builder: (context, recipeImage) {
          if (recipeImage.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
              height: 50.0,
              width: 50.0,
            );
          } else {
            return MaterialApp(
                home: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color(0xffff6961), //Colors.red,
                      title: const Text(
                        "Favourites",
                        style: TextStyle(color: Colors.white),
                      ),
                      // leading: const BackButton(
                      //   color: Colors.white,
                      // ),
                      // centerTitle: true,
                    ),
                    body: Container(
                        child: Column
                          ( mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                      // SizedBox(height: 50),
                      // const Text('Saved Recipes',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //         color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Inria Serif', fontSize: 35, fontWeight: FontWeight.normal, height: 1)),
                      SizedBox(height: 30),
                      Flexible(
                          fit: FlexFit.tight,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('savedRecipes')
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                                  height: 50.0,
                                  width: 50.0,
                                );
                              } else {
                                savedRecipes = [];
                                for (var i in snapshot.data!.docs) {
                                  savedRecipes.add((i.data() as Map)['name']);
                                }
                                print(savedRecipes);
                                return GridView.count(
                                    crossAxisCount: 2, // set number of columns to 2
                                    mainAxisSpacing: 30, // set spacing between rows
                                    crossAxisSpacing: 10,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  print("name: ${data['name']}");
                                  print(savedRecipes.contains(data['name']));

                                  String name = data["name"];
                                  return Wrap(spacing: 0, runSpacing: 15, children: [
                                    SizedBox(
                                        width: (MediaQuery.of(context).size.width - 5) / 2,
                                        child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0, right: 10.00),
                                            child: Stack(
                                                children: [
                                              Container(
                                                width: double.infinity,
                                                height: 200,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    recipeImage.data![name]!,
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
                                                  child: Text(data["name"] ?? "null",
                                                      style: TextStyle(
                                                        fontFamily: 'Inria Serif',
                                                        color: Colors.white,

                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  onPressed: () async {
                                                    print(data['recipe'].path);
                                                    var recipe = FirebaseFirestore.instance.doc(data['recipe'].path);
                                                    print("Recipe::: $recipe");
                                                    recipe.get().then((value) {
                                                      String recipeName = value.get("Name");
                                                      List<dynamic> ingredients = value.get("Ingredients");
                                                      String procedure = value.get("Procedures");
                                                      String image = value.get("Image");
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => indivRecipePage(
                                                                  recipeName: recipeName,
                                                                  ingredients: ingredients,
                                                                  procedure: procedure,
                                                                  image: image)));
                                                    });
                                                  },
                                                ),
                                              ),

                                              //Spacer(),
                                              Positioned(
                                                bottom: 16,
                                                left: 16,
                                                child: FavoriteButton(
                                                  isFavorite: savedRecipes.contains(data["name"]),
                                                  valueChanged: (_isFavorite) async {
                                                    setState(() {});
                                                    print("_isFav: $_isFavorite");
                                                    if (_isFavorite & !savedRecipes.contains(data["name"])) {
                                                      var recipe = FirebaseFirestore.instance.collection("Recipes").doc(data["name"]);
                                                      String id = UniqueKey().toString();
                                                      print(id);
                                                      addSaved(id, data["name"], recipe);
                                                    } else if (!_isFavorite) {
                                                      _isFavorite = true;
                                                      savedRecipes.remove(data['name']);
                                                      removeSaved(data["name"]);
                                                    }
                                                    print("do this?");
                                                  },
                                                )
                                              )

                                            ])
                                        )),



                                  ]);
                                }).toList());
                              }
                            },
                          ))
                    ]))));
          }
        });
  }
}
