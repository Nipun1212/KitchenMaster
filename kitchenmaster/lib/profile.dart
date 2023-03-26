
import 'package:flutter/material.dart';
import 'alerts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }
  void _onItemTapped(int index) {
    switch(index){
      case 0:
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new ProfilePage()));
        break;
      case 1:
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new AlertsPage()));
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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Hello, Grace!', textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Jacques Francois',
                          fontSize: 30,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      )),
                ]   )),
      //
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

    );
  }
}