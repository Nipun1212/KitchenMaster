// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fridgemaster/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  
  late Map<String, int> _results;
  bool imageSelect = false;
  bool isLoading = false;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    final List classList = ['egg', 'broccoli', 'banana', 'apple', 'chicken', 'pineapple', 'orange', 'pork'];

    print("=================IMAGE PATH HERE: ${pickedFile?.path}=================");
    // Send the image to the Google Cloud Vision API for prediction
    final String apiKey = "AIzaSyBXiiy7RW-SXoN02zmekWS-8W9mO8cn1Mk";
    final String url = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";
    final String base64Image = base64Encode(File(pickedFile!.path).readAsBytesSync());
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "OBJECT_LOCALIZATION", "maxResults": 50},
              {"type": "DOCUMENT_TEXT_DETECTION", "model": "builtin/latest", "maxResults": 100},
            ],
          },
        ],
      }),
    );
    // Parse the response and extract the predictions
    final Map<String, dynamic> data = jsonDecode(response.body);
    Map<String, int> _predictions = {};
    String _textFound = "";

    // print(response.body);
    // Get all the predictions via object detection in the classList 
    List<dynamic>? itemDetected = data["responses"][0]["localizedObjectAnnotations"];
    if (itemDetected != null) {
      itemDetected = itemDetected.map((label) => label["name"].toString().toLowerCase()).toList();
      for (String item in itemDetected) {
        print("$item : ${classList.contains(item)}");
        if (classList.contains(item)){
          print("item found via image: $item");
          _predictions[item] ??=0;
          _predictions[item] = _predictions[item]! + 1;
        }
      }
    }
    // Get all the predictions via text detection in the classList 
    List<dynamic>? textDetected = data["responses"][0]["textAnnotations"];
    if (textDetected != null) {
      _textFound = textDetected.map((label) => label["description"].toString().toLowerCase().replaceAll("\n", "")).toList().join(" ");
      for (String item in classList) {
        if (_textFound.contains(item)) {
          print("item found via text: $item");
          _predictions[item] ??=0;
          _predictions[item] = _predictions[item]! + 1;
        }
      }
    }
    // Initialize inventory list for each predictions found 
    print("predicted!! $_predictions");
    _predictions.forEach((item, count){
      addDynamic(TextEditingController(text:item), count);
    });

    setState(() {
      isLoading = true;
      imageSelect = false;
      _results = _predictions;
    });
    return _results;
  }

  void addDynamic(TextEditingController n, int c) {
    setState(() {
      List existingControllers = controllers.map((label) => label.text).toList();
      if (existingControllers.contains(n.text)){
        listCards[existingControllers.indexOf(n.text)].count += c; 
        print("Updated for ${n.text}, ${listCards[existingControllers.indexOf(n.text)].count}");
      } else {
        controllers.add(n);
        listCards.add(new DynamicWidget(n, c));
      }
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
}
