import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'profile.dart';
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

  void deleteNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(id);
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  void deleteNotificationFirebase() async {
    //delete in firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts').doc(id);
    alertRef.delete().then((value) {
      debugPrint('Object deleted successfully');
    }).catchError((error) {
      debugPrint('Failed to delete object: $error');
    });
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
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    AndroidInitializationSettings('@drawable/logo');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS
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
    // await widget.flutterLocalNotificationsPlugin.cancelAll();
    widget.deleteNotifications();

    //update firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts').doc(id);

    // Update the data for this document
    alertRef.update({
      'name': name,
      'frequency': frequency,
    })
        .then((value) => print('Alert updated successfully'))
        .catchError((error) => print('Error updating alert: $error'));

    if (name == '' || frequency == 'None') return;
    int freqInDays = 0;
    switch(frequency){
      case "Daily": freqInDays = 1;
      break;
      case "Weekly": freqInDays = 7;
      break;
      case "Biweekly": freqInDays = 14;
      break;
      case "Monthly": freqInDays = 30;
      break;
    }

    var androidDetails = AndroidNotificationDetails(
        id , name, frequency + ' reminder for ' + name,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
        playSound: true,
        enableVibration: true,
        // timeoutAfter: 6000,
        // ongoing: true
    );
    var iosDetails = IOSNotificationDetails(
      presentAlert: true,
      presentSound: true,
      badgeNumber: 1,
    );

    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // var platformDetails =
    // NotificationDetails(android: androidDetails, //iOS: iosDetails
    // );

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
                          widget.frequency,
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
                          widget.frequency,
                        );
                      });

                    },
                  ),
                ]))));
  }
}

class _AlertsPageState extends State<AlertsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<DynamicWidget> listCards = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts(); // TODO
    setState(() {});
  }

  Future<void> _loadAlerts() async {
    debugPrint("start loadAlerts");
    // get all notifications in firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertsRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts');
    final snapshot = await alertsRef.get();

    //get all notifications on device
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    List<AndroidNotificationChannel>? channels =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.getNotificationChannels();
    //
    setState(() {
      snapshot.docs.forEach((document) {
        // Extract the data from the document
        final data = document.data();
        final id = document.id;
        final name = data['name'];
        final frequency = data['frequency'];

        // delete those with empty name in database
        if (name == "") {
          alertsRef.doc(id).delete().then((value) {
            debugPrint('Empty object deleted successfully');
          }).catchError((error) {
            debugPrint('Failed to delete empty object: $error');
          });
          return;
        }
        debugPrint((id ?? "") + " " + (name ?? "") + " " + (frequency ?? ""));
        //add the widgets
        TextEditingController n = new TextEditingController(text: name);
        controllers.add(n);
        DynamicWidget oldAlert = DynamicWidget(n, frequency);
        oldAlert.id = id;
        listCards.add(oldAlert);

        //if instance not found in device, add
        // if (channels != null) {
        //   bool channelExists = channels.any((channel) => channel.id == id);
        //   if (channelExists) return;
        // }
        // oldAlert.



      });
    });
  }

  Future<void> addDynamic(TextEditingController n, String value) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertsRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts');
    DocumentReference newAlertRef = await alertsRef.add({
      'name': '',
      'frequency': 'None'
    });
    setState(() {
      var dynamicWidget = DynamicWidget(n, value);
      controllers.add(n);
      dynamicWidget.id = newAlertRef.id;
      listCards.add(dynamicWidget);
      log("added dynamic");
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
                              listCards[index].deleteNotifications();
                              listCards[index].deleteNotificationFirebase();
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

}
