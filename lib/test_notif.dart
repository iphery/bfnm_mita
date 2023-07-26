import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mita/service/notification.dart';
import 'package:provider/provider.dart';

class TestNotif extends StatefulWidget {
  @override
  _TestNotifState createState() => _TestNotifState();
}

class _TestNotifState extends State<TestNotif> {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future instantNotification() async {
    var android = AndroidNotificationDetails(
        "id1", "abc", "description",
        playSound: true,
        sound: RawResourceAndroidNotificationSound('swiftly'),
        importance: Importance.high,
        priority: Priority.high

    );

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }


  @override
  void initState() {
    initialize();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: ElevatedButton(
                  child: Text('Tet'),
                  onPressed: (){
                    instantNotification();
                  },
                )

                /*
                Consumer<NotificationService>(
                  builder: (context, model, _) =>
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        ElevatedButton(
                            onPressed: () => model.instantNotification(),
                            child: Text('Instant Notification')),
                        ElevatedButton(
                            onPressed: () => model.imageNotification(),
                            child: Text('Image Notification')),
                        ElevatedButton(
                            onPressed: () => model.stylishNotification(),
                            child: Text('Media Notification')),
                        ElevatedButton(
                            onPressed: () => model.sheduledNotification(),
                            child: Text('Scheduled Notification')),
                        ElevatedButton(
                            onPressed: () => model.cancelNotification(),
                            child: Text('Cancel Notification')),
                      ]),
                )


                 */

            )));
  }
}