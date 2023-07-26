import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:mita/camera/back_camera.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class AddPictureScreen extends StatefulWidget {
  @override
  _AddPictureScreenState createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  final textEditing = TextEditingController();
  String path;
  bool showClearIcon = false;
  List pathList = [];
  User user = FirebaseAuth.instance.currentUser;
  ApiService service = ApiService();
  DioService dioService = DioService();
  bool isError = false;
  File fileSubmit;
  int countPick = 0;
  final focus = FocusNode();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        title: Text(
          'Add Picture',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        List<Media> res = await ImagesPicker.pick(
                          count: 5,
                          pickType: PickType.all,
                          language: Language.System,

                          // maxSize: 500,
                          cropOpt: CropOption(
                            aspectRatio: CropAspectRatio.wh16x9,
                          ),
                        );
                        if (res != null) {
                          //print(res.map((e) => e.path).toList());

                          for (int i = 0; i < res.length; i++) {
                            //print(res[i].thumbPath);
                            setState(() {
                              pathList.add(res[i].thumbPath);
                            });
                            showClearIcon = true;
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.attach_file_rounded,
                            size: 15,
                          ),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BackCameraScreen()));

                        if (res != null) {
                          print(res);
                          setState(() {
                            pathList.add(res);
                          });
                          showClearIcon = true;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 15,
                          ),
                          Text('Ambil foto'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          pathList.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pathList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                showDialogRemove(index);
                              },
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(File(pathList[index])),
                                        fit: BoxFit.cover),
                                    border:
                                        Border.all(color: Colors.grey[300])),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            elevation: 2,
            color: showClearIcon ? Theme.of(context).primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (pathList.length > 0) {
                        setState(() {
                          isLoading = true;
                        });

                        var res = await service.addCaseImage(
                            pathList: pathList,
                            idCase: provider.selectedIdCase,
                            idUser: user.uid);
                        //res isinya id case

                        if (res == 'OK') {
                          EasyLoading.showSuccess(
                                  'Yey. Gambar berhasil ditambahkan.',
                                  duration: Duration(seconds: 2))
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context, 'submitted');
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showDialogError();
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
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
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialogRemove(index) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Message'),
            content: Text('Hapus foto ?'),
            actions: [
              TextButton(
                child: Text(
                  'Batal',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'Ya',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  pathList.removeAt(index);
                  if (pathList.length > 0) {
                    setState(() {
                      showClearIcon = true;
                    });
                  } else {
                    setState(() {
                      showClearIcon = false;
                    });
                  }
                  //setState(() {});

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showDialogError() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Message'),
            content: Text('Update gagal. Cobalah beberapa saat lagi.'),
            actions: [
              TextButton(
                child: Text(
                  'Ya',
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
