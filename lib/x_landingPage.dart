import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mita/api_service.dart';
import 'package:mita/dummyApi.dart';

import 'package:mita/mainScreen.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_addProfilePicture.dart';
import 'package:mita/x_loginScreen.dart';
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  ApiService service = ApiService();

  DioService dioService = DioService();

  StreamSubscription internetconnection;
  bool isoffline = false;
  var url = Uri.parse(
      'https://mita.balifoam.com/mobile/flutter/check_profile_picture.php');

  @override
  void initState() {
    ///check internet
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        print('offline');
        setState(() {
          isoffline = true;
        });
      } else {
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isoffline) {
      return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;

            if (user == null) {
              return LoginScreen();
            }
            return FutureBuilder<dynamic>(
              future: http.post(url, body: {
                'password': 'BFNMAdmin2015',
                'id_user': user.uid,
              }), // dioService.checkProfilePicture(user.uid),
              builder: (context, snapshot) {
                //print(snapshot.data['imageUrl']);

                if (snapshot.hasData) {
                  //var data = snapshot.data['imageUrl'];
                  var b = snapshot.data.body;

                  if (snapshot.data.statusCode == 200) {
                    if (snapshot.data.body != "0") {
                      return MainScreen();
                    } else {
                      return AddProfilePicture();
                    }
                  } else {
                    EasyLoading.dismiss();
                    return Scaffold(
                      body: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.red,
                              size: 60,
                            ),
                            Text('Failed connecting to Server'),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll(
                                      Colors.blueGrey)),
                              child: Text('REFRESH'),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  EasyLoading.show(maskType: EasyLoadingMaskType.custom);
                  return Scaffold(
                    body: Container(),
                  );
                }
              },
            );
          }
          return Container(
            child: Text('disini'),
          );
        },
      );
    } else {
      EasyLoading.dismiss();
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.00),
                margin: EdgeInsets.only(bottom: 10.00),
                color: Colors.red,
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(right: 6.00),
                    child: Icon(Icons.info, color: Colors.white),
                  ), // icon for error message

                  Text('No Internet Connection Available',
                      style: TextStyle(color: Colors.white)),
                  //show error message text
                ]),
              ),
              Expanded(
                  child: Center(
                      child: Icon(
                Icons.cloud_off,
                size: 60,
                color: Colors.grey[400],
              )))
            ],
          ),
        ),
      );
    }
  }
}

/*
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser;



  Future<void> _signOut() async {

    await FirebaseAuth.instance.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.disconnect();

  }

  Future<void> getUserDoc() {

    DocumentReference ref = FirebaseFirestore.instance.collection('_user').doc(user.uid);
    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'name' : user.displayName,
      'photoUrl' : user.photoURL,
      'lastSignIn' : user.metadata.lastSignInTime
    });
  }

  Future checkUser() async{
    var dbUid = await FirebaseFirestore.instance.collection('_user').doc(user.uid).get();
    if(dbUid.exists){
      ///update last login
      DocumentReference ref = FirebaseFirestore.instance.collection('_user').doc(user.uid);
      return ref.update({'lastSignIn': user.metadata.lastSignInTime});

    }
    if(!dbUid.exists){

      getUserDoc();

    }

  }

  @override
  void initState() {
    checkUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          Text(user.email),
          //Text(id.displayName),
          Text(user.uid),
          if(user.photoURL != null)
            CircleAvatar(
              child: Image(
                image: NetworkImage(user.photoURL),
              ),

            ),
          SizedBox(height: 100,),
          RaisedButton(
            onPressed: (){

            },
            child: Text('Save data'),
          )

        ],
      ),
    );
  }



}


 */


