import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:mita/camera/back_camera.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

import 'expandedDropdown.dart';

class RequestUtilityScreen extends StatefulWidget {
  final String idAsset;
  final String description;
  final String manufacture;
  final String model;

  const RequestUtilityScreen(
      {this.idAsset, this.description, this.manufacture, this.model});

  @override
  _RequestUtilityScreenState createState() => _RequestUtilityScreenState();
}

class _RequestUtilityScreenState extends State<RequestUtilityScreen> {
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
  bool catError = false;
  bool locError = false;
  bool picError = false;

  bool isLoading = false;
  bool isKeyBShow = false;

  List<String> listLocation = [];
  String locValue = 'Open to Select';

  List<String> listCategory = [
    'Telepon',
    'Lampu / Fan',
    'Instalasi / Panel',
    'Pompa',
    'Lainnya'
  ];
  String catValue = 'Open to Select';

  void getUserLocation() async {
    var locs = await dioService.getUserLoc();
    //print(loc[0]['dataDetail'][0]);
    //listLocation = [];

    for (var loc in locs) {
      setState(() {
        listLocation.add(loc);
      });
    }

    //print(listLocation[3]);
  }

  @override
  void initState() {
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
    getUserLocation();
    super.initState();
  }

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
          'New Request',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[400],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Please complete data'),
                  )),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: CustomDropdown<int>(
                child: Text(
                  catValue,
                  style: TextStyle(color: Colors.black),
                ),
                title: 'Jenis Permasalahan',
                icon: Icon(Icons.keyboard_arrow_down),
                onChange: (int value, int index) {
                  setState(() {
                    catValue = listCategory[index];
                  });
                  if (catValue != 'Open to Select') {
                    setState(() {
                      catError = false;
                    });
                  }
                },
                dropdownButtonStyle: DropdownButtonStyle(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  elevation: 1,
                  backgroundColor: catError ? Colors.red.shade50 : Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 6,
                  padding: EdgeInsets.all(5),
                ),
                items: listCategory
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<int>(
                        value: item.key + 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.value,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            ///category
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: CustomDropdown<int>(
                child: Text(
                  locValue,
                  style: TextStyle(color: Colors.black),
                ),
                title: 'Lokasi',
                icon: Icon(Icons.keyboard_arrow_down),
                onChange: (int value, int index) {
                  setState(() {
                    locValue = listLocation[index];
                  });
                  if (locValue != 'Open to Select') {
                    setState(() {
                      locError = false;
                    });
                  }
                },
                dropdownButtonStyle: DropdownButtonStyle(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  elevation: 1,
                  backgroundColor: locError ? Colors.red.shade50 : Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 6,
                  padding: EdgeInsets.all(5),
                ),
                items: listLocation
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<int>(
                        value: item.key + 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.value,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: 'Jelaskan masalahmu...',
                        border: InputBorder.none,
                        suffixIcon: showClearIcon
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                iconSize: 20,
                                onPressed: () {
                                  textEditing.clear();
                                  setState(() {
                                    showClearIcon = false;
                                    isError = true;
                                  });
                                },
                              )
                            : SizedBox.shrink()),
                  ),
                ),
              ),
            ),
            isError
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Kolom tidak boleh kosong.',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),

            Divider(color: Colors.blueGrey),
            //Text('Take Picture', style:TextStyle(fontWeight:FontWeight.bold)),
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
                          focus.unfocus();
                          List<Media> res = await ImagesPicker.pick(
                            count: 2,
                            pickType: PickType.all,
                            language: Language.System,
                            quality: 0.8,

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
                                picError = false;
                              });
                            }

                            /*
                            setState(() {
                              path = res[0].thumbPath;
                            });

                             */
                            // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
                            // print(status);
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
                          focus.unfocus();
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BackCameraScreen()));

                          if (res != null) {
                            setState(() {
                              pathList.add(res);
                              picError = false;
                            });
                          }
                          /*
                          List<Media> res = await ImagesPicker.openCamera(
                            pickType: PickType.image,
                            quality: 0.5,
                            // cropOpt: CropOption(
                            //   aspectRatio: CropAspectRatio.wh16x9,
                            // ),
                            // maxTime: 60,
                          );
                          if (res != null) {

                            setState(() {
                              pathList.add(res[0].thumbPath);
                            });
                            /*
                            setState(() {
                              path = res[0].thumbPath;

                              print(path);
                            });

                             */
                          }

                           */
                          /*
                          var img = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraApp()));
                          if(img != null){
                            setState(() {
                              path = img;
                              pathList.add(path);
                            });
                          }

                           */
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 15,
                            ),
                            Text('Camera'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            picError
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Harus ada foto.',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),

            pathList.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.blue.shade50,
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
                                          image:
                                              FileImage(File(pathList[index])),
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
      ),
      bottomSheet: isKeyBShow
          ? SizedBox.shrink()
          : AnimatedContainer(
              duration: Duration(milliseconds: 1500),
              height: 80,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Material(
                  elevation: 2,
                  color:
                      !locError && !catError && !isError && pathList.length > 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            focus.unfocus();

                            setState(() {
                              isLoading = true;
                            });

                            if (catValue == 'Open to Select') {
                              setState(() {
                                catError = true;
                              });
                            } else if (locValue == 'Open to Select') {
                              setState(() {
                                locError = true;
                              });
                            } else if (textEditing.text.isEmpty) {
                              setState(() {
                                isError = true;
                              });
                            } else if (pathList.length == 0) {
                              setState(() {
                                picError = true;
                              });
                            } else {
                              ///process
                              var res = await service.getNewRequestOtherData(
                                  pathList: pathList,
                                  idUser: user.uid,
                                  problem: textEditing.text,
                                  type: catValue,
                                  location: locValue);
                              print(res);
                              if (res != '') {
                                EasyLoading.showSuccess('Submitted',
                                        duration: Duration(seconds: 2))
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context, res);
                                  EasyLoading.dismiss();
                                });
                              }
                            }
                            /*

                      if(textEditing.text.isEmpty){
                        setState(() {
                          isError = true;
                        });
                      } else {
                        setState(() {
                          isError = false;
                        });



                        //service.submitImageCase(filename: path, idAsset: provider.asset.id_asset ,idUser: user.uid);


                        //EasyLoading.show(status: 'Please wait..', maskType: EasyLoadingMaskType.custom);

                        setState(() {
                          isLoading = true;
                        });


                        var res = await service.getNewRequestData(pathList: pathList, idAsset: widget.idAsset, idUser: user.uid, problem: textEditing.text);
                        //res isinya id case


                        if(res != ''){

                          EasyLoading.showSuccess('Submitted',duration: Duration(seconds: 2)).then((value){
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context, res);
                            EasyLoading.dismiss();
                          });

                        }








                      }

                       */
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
                  setState(() {});

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
