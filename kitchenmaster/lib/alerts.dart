import 'package:flutter/material.dart';
import 'profile.dart';

class AlertsPage extends StatefulWidget {
  AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class DynamicWidget extends StatefulWidget {
  String name = '';
  String frequency = '';
  TextEditingController nameController = TextEditingController();
  String id = '';

  DynamicWidget(TextEditingController n, String value) {
    nameController = n;
    name = n.text;
    frequency = value;
    id = UniqueKey().toString();
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  DropdownButton<String>(
                    // Step 3.
                    value: widget.frequency,
                    // Step 4.
                    items: <String>[
                      'None',
                      'Daily',
                      'Weekly',
                      'Biweekly',
                      'Monthly'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.frequency = newValue!;
                      });
                    },
                  ),
                ]))));
  }
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new ProfilePage()));
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new AlertsPage()));
        break;
      case 2:
        // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new InventoryPage()));
        break;
      case 3:
        // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new RecipesPage()));
        break;
      case 4:
        // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new FavouritesPage()));
        break;
    }
  }

  int _selectedIndex = 1;

  List<DynamicWidget> listCards = [];
  List<TextEditingController> controllers = [];

  void addDynamic(TextEditingController n, String value) {
    setState(() {
      controllers.add(n);
      listCards.add(DynamicWidget(n, value));
    });
  }

  void resetDynamic() {
    setState(() {
      // if (listCards.isEmpty){
      //   //show error message
      // }
      controllers.removeRange(0, controllers.length);
      listCards.removeRange(0, listCards.length);
    });
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
              child: Column(children: <Widget>[
                const SizedBox(height: 50),
                const Text('Grocery List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inria Serif',
                        fontSize: 35,
                        fontWeight: FontWeight.normal,
                        height: 1)),
                Flexible(
                  fit: FlexFit.tight,
                  child: ListView.builder(
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
                            child: const Center(
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
              ]),
            ),
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    label: const Text('Add Item'),
                    icon: const Icon(Icons.add),
                    heroTag: "add_entries",
                    backgroundColor: Colors.black,
                    onPressed: () {
                      TextEditingController nameController =
                          new TextEditingController();
                      addDynamic(nameController, 'None');
                      setState(() {});
                    },
                  ),
                ])));
  }
  // bottomNavigationBar: BottomNavigationBar(
  //     backgroundColor: Color(0xffff6961),
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person),
  //         label: 'Profile',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.add_alert_sharp),
  //         label: 'Alerts',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.list),
  //         label: 'Inventory',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.grid_view_rounded),
  //         label: 'Recipes',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.favorite),
  //         label: 'Favourites',
  //       ),
  //     ],
  //     type: BottomNavigationBarType.fixed,
  //     currentIndex: _selectedIndex,
  //     selectedItemColor: Colors.white,
  //     iconSize: 40,
  //     onTap: _onItemTapped,
  //     elevation: 5
  // ),
}
