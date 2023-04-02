import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
// import 'package:fridgemaster/ResetPassword.dart';
import 'package:fridgemaster/main.dart';
import 'alerts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String imageUrl = "";
  String name = "";
  String email = "";
  
  @override
  void initState() {
    super.initState();
    getUsersName();
    getCurrentUserProfile();
  }

  void getUsersName() async {
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    var document = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    setState(() {
      userName = document["name"];
      email= document["email"];
    });
    debugPrint(userName);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyApp()));
  }

  void getCurrentUserProfile() async {
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance.ref().child(userUid + ".jpg");

    ref.getDownloadURL().then((value) {
      debugPrint(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  void pickUploadProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery, 
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    var userUid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance.ref().child(userUid + ".jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      debugPrint(value);
      setState(() {
        imageUrl = value;
      });
    });
  }


  Future resetPassword() async {
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    var document = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: document["email"]);
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
  // TextEditingController enterName = TextEditingController();
  // TextEditingController enterEmail = TextEditingController();
  // TextEditingController enterPassword = TextEditingController();
  // TextEditingController enterConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xffe5e5e5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pickUploadProfileImage();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 80),
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Center(
                    child: imageUrl == "" ? const Icon(
                      Icons.person, size: 80, color: Colors.white,
                      ) : Image.network(imageUrl),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Personal information', style: TextStyle(fontSize: 30.00, color: Colors.black), textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10.0,),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Name : ", style: TextStyle(fontSize: 20.00, color: Colors.black), textAlign: TextAlign.left,),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.all(6.9),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 2),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("$userName", style: TextStyle(fontSize: 16.00, color: Colors.black)),
              ),
              SizedBox(height: 20.0,),
              Container(
                alignment: Alignment.topLeft,
                child: Text("E-mail : ", style: TextStyle(fontSize: 20.00, color: Colors.black), textAlign: TextAlign.left,),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.all(6.9),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 2),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("$email", style: TextStyle(fontSize: 16.00, color: Colors.black),),
              ),
              Container(height: 20, width: 100),
              TextButton(
                child: Text('Reset Password', style: TextStyle(fontSize: 22)),
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(width: 1.5, color: Colors.black54)),
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size.fromWidth(200.0)),
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
                onPressed: () async {
                  resetPassword();

                  // Navigator.push(
                  //     context,
                  //      MaterialPageRoute(builder: (context) => ResetPasswordPage())
                  // );
                }),
              Container(height: 40, width: 100),
                Row(children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {signOut();},
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
              Container(height: 20, width: 100),
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
                ])),
              Container(height: 20, width: 100)
              ],
            ),
        )),
           // ]
    //))
        //  ],
      //  ),

           // ],
        //  )
   // ),
    //  ),
        // body: Center(
        //     child:
        //         Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        //             Widget>[
        //   Text('Welcome Back, $userName!',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: Color.fromRGBO(0, 0, 0, 1),
        //         fontFamily: 'Jacques Francois',
        //         fontSize: 30,
        //         letterSpacing:
        //             0 /*percentages not used in flutter. defaulting to zero*/,
        //         fontWeight: FontWeight.normal,
        //       )),
        //   SizedBox(
        //     height: 20,
        //   ),
        //   Container(
        //       alignment: Alignment.topLeft,
        //       width: 400,
        //       // height: 610,
        //       padding: EdgeInsets.only(
        //           left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        //       decoration: BoxDecoration(
        //         // color: Color(0x33ff6961),
        //         borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(10),
        //           topRight: Radius.circular(10),
        //           bottomLeft: Radius.circular(10),
        //           bottomRight: Radius.circular(10),
        //         ),
        //       ),
        //       child: Column(
        //         children: <Widget>[
        //           Row(children: <Widget>[
        //             // Expanded(child:
        //             Text('Name:',
        //                 textAlign: TextAlign.left,
        //                 style: TextStyle(
        //                     color: Color.fromRGBO(0, 0, 0, 0.699999988079071),
        //                     fontFamily: 'IBM Plex Serif',
        //                     fontSize: 22,
        //                     letterSpacing:
        //                         0 /*percentages not used in flutter. defaulting to zero*/,
        //                     fontWeight: FontWeight.normal,
        //                     height: 1)),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Expanded(
        //                 child: TextFormField(
        //               controller: enterName,
        //               style: TextStyle(
        //                 color: Colors.black,
        //                 fontSize: 22,
        //                 fontFamily: 'IBM Plex Serif',
        //               ),
        //               cursorColor: Colors.black,
        //               decoration: InputDecoration(
        //                 filled: true,
        //                 fillColor: Colors.white,
        //                 hintText: "Enter Name",
        //                 hintStyle: TextStyle(color: Colors.black, fontSize: 18),
        //                 border: OutlineInputBorder(
        //                   borderSide: BorderSide(
        //                       width: 3, color: Colors.black54), //<-- SEE HERE
        //                   borderRadius: BorderRadius.circular(50.0),
        //                 ),
        //                 focusedBorder: OutlineInputBorder(
        //                   borderSide: BorderSide(
        //                       width: 3,
        //                       color: Color(0xffff6961)), //<-- SEE HERE
        //                   borderRadius: BorderRadius.circular(50.0),
        //                 ),
        //               ),
        //             )),
        //           ]),
        //
        //           SizedBox(
        //             height: 30,
        //           ),
        //           Text('Forgot Password?',
        //               textAlign: TextAlign.left,
        //               style: TextStyle(
        //                   color: Color.fromRGBO(0, 0, 0, 0.699999988079071),
        //                   fontFamily: 'IBM Plex Serif',
        //                   fontSize: 22,
        //                   letterSpacing:
        //                       0 /*percentages not used in flutter. defaulting to zero*/,
        //                   fontWeight: FontWeight.normal,
        //                   height: 1)),
        //           TextFormField(
        //             controller: enterEmail,
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 22,
        //               fontFamily: 'IBM Plex Serif',
        //             ),
        //             cursorColor: Colors.black,
        //             decoration: InputDecoration(
        //               filled: true,
        //               fillColor: Colors.white,
        //               hintText: "Enter Email",
        //               hintStyle: TextStyle(color: Colors.black, fontSize: 18),
        //               border: OutlineInputBorder(
        //                 borderSide: BorderSide(
        //                     width: 3, color: Colors.black54), //<-- SEE HERE
        //                 borderRadius: BorderRadius.circular(50.0),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 borderSide: BorderSide(
        //                     width: 3, color: Color(0xffff6961)), //<-- SEE HERE
        //                 borderRadius: BorderRadius.circular(50.0),
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 30,
        //           ),
        //           TextButton(
        //               child: Text('Reset Password', style: TextStyle(fontSize: 22)),
        //               style: ButtonStyle(
        //                 side: MaterialStateProperty.all<BorderSide>(
        //                     BorderSide(width: 1.5, color: Colors.black54)),
        //                 fixedSize: MaterialStateProperty.all<Size>(
        //                     Size.fromWidth(200.0)),
        //                 backgroundColor:
        //                     MaterialStateProperty.all<Color>(Color(0xffff6961)),
        //                 foregroundColor:
        //                     MaterialStateProperty.all<Color>(Colors.white),
        //                 overlayColor: MaterialStateProperty.resolveWith<Color?>(
        //                   (Set<MaterialState> states) {
        //                     if (states.contains(MaterialState.hovered))
        //                       return Colors.grey.withOpacity(0.04);
        //                     if (states.contains(MaterialState.focused) ||
        //                         states.contains(MaterialState.pressed))
        //                       return Colors.black54.withOpacity(0.12);
        //                     return null; // Defer to the widget's default.
        //                   },
        //                 ),
        //               ),
        //               onPressed: () async {
        //                 resetPassword();
        //
        //                 // Navigator.push(
        //                 //     context,
        //                 //      MaterialPageRoute(builder: (context) => ResetPasswordPage())
        //                 // );
        //               }),
        //               //  TextButton(
        //               // child: Text('Sign Out', style: TextStyle(fontSize: 22)),
        //               // style: ButtonStyle(
        //               //   side: MaterialStateProperty.all<BorderSide>(
        //               //       BorderSide(width: 1.5, color: Colors.black54)),
        //               //   fixedSize: MaterialStateProperty.all<Size>(
        //               //       Size.fromWidth(160.0)),
        //               //   backgroundColor:
        //               //       MaterialStateProperty.all<Color>(Color(0xffff6961)),
        //               //   foregroundColor:
        //               //       MaterialStateProperty.all<Color>(Colors.white),
        //               //   overlayColor: MaterialStateProperty.resolveWith<Color?>(
        //               //     (Set<MaterialState> states) {
        //               //       if (states.contains(MaterialState.hovered))
        //               //         return Colors.grey.withOpacity(0.04);
        //               //       if (states.contains(MaterialState.focused) ||
        //               //           states.contains(MaterialState.pressed))
        //               //         return Colors.black54.withOpacity(0.12);
        //               //       return null; // Defer to the widget's default.
        //               //     },
        //               //   ),
        //               // ),
        //               // onPressed: () {signOut();}),
        //           SizedBox(
        //             height: 50,
        //           ),
        //           Row(children: [
        //             Spacer(),
        //             ElevatedButton(
        //                 onPressed: () {signOut();},
        //                 style: ButtonStyle(
        //                   shape:
        //                       MaterialStateProperty.all<RoundedRectangleBorder>(
        //                           RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(18.0),
        //                               side: BorderSide(
        //                                   width: 1.5,
        //                                   color: Color(0xffff6961)))),
        //                   backgroundColor:
        //                       MaterialStateProperty.all<Color>(Colors.white),
        //                   foregroundColor: MaterialStateProperty.all<Color>(
        //                       Color(0xffff6961)),
        //                 ),
        //                 child: Row(
        //                   children: <Widget>[
        //                     Text(
        //                       "Log Out",
        //                       style: TextStyle(
        //                           color: Color(0xffff6961),
        //                           fontSize: 15,
        //                           fontFamily: 'IM FELL English SC'),
        //                     ),
        //                     SizedBox(
        //                       width: 5,
        //                     ),
        //                     Icon(
        //                       Icons.logout,
        //                       color: Color(0xffff6961),
        //                     ),
        //                   ],
        //                 ))
        //           ]),
        //           SizedBox(
        //             height: 30,
        //           ),
        //           Container(
        //               alignment: Alignment.topLeft,
        //               width: 400,
        //               height: 65,
        //               padding: EdgeInsets.only(
        //                   left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        //               decoration: BoxDecoration(
        //                 color: Color(0x33ff6961),
        //                 borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(10),
        //                   topRight: Radius.circular(10),
        //                   bottomLeft: Radius.circular(10),
        //                   bottomRight: Radius.circular(10),
        //                 ),
        //               ),
        //               child: Column(children: <Widget>[
        //                 Expanded(
        //                     child: Text("Contact Us",
        //                         style: TextStyle(
        //                             fontSize: 15, fontFamily: 'Iceland'))),
        //                 Divider(
        //                   thickness: 2,
        //                   color: Colors.black26,
        //                 ),
        //                 Expanded(
        //                     child: Row(children: <Widget>[
        //                   Icon(Icons.call, size: 20),
        //                   SizedBox(width: 5),
        //                   Text("+65 1234 5678"),
        //                   Spacer(),
        //                   Icon(Icons.email, size: 20),
        //                   SizedBox(
        //                     width: 5,
        //                   ),
        //                   Text("kitchenMaster@email.com"),
        //                 ]))
        //               ]))
        //         ],
        //       )),
        // ]))
        // //
        // // bottomNavigationBar: BottomNavigationBar(
        // //     backgroundColor: Color(0xffff6961),
        // //     items: const <BottomNavigationBarItem>[
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
