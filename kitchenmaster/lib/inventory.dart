// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class DynamicWidget extends StatefulWidget {
  String name = '';
  int count = 0;
  TextEditingController _nameController = TextEditingController();

  DynamicWidget(TextEditingController n, int c) {
    this._nameController = n;
    this.name = n.text;
    this.count = c;
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  String name = '';
  int count = 0;
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Center(
            child: SizedBox(
                width: 400,
                height: 60,
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          count += 1;
                        });
                      }),
                  Text('$count'),
                  IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if(count>0) {
                            count -= 1;
                          }
                          // else if(count==0){
                          // }
                        });
                      }),
                ]))));
  }
}

class _InventoryPageState extends State<InventoryPage> {
  List<DynamicWidget> listCards = [];
  List<TextEditingController> controllers = [];
  TextEditingController _nameController = new TextEditingController();
  int count = 0;

  addDynamic(TextEditingController n, int c) {
    controllers.add(n);
    listCards.add(new DynamicWidget(n, c));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: <Widget>[
              SizedBox(height: 25),
              const Text('Inventory List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inria Serif',
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      height: 1)),
              // SizedBox(
              //   height: 50,
              //   child: Card(
              //       child: SizedBox(
              //           width: 450,
              //           height: 50,
              //           child: Row(children: <Widget>[
              //             Expanded(
              //               child: TextField(
              //                 controller: _nameController,
              //               ),
              //             ),
              //             IconButton(
              //                 icon: const Icon(Icons.add_circle_outline),
              //                 onPressed: () {
              //                   setState(() {
              //                     count += 1;
              //                   });
              //                 }),
              //             Text('$count'),
              //             IconButton(
              //                 icon: const Icon(Icons.remove_circle_outline),
              //                 onPressed: () {
              //                   setState(() {
              //                     count -= 1;
              //                   });
              //                 }),
              //           ]))),
              // ),
              Flexible(
                child: new ListView.builder(
                    itemCount: listCards.length,
                    itemBuilder: (_, index) => listCards[index]),
              ),
            ]),
            floatingActionButton: ElevatedButton(
              child: Text('Add entries'),
              onPressed: () {
                TextEditingController _nameController =
                    new TextEditingController();
                addDynamic(_nameController, 0);
              },
            )));
  }
}