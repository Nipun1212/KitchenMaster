import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Recipe {
  final CollectionReference recipes =
      FirebaseFirestore.instance.collection('Recipes');

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
      if (ingredients.toSet().length ==
          recipeDB.toSet().intersection(ingredients.toSet()).length) {
        //prints the name of recipes that matches the food items in fridge
        print(document.get("Name"));
      } else {}
    });
  }

  void getRecipes() {
    debugPrint('getting recipes');
    //fetchRecipesName();
    //ingredients passed in are case and space sensitive
    List<String> smoothie1 = ["banana", "strawberry", "apple juice"];
    List<String> smoothie2 = ["kiwi", "banana", "mango", "pineapple juice"];
    fetchMatchingRecipes(smoothie2);
  }
}
