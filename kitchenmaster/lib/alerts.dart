import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'profile.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  DynamicWidget(TextEditingController n, String value) {
    nameController = n;
    name = n.text;
    frequency = value;
    id = UniqueKey().toString();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  // @override
  // void initState() {
  //   super.initState();
  // }


  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid //iOS: initializationSettingsIOS
    );

    await widget.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {});
  }

  // Future<void> _sendFCMTokenToServer() async {
  //   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   String? fcmToken = await firebaseMessaging.getToken();
  //   // TODO: Send the FCM token to your server
  // }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();//local notifications
    // _sendFCMTokenToServer(); //push notification

  }

  void scheduleNotification(String id, String name, String frequency) async {
    await widget.flutterLocalNotificationsPlugin.cancelAll();

    if (name == '' || frequency == 'none') return;
    int freqInDays = 0;
    switch(frequency){
      case "daily": freqInDays = 1;
      break;
      case "weekly": freqInDays = 7;
      break;
      case "biweekly": freqInDays = 14;
      break;
      case "monthly": freqInDays = 30;
      break;
    }

    var androidDetails = AndroidNotificationDetails(
        id , name, frequency + ' reminder for ' + name,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
        playSound: true,
        enableVibration: true,
        timeoutAfter: 5000
    );
    //var iosDetails = IOSNotificationDetails();
    var platformDetails =
    NotificationDetails(android: androidDetails, //iOS: iosDetails
    );

    // Schedule the notification
    await widget.flutterLocalNotificationsPlugin.zonedSchedule(
      0, // notification id
      'Grocery List Reminder', // notification title
      'Restock ' + name + '!', // notification body
      _nextInstanceOfTimeOfDay(freqInDays), // scheduled date and time
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    log("showSchedule " + id+ name + frequency);
  }

  TZDateTime _nextInstanceOfTimeOfDay(int days) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour, now.minute, now.second
      // 16,
      // // hour of day
      // 15,
      // // minute
      // 0, // second
    );
    scheduledDate = scheduledDate.add(Duration(seconds: 1));
    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: days));
    }

    return scheduledDate;
  }

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
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.name = newValue!;
                          scheduleNotification(
                          widget.id,
                          widget.name,
                          widget.frequency.toLowerCase(),
                          );
                        });}
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
                        scheduleNotification(
                          widget.id,
                          widget.name,
                          widget.frequency.toLowerCase(),
                        );
                      });

                    },
                  ),
                ]))));
  }
}

class _AlertsPageState extends State<AlertsPage> {



  List<DynamicWidget> listCards = [];
  List<TextEditingController> controllers = [];

  void addDynamic(TextEditingController n, String value) {
    setState(() {
      controllers.add(n);
      var dynamicWidget = DynamicWidget(n, value);
      listCards.add(dynamicWidget);
      log("added dynamic");
      // scheduleNotification(dynamicWidget.id, dynamicWidget.name,
      //     dynamicWidget.frequency.toLowerCase());
    });
  }

  // void editDynamic(int index, TextEditingController n, String value) {
  //   setState(() {
  //     var dynamicWidget = listCards[index];
  //     controllers[index] = n;
  //     dynamicWidget.nameController = n;
  //     dynamicWidget.name = n.text;
  //     dynamicWidget.frequency = value;
  //     scheduleNotification(dynamicWidget.id, dynamicWidget.name,
  //         dynamicWidget.frequency.toLowerCase());
  //   });
  // }

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
