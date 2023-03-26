// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

class RecipesPage extends StatefulWidget {
  RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class DynamicWidget extends StatefulWidget {
  String recipeName = '';
  bool favourite = false;

  DynamicWidget(String n, bool fav) {
    recipeName = n;
    favourite = fav;
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  // @override
  // void initState() {
  //   super.initState();
  // }
  List<String> favourites = [];

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Color.fromARGB(0, 255, 255, 255),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(25),
        //   side: BorderSide(
        //     color: Color.fromARGB(97, 0, 0, 0),
        //   ),
        // ),
        child: Center(
            child: SizedBox(
                width: 350,
                height: 60,
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Text('${widget.recipeName}'),
                    FavoriteButton(
                      valueChanged: (_isFavorite) {
                        widget.favourite = true;
                        favourites.add(widget.recipeName);
                      },
                    )
                  ])
                ]))));
  }
}

class _RecipesPageState extends State<RecipesPage> {
  List<DynamicWidget> recipes = [];

  void addRecipes(String n, bool fav) {
    setState(() {
      recipes.add(new DynamicWidget(n, fav));
    });
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
                  Flexible(
                      fit: FlexFit.tight,
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${recipes[index]}'),
                          );
                        },
                      ))
                ]))));
  }
}
