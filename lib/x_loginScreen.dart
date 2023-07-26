import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mita/api_service.dart';

import 'package:mita/mainScreen.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_addProfilePicture.dart';
import 'package:mita/x_landingPage.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/loginscreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode focusPass = FocusNode();

  ApiService service = ApiService();
  DioService dioService = DioService();

/*
  ///---video param
  VideoPlayerController _controller;
  bool _visible = false;
  ///---


 */

/*
  ///----for video setting only
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    _controller = VideoPlayerController.asset("assets/images/intro.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });






  }



  @override
  void dispose() {
    super.dispose();

    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }




  }



 */

/*
  getVideoBackground() {

    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );


  }

 */

  ///---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ///video
          //getVideoBackground(),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo2.png'))),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //---------Login with email
                Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 22,
                              width: 22,
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 22,
                              width: 22,
                              child: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: TextField(
                          controller: passwordController,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          focusNode: focusPass,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                InkWell(
                  onTap: () {
                    focusPass.unfocus();
                    EasyLoading.show();
                    _signInWithEmailAndPassword(
                        emailController.text, passwordController.text);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.lightBlue),
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(email, password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      EasyLoading.dismiss();

      if (user.email != null) {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
        //Navigator.push(context, MaterialPageRoute(builder: (context) =>LandingPagePicture()));
/*
        final provider = Provider.of<AssetProvider>(context, listen: false);
        await service.checkProfilePicture(user.uid).then((value)async{
          provider.getPictureChecked(value);

          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));

        } );

 */
        //Future(() {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
        //});
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      print(e.message);
      if (e.code != null) {
        showDialog(e.message);
      }
    }
  }

  showDialog(e) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text(e),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
