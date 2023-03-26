// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
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

class _RecipePageState extends State<RecipePage> {
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
            body: ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${recipes[index]}'),
        );
      },
    )));
  }
}
