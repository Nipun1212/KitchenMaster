import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
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
  TimeOfDay time = TimeOfDay.now();
  TextEditingController nameController = TextEditingController();
  String id = '';
  int intId = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  DynamicWidget(TextEditingController n, String value) {
    nameController = n;
    name = n.text;
    frequency = value;
    time = TimeOfDay.now();
    id = UniqueKey().toString();
    intId = 0;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  // // Generate a unique integer value for a notification
  // int generateUniqueId(String uniqueId) {
  //   var now = DateTime.now();
  //   var formatter = DateFormat('yyyyMMddHHmmss');
  //   var formattedDate = formatter.format(now);
  //   return int.parse(formattedDate + uniqueId.hashCode.toString());
  // }

  void deleteNotifications() async {
    if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(id);
    }
    else if (Platform.isIOS){
      // UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id]);
      await flutterLocalNotificationsPlugin.cancel(intId); // TODO
      }

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



  void scheduleNotification(String id, String name, String frequency) async {
    // await widget.flutterLocalNotificationsPlugin.cancelAll();
    log("Start schedule");
    deleteNotifications();

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
    log("Setting channel");
    var channel = AndroidNotificationChannel(
      id , name,
      description: frequency + ' reminder for ' + name,
      importance: Importance.high,

    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    log("Setting platform details");
    var androidDetails = AndroidNotificationDetails(
      id , name,
      channelDescription: frequency + ' reminder for ' + name,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      playSound: true,
      enableVibration: true,
      // timeoutAfter: 6000,
      // ongoing: true
    );
    var iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      badgeNumber: 1,
      threadIdentifier: id,
    );

    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    log("Scheduling the notification...");
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      intId, // notification id
      'Grocery List Reminder', // notification title
      'Restock ' + name + '!', // notification body
      _nextInstanceOfTimeOfDay(freqInDays, time.hour, time.minute), // scheduled date and time
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    log("showSchedule " + id + " " + name + " " + frequency + " " + time.toString());
  }

  tz.TZDateTime _nextInstanceOfTimeOfDay(int days, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final timezone = tz.getLocation('Asia/Singapore');
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        timezone,
        now.year,
        now.month,
        now.day,
        // now.hour, now.minute, now.second
        hour, minute
      // 10,3
    );
    scheduledDate = scheduledDate.add(Duration(seconds: 1));
    log("SingaporeTime: " + scheduledDate.toString());
   // Convert the Singapore time to UTC
    scheduledDate = scheduledDate.toUtc();

    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: days));
    }
    log("scheduledDate: " + scheduledDate.toString());
    return scheduledDate;
  }

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {

  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    AndroidInitializationSettings('@drawable/logo');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS
    );

    await widget.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // onSelectNotification: (String? payload) async {}
        );
  }
  void setTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: widget.time,
      context: context,
    );
    if (selectedTime != null) {
      setState(() {
        widget.time = selectedTime;
        widget.scheduleNotification(widget.id, widget.name, widget.frequency);
      });
    }
    //update firebase
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts').doc(widget.id);

    // Update the data for this document
    alertRef.update({
      'time': widget.time.format(context),
    }).then((value) => print('Alert Time updated successfully'))
        .catchError((error) => print('Error updating alert time: $error'));

  }

  @override
  void initState() {
    super.initState();
    // tz.initializeTimeZones();
    _initializeNotifications();
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
                          widget.scheduleNotification(
                          widget.id,
                          widget.name,
                          widget.frequency,
                          );
                        });}
                    ),
                  ),
                SizedBox(width: 5),

                DropdownButtonHideUnderline(
                child:DropdownButton<String>(
                    underline: null,
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
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.frequency = newValue!;
                        widget.scheduleNotification(
                          widget.id,
                          widget.name,
                          widget.frequency,
                        );
                      });

                    },
                  ),),
                  IconButton(
                      icon: Icon(Icons.access_time_filled_sharp),
                      onPressed:  () => setTime(context)
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
    tz.initializeTimeZones();
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

    List<PendingNotificationRequest> Notifications =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    setState(() {
      snapshot.docs.forEach((document) {
        // Extract the data from the document
        final data = document.data();
        final id = document.id;
        String? timeS = data['time'];
        TimeOfDay time;
        if (timeS == null) time = TimeOfDay.now();
        else {
          DateFormat formatter = DateFormat("h:mm a");
          DateTime dateTime = formatter.parse(timeS);
          time = TimeOfDay.fromDateTime(dateTime);
        }
        int? intId = data['intID'];
        if (intId == null) intId = 0; // TODO check
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
        oldAlert.intId = intId;
        oldAlert.time = time;
        listCards.add(oldAlert);

        //if instance not found in device, add
        if (Platform.isAndroid) {
          if (channels != null) {
            bool channelExists = channels.any((channel) => channel.id == id);
            debugPrint(id + " " + channelExists.toString());
            if (channelExists) return;
          }
        }
        if (Platform.isIOS){
          if (Notifications != null) {
            bool notificationExists = Notifications.any((
                notification) => notification.id == intId);
            debugPrint(id + " " + notificationExists.toString());
            if (notificationExists) return;
          }
        }
        oldAlert.scheduleNotification(id, name, frequency);
      });
    });
  }

  // Generate a unique integer value for a notification
  int generateUniqueId(String uniqueId) {
    var now = DateTime.now();
    var formatter = DateFormat('yyMMddHHmmss');
    var formattedDate = formatter.format(now);
    return int.parse(formattedDate);
    // return int.parse(formattedDate + uniqueId.hashCode.toString());
  }
  int generateTimestampId() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  Future<void> addDynamic(TextEditingController n, String value) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alertsRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('alerts');
    DocumentReference newAlertRef = await alertsRef.add({
      'name': '',
      'time': TimeOfDay.now().format(context),
      'frequency': 'None'
    });
    // final newAlertId = generateUniqueId(newAlertRef.id);
    final newAlertId = newAlertRef.id.hashCode;
    await newAlertRef.update({'intId': newAlertId});

    setState(() {
      var dynamicWidget = DynamicWidget(n, value);
      controllers.add(n);
      dynamicWidget.id = newAlertRef.id;
      dynamicWidget.intId = newAlertId;
      listCards.add(dynamicWidget);
      log("added dynamic");
    });


  }

  // void resetDynamic() {
  //   setState(() {
  //     // if (listCards.isEmpty){
  //     //   //show error message
  //     // }
  //     controllers.removeRange(0, controllers.length);
  //     listCards.removeRange(0, listCards.length);
  //   });
  // }
  //
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
            appBar: AppBar(
              backgroundColor: Color(0xffff6961), //Colors.red,
              title: const Text(
                "Alerts",
                style: TextStyle(color: Colors.white),
              ),
              // leading: const BackButton(
              //   color: Colors.white,
              // ),
              // centerTitle: true,
            ),
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
