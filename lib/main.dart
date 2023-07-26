import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mita/custom_animation.dart';
import 'package:mita/mainScreen.dart';
import 'package:mita/service/notification.dart';
import 'package:mita/test.dart';
import 'package:mita/test_dummy.dart';
import 'package:mita/test_notif.dart';
import 'package:mita/x_addProfilePicture.dart';
import 'package:mita/x_assetDetailScreen.dart';
import 'package:mita/x_assetListScreen.dart';
import 'package:mita/x_calcTank.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_errorScreen.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_landingPage.dart';
import 'package:mita/x_maintenanceScreen.dart';
import 'package:mita/x_profileScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_requestFormScreen.dart';
import 'package:mita/x_userApproveScreen.dart';
import 'package:provider/provider.dart';

import 'checklist/general_checklist.dart';



//additional for firebase messaging


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
  //print(message.data['case_id']);

}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(

  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('bubble'),




);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

//-------



void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //additional for firebase messaging

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);



  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );



  //==============


  runApp(MyApp(),);
  configLoading();



}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetProvider()),

      ],
      child: MaterialApp(
        title: 'MITA',
        theme: ThemeData(

          primarySwatch: Colors.blue,
          fontFamily: 'SF',
        ),
        //home: AssetListScreen(),
        builder: EasyLoading.init(),
        routes: {
          '/': (context) => LandingPage(),
          MainScreen.route : (context) => MainScreen(),
          AssetListScreen.route : (context) => AssetListScreen(),
          AssetDetailScreen.route : (context) => AssetDetailScreen(),
          CaseDetailScreen.route : (context) => CaseDetailScreen(),
          RequestFormScreen.route : (context) => RequestFormScreen(),
          ProfileScreen.route : (context) => ProfileScreen(),
          ImagePreviewScreen.route : (context) => ImagePreviewScreen(),
          MaintenanceScreen.route: (context)=> MaintenanceScreen(),
          AddProfilePicture.route: (context)=> AddProfilePicture(),

        },
      ),
    );
  }
}

