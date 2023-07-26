import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgressScreen extends StatefulWidget {

  final String tahun;
  final String bulan;
  ProgressScreen({this.tahun, this.bulan});

  @override
  _ProgressScreenState createState() => new _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;

  double progress = 0;
  final urlController = TextEditingController();

  Future getUserName()async{
    final provider = Provider.of<AssetProvider>(context, listen: false);
    var userName = await dioService.getUserLevel(user.uid);

    provider.getUserName(userName['Name']);

  }

  @override
  void initState() {
    super.initState();
    getUserName();


  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Maintenance',
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
              initialUrl: 'https://mita.balifoam.com/form8/indexPM.php?y=${widget.tahun}&m=${widget.bulan}',

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
                        Navigator.pop(context, 'submitted');
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
                ? Center(
              child: JumpingDotsProgressIndicator(
                  fontSize: 50.0,
                  color: Colors.orange
              ),
            )//LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}
