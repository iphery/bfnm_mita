import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class TestDummy extends StatefulWidget {

  @override
  _TestDummyState createState() => _TestDummyState();
}

class _TestDummyState extends State<TestDummy> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;
  double progress = 0;

  Future getUserName()async{
    final provider = Provider.of<AssetProvider>(context, listen: false);
    var userName = await dioService.getUserLevel(user.uid);

    provider.getUserName(userName['Name']);

  }

  @override
  void initState() {
    super.initState();
    getUserName();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    //EasyLoading.show(status: 'Please wait..');
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Request',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black,)),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'http://mita.balifoam.com/form8_ac/index2.php?id_req=${user.uid}&req=${provider.userName}',
            //initialUrl: 'http://mita.balifoam.com/mobile/test_image.php',

            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              setState(() {
                this.progress = progress / 100;

              });
              //print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                  name: 'response',
                  onMessageReceived: (JavascriptMessage message) {

                    String msg = message.message;
                    if(msg == 'submitted') {
                      Navigator.pop(context, 'completed');
                    }

                    //print(msg);
                    //ScaffoldMessenger.of(context)
                    //    .showSnackBar(SnackBar(content: Text(msg)));
                  }),
            }.toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                //print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              //print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {

              //print('Page started loading: $url');
            },
            onPageFinished: (String url) {

              //print('Page finished loading: $url');
              //EasyLoading.dismiss();
            },
            gestureNavigationEnabled: false,
            geolocationEnabled: false,//support geolocation or not
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }


}
