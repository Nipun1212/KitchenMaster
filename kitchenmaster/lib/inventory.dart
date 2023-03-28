// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:fridgemaster/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class InventoryPage extends StatefulWidget {
  InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class DynamicWidget extends StatefulWidget {
  String name = '';
  int count = 0;
  TextEditingController nameController = TextEditingController();
  String id = '';

  DynamicWidget(TextEditingController n, int c) {
    nameController = n;
    name = n.text;
    count = c;
    id = UniqueKey().toString();
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
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
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: widget.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          widget.count += 1;
                        });
                      }),
                  Text('${widget.count}'),
                  IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (widget.count > 0) {
                            widget.count -= 1;
                          }
                          // if(count<=0) {
                          //   //remove dynamic
                          // }
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
  //TextEditingController nameController = new TextEditingController();

  File? _image;
  List _result = [];
  String image_name = "";
  getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    debugPrint("Image.path: " + image!.path);
    setState(() {
      removeNoName();
      _image = File(image.path);
      image_name = File(image.path).toString().split('/').last.split('.').first;
      TextEditingController nameController =
          new TextEditingController(text: image_name);
      addDynamic(nameController, 0);
      image_name = "";
      //debugPrint("Apply on: " + _image!.path);
      //applyModelOnImage(_image!);
    });
  }

  loadMyModel() async {
    String? result = await Tflite.loadModel(
        model: "assets/kitchen_master.tflite", labels: "assets/labels.txt");
    debugPrint("Result: $result");
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
        path: file.path,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 2,
        threshold: 0.1,
        asynch: true);

    _result = res!;
    String str = _result[0]["labels"];
    debugPrint("Results Label:" + str);
    debugPrint("Results Label Substring:" + str.substring(2));
    debugPrint("Results Confidence:" +
        (_result[0]["confidence"] * 100.0).toString().substring(0, 2));
  }

  void addDynamic(TextEditingController n, int c) {
    setState(() {
      controllers.add(n);
      listCards.add(new DynamicWidget(n, c));
    });
  }

  //created object for recipe
  // use reset button to test the fetching of recipe data
  Recipe test = new Recipe();
  ///////////////////////////////////////
  void resetDynamic() {
    setState(() {
      // if (listCards.isEmpty){
      //   //show error message
      // }
      controllers.removeRange(0, controllers.length);
      listCards.removeRange(0, listCards.length);
    });
///// ADDED THIS FUNCTION TO TEST FETCHING OF RECIPE DATA/////
    test.getRecipes();
/////////////////////////////////////////////////////////////
  }

  void removeNoName() {
    setState(() {
      for (var i = 0; i < listCards.length; i++) {
        if (listCards[i].nameController.text.isEmpty) {
          controllers.removeAt(i);
          listCards.removeAt(i);
          i--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                removeNoName();
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Color.fromARGB(100, 255, 105, 97),
                      color: Colors.white),
                  child: Column(children: <Widget>[
                    SizedBox(height: 50),
                    const Text('Inventory List',
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
                      onPressed: () {
                        resetDynamic();
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
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: new ListView.builder(
                          itemCount: listCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  controllers.removeAt(index);
                                  listCards.removeAt(index);
                                });
                              },
                              secondaryBackground: Container(
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                color: Colors.red,
                              ),
                              key: Key(listCards[index].id),
                              child: listCards[index],
                              background: Container(),
                            );
                          }),
                    ),
                  ])),
            ),
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    label: const Text('Upload New Photo'),
                    icon: const Icon(Icons.add_a_photo),
                    heroTag: "upload_photo",
                    onPressed: () {
                      getImage();
                    },
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton.extended(
                    label: const Text('Add entries'),
                    icon: const Icon(Icons.add),
                    heroTag: "add_entries",
                    onPressed: () {
                      TextEditingController nameController =
                          new TextEditingController();
                      addDynamic(nameController, 0);
                      setState(() {});
                    },
                    backgroundColor: Colors.black,
                  ),
                ])));
  }

  @override
  void initState() {
    super.initState();
    //loadMyModel();
  }
}
