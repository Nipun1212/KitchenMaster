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

  @override
  Widget build(BuildContext context) {
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
                child: Column(children: <Widget>[
              SizedBox(height: 50),
              const Text('Saved Recipes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Inria Serif', fontSize: 35, fontWeight: FontWeight.normal, height: 1)),
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
                        return ListView(
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          print("name: ${data['name']}");
                          print(savedRecipes.contains(data['name']));
                          return Card(
                              elevation: 0,
                              color: Color.fromARGB(0, 255, 255, 255),
                              child: Center(
                                  child: SizedBox(
                                      width: 350,
                                      height: 60,
                                      child: Row(children: <Widget>[
                                        TextButton(
                                          child: Text(data["name"] ?? "null", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold,)),
                                          onPressed: () async {
                                            print(data['recipe'].path);
                                            var recipe = FirebaseFirestore.instance.doc(data['recipe'].path);
                                            print("Recipe::: $recipe");
                                            recipe.get().then((value) {
                                              String recipeName = value.get("Name");
                                              List<dynamic> ingredients = value.get("Ingredients");
                                              String procedure = value.get("Procedures");
                                              String image=value.get("Image");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          indivRecipePage(recipeName: recipeName, ingredients: ingredients, procedure: procedure, image:image)));
                                            });
                                          },
                                        ),
                                        Spacer(),
                                        FavoriteButton(
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
                                      ]))));
                        }).toList());
                      }
                    },
                  ))
            ]))));
  }
}
