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

  int _selectedIndex = 0;
  TextEditingController enterName = TextEditingController();
  TextEditingController enterEmail = TextEditingController();
  TextEditingController enterPassword = TextEditingController();
  TextEditingController enterConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe5e5e5),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          Text('Hello, Grace!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Jacques Francois',
                fontSize: 30,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.topLeft,
              width: 400,
              // height: 610,
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                // color: Color(0x33ff6961),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    // Expanded(child:
                    Text('Name:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.699999988079071),
                            fontFamily: 'IBM Plex Serif',
                            fontSize: 22,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1)),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: enterName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'IBM Plex Serif',
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: Colors.black54), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color(0xffff6961)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    )),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Forgot Password?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.699999988079071),
                          fontFamily: 'IBM Plex Serif',
                          fontSize: 22,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1)),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: enterEmail,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'IBM Plex Serif',
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.black54), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color(0xffff6961)), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: enterPassword,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'IBM Plex Serif',
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter New Password",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.black54), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color(0xffff6961)), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: enterConfirm,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'IBM Plex Serif',
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.black54), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color(0xffff6961)), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      child: Text('Save', style: TextStyle(fontSize: 22)),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(width: 1.5, color: Colors.black54)),
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size.fromWidth(160.0)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffff6961)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.grey.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.black54.withOpacity(0.12);
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {}),
                  SizedBox(
                    height: 50,
                  ),
                  Row(children: [
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          width: 1.5,
                                          color: Color(0xffff6961)))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffff6961)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  color: Color(0xffff6961),
                                  fontSize: 15,
                                  fontFamily: 'IM FELL English SC'),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.logout,
                              color: Color(0xffff6961),
                            ),
                          ],
                        ))
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      width: 400,
                      height: 65,
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Color(0x33ff6961),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Text("Contact Us",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'Iceland'))),
                        Divider(
                          thickness: 2,
                          color: Colors.black26,
                        ),
                        Expanded(
                            child: Row(children: <Widget>[
                          Icon(Icons.call, size: 20),
                          SizedBox(width: 5),
                          Text("+65 1234 5678"),
                          Spacer(),
                          Icon(Icons.email, size: 20),
                          SizedBox(
                            width: 5,
                          ),
                          Text("kitchenMaster@email.com"),
                        ]))
                      ]))
                ],
              )),
        ]))
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
