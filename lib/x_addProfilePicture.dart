import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:mita/mainScreen.dart';
import 'package:mita/x_landingPage.dart';

import 'camera/front_camera.dart';

class AddProfilePicture extends StatefulWidget {
  static const route = '/addprofilepicture';

  @override
  _AddProfilePictureState createState() => _AddProfilePictureState();
}

class _AddProfilePictureState extends State<AddProfilePicture> {
  String path;
  bool isLoading = false;
  User user = FirebaseAuth.instance.currentUser;
  ApiService service = ApiService();

  final textEditing = TextEditingController();
  bool isError = false;
  final focus = FocusNode();
  bool showClearIcon = false;
  bool isKeyBShow = false;

  @override
  void initState() {
    EasyLoading.dismiss();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      //print(visible);
      if (visible) {
        //setState(() {
        isKeyBShow = true;
        //});
      } else {
        //setState(() {
        isKeyBShow = false;

        //});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Add Profile Picture',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          border: Border.all(color: Colors.white, width: 4),
                          image: DecorationImage(
                              image: path != null
                                  ? FileImage(File(path))
                                  : AssetImage('assets/images/avatar.png'),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileCameraScreen()));

                            if (res != null) {
                              print(res);
                              setState(() {
                                path = res; //res[0].thumbPath;
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.grey[500]),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(child: Text('Open Camera')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 12, right: 12),
                child: TextField(
                  controller: textEditing,
                  focusNode: focus,
                  onChanged: (val) {
                    if (textEditing.text.isNotEmpty) {
                      setState(() {
                        showClearIcon = true;
                        isError = false;
                      });
                    } else {
                      setState(() {
                        showClearIcon = false;
                      });
                    }
                  },
                  minLines: 1,
                  decoration: isError
                      ? InputDecoration(
                          hintText: 'Masukkan nama...',
                          //border: InputBorder.none,

                          errorText: 'Kolom tidak boleh kosong',
                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink())
                      : InputDecoration(
                          hintText: 'Masukkan nama...',
                          //border: InputBorder.none,

                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: isKeyBShow
            ? SizedBox.shrink()
            : Container(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      focus.unfocus();
                      if (path != null) {
                        if (textEditing.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          var res = await service.saveProfilePicture(
                              path: path,
                              idUser: user.uid,
                              name: textEditing.text);

                          if (res == 'OK') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LandingPage()));

                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                                'Upload foto gagal, cobalah beberapa saat lagi.');
                          }
                        } else {
                          setState(() {
                            isError = true;
                          });
                        }
                      } else {
                        showDialog('Photo profile tidak boleh kosong.');
                      }

                      //Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: path != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      child: Center(
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      child: CupertinoActivityIndicator(
                                        radius: 11,
                                      )),
                                  SizedBox(width: 10),
                                  Text(
                                    "Please wait...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
              ));
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

class Label extends StatelessWidget {
  final String name;
  final String title;
  final IconData icon;

  Label({this.name, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
