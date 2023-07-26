import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/api_service.dart';
import 'package:mita/camera/back_camera_asset.dart';
import 'package:mita/camera/back_camera_profile.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_editUserScreen.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_linkedScreen.dart';
import 'package:mita/x_maintenanceScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_requestFormScreen.dart';
import 'package:mita/x_searchScreenDetail.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'checklist/checklist_pemanasan_genset.dart';

class AssetDetailScreen extends StatefulWidget {
  static const route = '/assetdetailscreen';

  @override
  _AssetDetailScreenState createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  ScrollController _controller;
  bool _showAppbar = false;

  ApiService service = ApiService();
  DioService dioService = DioService();

  User user = FirebaseAuth.instance.currentUser;
  var textFieldSmallController = TextEditingController();
  bool textFieldSmallIconShow = false;

  String currentKm = '0';

  ///for dummy

  String keyword = '';
  String dummy = 'BFNMA0401';

  bool isUnderMaintenance;
  String path;
  String pathAsset;
  String pathUser;

  StreamSubscription internetconnection;
  bool isoffline = false;

  double editHeight = 0;
  var textField1 = TextEditingController();
  bool textIcon1 = false;
  FocusNode focusText1 = FocusNode();

  var textField2 = TextEditingController();
  bool textIcon2 = false;
  FocusNode focusText2 = FocusNode();

  var textField3 = TextEditingController();
  bool textIcon3 = false;
  FocusNode focusText3 = FocusNode();

  var textField4 = TextEditingController();
  bool textIcon4 = false;
  FocusNode focusText4 = FocusNode();
  bool textField4Error = false;

  var textField5 = TextEditingController();
  bool textIcon5 = false;
  FocusNode focusText5 = FocusNode();
  bool textField5Error = false;

  String dateExpired = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool isSimpan = false;
  bool isSimpan2 = false;
  bool validSimpan2 = false;

  double editInsuranceHeight = 0;
  double editAparHeight = 0;

  @override
  void initState() {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    //provider.loadCaseList(provider.asset.id_asset, keyword);

    ///check internet
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
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
  void dispose() {
    internetconnection.cancel();
    super.dispose();
  }

  _scrollListener() {
    //print(_controller.position.pixels);
    if (_controller.position.pixels >= 182) {
      setState(() {
        _showAppbar = true;
      });
    } else {
      setState(() {
        _showAppbar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      body: !isoffline
          ? Stack(
              children: [
                FutureBuilder(
                    future: dioService.getAssetDetail(provider.selectedIdAsset),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data['data'][0]['dataDetail'];

                        if (snapshot.data['data'][3]['exist'] == 0) {}
                        //print(data['Type']);
                        //print(snapshot.data['data']);
                        return SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (data['Image'] != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImagePreviewScreen(
                                                      imageUrl:
                                                          'http://mita.balifoam.com/mobile/flutter/image_asset/${data['Image']}',
                                                    )));
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: data['Image'] != null
                                              ? NetworkImage(
                                                  'http://mita.balifoam.com/mobile/flutter/image_asset/${data['Image']}')
                                              : AssetImage(
                                                  'assets/images/no_image.png',
                                                ),
                                        ),
                                      ),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(19, 25, 37, 1),
                                              Color.fromRGBO(19, 25, 37, 0.8),
                                              Color.fromRGBO(19, 25, 37, 0.5),
                                              Color.fromRGBO(19, 25, 37, 0.45),
                                              Color.fromRGBO(19, 25, 37, 0.35),
                                              Color.fromARGB(0, 0, 0, 0)
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (data['Profile_Image'] != "" &&
                                            data['Profile_Image'] != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImagePreviewScreen(
                                                        imageUrl:
                                                            'http://mita.balifoam.com/mobile/flutter/image_user_profile/${data['Profile_Image']}',
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            image: DecorationImage(
                                                image: data['Profile_Image'] !=
                                                            "" &&
                                                        data['Profile_Image'] !=
                                                            null
                                                    ? NetworkImage(
                                                        'http://mita.balifoam.com/mobile/flutter/image_user_profile/${data['Profile_Image']}',
                                                      )
                                                    : AssetImage(
                                                        'assets/images/avatar.png'),
                                                fit: BoxFit.cover)),
                                        // child: Image.network('http://mita.balifoam.com/mobile/flutter/image_user_profile/${data['Profile_Image']}', key: ValueKey(new Random().nextInt(100)),),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //SizedBox(height: 180,),
                                          Text(
                                            data['ID_Asset'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (data['Type'] != 'K')
                                                    Text(
                                                        '${data['Description']} ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                                  Text(
                                                    '${data['Manufacture']} ${data['Model']}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                  if (data['Type'] == 'K')
                                                    data['No'] == null
                                                        ? SizedBox.shrink()
                                                        : Text(
                                                            '${data['No']}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              if (int.parse(
                                                      provider.userLevel) <=
                                                  3)
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        editHeight = 290;
                                                      });
                                                    },
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white,
                                                        size: 17))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///hanya user yang bisa lihat
                                  if (int.parse(provider.userLevel) >= 4)
                                    Positioned(
                                      bottom: 20,
                                      right: 10,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                            onTap: () async {
                                              final now = DateTime.now();
                                              final DateFormat formatter =
                                                  DateFormat('H');
                                              //print(int.parse(formatter.format(now)).toString());
                                              if (int.parse(formatter
                                                          .format(now)) >=
                                                      8 &&
                                                  int.parse(formatter
                                                          .format(now)) <=
                                                      16) {
                                                if (data['Reserve'] == '1' ||
                                                    data['View'] == '1') {
                                                  ///sudah di request
                                                  showDialogDouble();
                                                } else {
                                                  if (data['Based'] == 'KM' &&
                                                      data['Type'] == 'K') {
                                                    ///khusus untuk based Maintenance KM
                                                    showDialogOption(
                                                        data['ID_Asset'],
                                                        data['Description'],
                                                        data['Manufacture'],
                                                        data['Model'],
                                                        data['Type'],
                                                        data['Class'],
                                                        data['No'],
                                                        snapshot.data['data'][3]
                                                                ['dataDetail']
                                                            ['Schedule_KM'],
                                                        snapshot.data['data'][3]
                                                                ['dataDetail'][
                                                            'Next_Maintenance']);
                                                  } else {
                                                    requestService(
                                                        data['ID_Asset'],
                                                        data['Description'],
                                                        data['Manufacture'],
                                                        data['Model'],
                                                        data['Type'],
                                                        data['Class']);
                                                  }
                                                }
                                              } else {
                                                showDialogError(
                                                    'Sudah melewati jam kerja 08:00 - 16.00. Coba lagi lain waktu.');
                                              }
                                            },
                                            child: Icon(
                                              Icons.add_moderator,
                                              color: data['Reserve'] == '1' ||
                                                      data['View'] == '1'
                                                  ? Colors.blueGrey
                                                  : Colors.white,
                                            )),
                                      ),
                                    )
                                ],
                              ),

                              ///edit_model
                              Container(
                                height: editHeight,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editHeight = 0;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: Colors.grey[200],
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: TextField(
                                                controller: textField1,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                focusNode: focusText1,
                                                onChanged: (val) {
                                                  if (textField1
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon1 = true;
                                                    });
                                                  } else if (textField1
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon1 = false;
                                                    });
                                                  }
                                                },
                                                onTap: () {
                                                  textField1.selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              textField1
                                                                  .text.length);
                                                  if (textField1
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon1 = true;
                                                    });
                                                  } else if (textField1
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon1 = false;
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Manufacture',
                                                  icon: Icon(
                                                      Icons.house_outlined),

                                                  suffixIcon: textIcon1 &&
                                                          focusText1.hasFocus
                                                      ? IconButton(
                                                          icon:
                                                              Icon(Icons.clear),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            textField1.clear();
                                                            setState(() {
                                                              textIcon1 = false;
                                                            });
                                                          },
                                                        )
                                                      : SizedBox.shrink(),
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: Colors.grey[200],
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: TextField(
                                                controller: textField2,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                focusNode: focusText2,
                                                onChanged: (val) {
                                                  if (textField2
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon2 = true;
                                                    });
                                                  } else if (textField2
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon2 = false;
                                                    });
                                                  }
                                                },
                                                onTap: () {
                                                  textField2.selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              textField2
                                                                  .text.length);
                                                  if (textField2
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon2 = true;
                                                    });
                                                  } else if (textField2
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon2 = false;
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Model',
                                                  icon: Icon(Icons
                                                      .model_training_outlined),

                                                  suffixIcon: textIcon2 &&
                                                          focusText2.hasFocus
                                                      ? IconButton(
                                                          icon:
                                                              Icon(Icons.clear),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            textField2.clear();
                                                            setState(() {
                                                              textIcon2 = false;
                                                            });
                                                          },
                                                        )
                                                      : SizedBox.shrink(),
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: Colors.grey[200],
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: TextField(
                                                controller: textField3,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                focusNode: focusText3,
                                                onChanged: (val) {
                                                  if (textField3
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon3 = true;
                                                    });
                                                  } else if (textField3
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon3 = false;
                                                    });
                                                  }
                                                },
                                                onTap: () {
                                                  textField3.selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              textField3
                                                                  .text.length);
                                                  if (textField3
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      textIcon3 = true;
                                                    });
                                                  } else if (textField3
                                                      .text.isEmpty) {
                                                    setState(() {
                                                      textIcon3 = false;
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'No',
                                                  icon: Icon(Icons
                                                      .confirmation_number_outlined),

                                                  suffixIcon: textIcon3 &&
                                                          focusText3.hasFocus
                                                      ? IconButton(
                                                          icon:
                                                              Icon(Icons.clear),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            textField3.clear();
                                                            setState(() {
                                                              textIcon3 = false;
                                                            });
                                                          },
                                                        )
                                                      : SizedBox.shrink(),
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.grey)),
                                                onPressed: () {
                                                  focusText1.unfocus();
                                                  focusText2.unfocus();
                                                  focusText3.unfocus();

                                                  setState(() {
                                                    editHeight = 0;
                                                  });

                                                  textField1.clear();
                                                  textField2.clear();
                                                  textField3.clear();
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              ElevatedButton(
                                                child: isSimpan
                                                    ? Row(
                                                        children: [
                                                          CupertinoActivityIndicator(
                                                            radius: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text('Please wait..',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))
                                                        ],
                                                      )
                                                    : Text(
                                                        'Simpan',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blue)),
                                                onPressed: () async {
                                                  focusText1.unfocus();
                                                  focusText2.unfocus();
                                                  focusText3.unfocus();

                                                  setState(() {
                                                    isSimpan = true;
                                                  });

                                                  var res = await dioService
                                                      .updateDetailAsset(
                                                          provider
                                                              .selectedIdAsset,
                                                          textField1.text,
                                                          textField2.text,
                                                          textField3.text);
                                                  if (res == 'OK') {
                                                    setState(() {
                                                      isSimpan = false;
                                                      editHeight = 0;
                                                    });

                                                    textField1.clear();
                                                    textField2.clear();
                                                    textField3.clear();
                                                  } else {
                                                    setState(() {
                                                      isSimpan = false;
                                                      editHeight = 0;
                                                    });

                                                    textField1.clear();
                                                    textField2.clear();
                                                    textField3.clear();
                                                    EasyLoading.showError(
                                                        'Update gagal.',
                                                        duration: Duration(
                                                            seconds: 2));
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///title
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Detail Info'),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ///nama user
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.person_outline),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            data['User'] == null
                                                ? Text('-')
                                                : Text(data['User']),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if (int.parse(provider.userLevel) <=
                                                3)
                                              GestureDetector(
                                                  onTap: () async {
                                                    var res = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditUserScreen()));
                                                    if (res == 'updated') {
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 17,
                                                  ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        ///lokasi
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.location_on_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(data['Location'])
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        ///next servis
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_sharp),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            snapshot.data['data'][3]['exist'] >
                                                    0
                                                ? Text(snapshot.data['data'][3]
                                                        ['dataDetail']
                                                    ['Next_Service'])
                                                : Text('-'),
                                          ],
                                        ),
                                        if (data['Based'] == 'KM')
                                          Column(
                                            children: [
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.book_outlined),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Row(children: [
                                                    snapshot.data['data'][4]
                                                                ['exist'] ==
                                                            0
                                                        ? Text('-')
                                                        : Expanded(
                                                            child: Text(
                                                              'Last seen KM ${snapshot.data['data'][4]['dataDetail']['last_KM']} | ${snapshot.data['data'][4]['dataDetail']['ratio']} km/l',
                                                              style:
                                                                  TextStyle(),
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                  ])),
                                                ],
                                              ),
                                            ],
                                          ),
                                        if (data['Based'] == 'KM')
                                          Column(
                                            children: [
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.arrow_forward),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Row(children: [
                                                    snapshot.data['data'][3]
                                                                ['exist'] ==
                                                            0
                                                        ? Text('-')
                                                        : Expanded(
                                                            child: Text(
                                                              '${snapshot.data['data'][3]['dataDetail']['Next_Maintenance']} @ KM ${snapshot.data['data'][3]['dataDetail']['Schedule_KM']}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                  ])),
                                                ],
                                              ),
                                            ],
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (data['Type'] == 'K' &&
                                            data['Based'] == 'KM' &&
                                            int.parse(snapshot.data['data'][3]
                                                    ['dataDetail']['Late_KM']) >
                                                0)
                                          Column(
                                            children: [
                                              Row(children: [
                                                Icon(Icons.av_timer_rounded),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      'Terlambat service ${snapshot.data['data'][3]['dataDetail']['Late_KM']} KM',
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )
                                              ]),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),

                                        ///ready atau maintenance
                                        ///
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                data['Available'] == '1'
                                                    ? Icon(Icons
                                                        .warning_amber_sharp)
                                                    : Icon(
                                                        Icons.warning,
                                                        color: Colors.yellow,
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                //if(provider.asset.available == "1")
                                                data['Available'] == '1'
                                                    ? Text('Ready')
                                                    : Text('Under maintenance'),
                                                //if(provider.asset.available == "0")
                                                //Text('Under Maintenance')
                                              ],
                                            ),
                                            if (data['Based'] == 'Time' &&
                                                ((int.parse(provider
                                                                .userLevel) <
                                                            3 &&
                                                        data['Type'] != 'PC') ||
                                                    (int.parse(provider
                                                                .userLevel) ==
                                                            3 &&
                                                        data['Type'] == 'PC')))
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        final now =
                                                            DateTime.now();
                                                        final DateFormat
                                                            formatter =
                                                            DateFormat('H');
                                                        if (int.parse(formatter
                                                                    .format(
                                                                        now)) >=
                                                                8 &&
                                                            int.parse(formatter
                                                                    .format(
                                                                        now)) <=
                                                                16) {
                                                          ///view 0 -> tidak ada request ///untuk time based only
                                                          if (data['View'] ==
                                                              '0') {
                                                            EasyLoading.show(
                                                                maskType:
                                                                    EasyLoadingMaskType
                                                                        .custom);
                                                            service
                                                                .getNewRequestMaintenance(
                                                                    idAsset:
                                                                        provider
                                                                            .selectedIdAsset,
                                                                    currentKm:
                                                                        '',
                                                                    idUser: user
                                                                        .uid)
                                                                .then((value) {
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  () {
                                                                setState(() {
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              });
                                                            });
                                                          } else {
                                                            showDialogDouble();
                                                          }
                                                        } else {
                                                          showDialogError(
                                                              'Sudah melewati jam kerja 08:00 - 16.00. Coba lagi lain waktu.');
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.add_moderator,
                                                        color:
                                                            data['View'] == '0'
                                                                ? Colors.black
                                                                : Colors.grey,
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        ///asuransi atau recharge

                                        if (snapshot.data['data'][2]['exist'] >
                                            0)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    (data['Type'] == 'K')
                                                        ? CrossAxisAlignment
                                                            .start
                                                        : CrossAxisAlignment
                                                            .center,
                                                children: [
                                                  if (data['Type'] == 'K')
                                                    Icon(Icons.directions_car),
                                                  if (data['Type'] == 'AP')
                                                    Icon(Icons
                                                        .fire_extinguisher_outlined),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (data['Type'] == 'K')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(snapshot.data[
                                                                        'data'][2]
                                                                    [
                                                                    'dataDetail']
                                                                [
                                                                'Insurance_Name']),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 8),
                                                              child: Icon(
                                                                Icons.circle,
                                                                size: 8,
                                                              ),
                                                            ),
                                                            Text(snapshot.data[
                                                                        'data'][2]
                                                                    [
                                                                    'dataDetail']
                                                                ['ID_Policy']),
                                                            if (int.parse(provider
                                                                    .userLevel) <=
                                                                3)
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            editInsuranceHeight =
                                                                                260;
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              20,
                                                                        )),
                                                              ),
                                                          ],
                                                        ),
                                                        Text(
                                                            'Expired data -> ${snapshot.data['data'][2]['dataDetail']['Date_Expire']}'),
                                                      ],
                                                    ),
                                                  if (data['Type'] == 'AP')
                                                    Row(children: [
                                                      Text(
                                                          'Expired data -> ${snapshot.data['data'][2]['dataDetail']['Date_Expire']}'),
                                                      if (int.parse(provider
                                                              .userLevel) <=
                                                          3)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      editAparHeight =
                                                                          130;
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    size: 20,
                                                                  )),
                                                        ),
                                                    ]),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),

                                        ///edit_asuransi
                                        if (data['Type'] == 'K')
                                          Container(
                                            height: editInsuranceHeight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: Colors.grey[200],
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                            color: Colors.yellow
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: TextField(
                                                            controller:
                                                                textField4,
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            focusNode:
                                                                focusText4,
                                                            onChanged: (val) {
                                                              if (textField4
                                                                  .text
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  textIcon4 =
                                                                      true;
                                                                  textField4Error =
                                                                      false;
                                                                });
                                                              } else if (textField4
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  textIcon4 =
                                                                      false;
                                                                });
                                                              }

                                                              checkValidSimpan2();
                                                            },
                                                            onTap: () {
                                                              textField4
                                                                      .selection =
                                                                  TextSelection(
                                                                      baseOffset:
                                                                          0,
                                                                      extentOffset: textField4
                                                                          .text
                                                                          .length);
                                                              if (textField4
                                                                  .text
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  textIcon4 =
                                                                      true;
                                                                });
                                                              } else if (textField4
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  textIcon4 =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Nama Asuransi',
                                                              icon: Icon(Icons
                                                                  .house_outlined),

                                                              suffixIcon: textIcon4 &&
                                                                      focusText4
                                                                          .hasFocus
                                                                  ? IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .clear),
                                                                      iconSize:
                                                                          20,
                                                                      onPressed:
                                                                          () {
                                                                        textField4
                                                                            .clear();
                                                                        setState(
                                                                            () {
                                                                          textIcon4 =
                                                                              false;
                                                                        });
                                                                        checkValidSimpan2();
                                                                      },
                                                                    )
                                                                  : SizedBox
                                                                      .shrink(),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                              //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                            ),
                                                          ),
                                                        ),
                                                        textField4Error
                                                            ? Text(
                                                                'Kolom ini tidak boleh kosong.',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red))
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                            color: Colors.yellow
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10.0),
                                                          child: TextField(
                                                            controller:
                                                                textField5,
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            focusNode:
                                                                focusText5,
                                                            onChanged: (val) {
                                                              if (textField5
                                                                  .text
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  textIcon5 =
                                                                      true;
                                                                  textField5Error =
                                                                      false;
                                                                });
                                                              } else if (textField5
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  textIcon5 =
                                                                      false;
                                                                });
                                                              }
                                                              checkValidSimpan2();
                                                            },
                                                            onTap: () {
                                                              textField5
                                                                      .selection =
                                                                  TextSelection(
                                                                      baseOffset:
                                                                          0,
                                                                      extentOffset: textField5
                                                                          .text
                                                                          .length);
                                                              if (textField5
                                                                  .text
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  textIcon5 =
                                                                      true;
                                                                });
                                                              } else if (textField5
                                                                  .text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  textIcon5 =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'No Asuransi',
                                                              icon: Icon(Icons
                                                                  .confirmation_number_outlined),

                                                              suffixIcon: textIcon5 &&
                                                                      focusText5
                                                                          .hasFocus
                                                                  ? IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .clear),
                                                                      iconSize:
                                                                          20,
                                                                      onPressed:
                                                                          () {
                                                                        textField5
                                                                            .clear();
                                                                        setState(
                                                                            () {
                                                                          textIcon5 =
                                                                              false;
                                                                        });
                                                                        checkValidSimpan2();
                                                                      },
                                                                    )
                                                                  : SizedBox
                                                                      .shrink(),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                              //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                            ),
                                                          ),
                                                        ),
                                                        textField5Error
                                                            ? Text(
                                                                'Kolom ini tidak boleh kosong.',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red))
                                                            : SizedBox.shrink()
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          color: Colors.yellow
                                                              .withOpacity(0.3),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .calendar_today_outlined,
                                                                size: 15),
                                                            SizedBox(width: 15),
                                                            Text('Expired : '),
                                                            Text(dateExpired),
                                                            TextButton(
                                                                onPressed: () {
                                                                  focusText4
                                                                      .unfocus();
                                                                  focusText5
                                                                      .unfocus();

                                                                  showModalDatePicker();
                                                                },
                                                                child: Text(
                                                                    'Ubah')),
                                                          ],
                                                        )),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors
                                                                        .grey)),
                                                        onPressed: () {
                                                          focusText4.unfocus();
                                                          focusText5.unfocus();

                                                          setState(() {
                                                            editInsuranceHeight =
                                                                0;
                                                          });

                                                          textField4.clear();
                                                          textField5.clear();
                                                        },
                                                      ),
                                                      SizedBox(width: 20),
                                                      ElevatedButton(
                                                        child: isSimpan2
                                                            ? Row(
                                                                children: [
                                                                  CupertinoActivityIndicator(
                                                                    radius: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                      'Please wait..',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white))
                                                                ],
                                                              )
                                                            : Text(
                                                                'Simpan',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStatePropertyAll(
                                                                    validSimpan2
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .grey)),
                                                        onPressed: () async {
                                                          if (validSimpan2) {
                                                            focusText4
                                                                .unfocus();
                                                            focusText5
                                                                .unfocus();

                                                            setState(() {
                                                              isSimpan2 = true;
                                                            });

                                                            var res = await dioService
                                                                .updateAsuransi(
                                                                    provider
                                                                        .selectedIdAsset,
                                                                    dateExpired,
                                                                    user.uid,
                                                                    textField4
                                                                        .text,
                                                                    textField5
                                                                        .text,
                                                                    data[
                                                                        'Type']);
                                                            if (res == 'OK') {
                                                              setState(() {
                                                                isSimpan2 =
                                                                    false;
                                                                editInsuranceHeight =
                                                                    0;
                                                              });

                                                              textField4
                                                                  .clear();
                                                              textField5
                                                                  .clear();
                                                            } else {
                                                              setState(() {
                                                                isSimpan2 =
                                                                    false;
                                                                editInsuranceHeight =
                                                                    0;
                                                              });

                                                              textField4
                                                                  .clear();
                                                              textField5
                                                                  .clear();
                                                              EasyLoading.showError(
                                                                  'Update gagal.',
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2));
                                                            }
                                                          } else {
                                                            if (textField4
                                                                .text.isEmpty) {
                                                              setState(() {
                                                                textField4Error =
                                                                    true;
                                                              });
                                                            } else if (textField5
                                                                .text.isEmpty) {
                                                              setState(() {
                                                                textField5Error =
                                                                    true;
                                                              });
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        if (data['Type'] == 'AP')
                                          Container(
                                            height: editAparHeight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: Colors.grey[200],
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          color: Colors.yellow
                                                              .withOpacity(0.3),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .calendar_today_outlined,
                                                                size: 15),
                                                            SizedBox(width: 15),
                                                            Text('Expired : '),
                                                            Text(dateExpired),
                                                            TextButton(
                                                                onPressed: () {
                                                                  showModalDatePicker();
                                                                },
                                                                child: Text(
                                                                    'Ubah')),
                                                          ],
                                                        )),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors
                                                                        .grey)),
                                                        onPressed: () {
                                                          setState(() {
                                                            editAparHeight = 0;
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(width: 20),
                                                      ElevatedButton(
                                                        child: isSimpan2
                                                            ? Row(
                                                                children: [
                                                                  CupertinoActivityIndicator(
                                                                    radius: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                      'Please wait..',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white))
                                                                ],
                                                              )
                                                            : Text(
                                                                'Simpan',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors
                                                                        .blue)),
                                                        onPressed: () async {
                                                          setState(() {
                                                            isSimpan2 = true;
                                                          });

                                                          var res = await dioService
                                                              .updateAsuransi(
                                                                  provider
                                                                      .selectedIdAsset,
                                                                  dateExpired,
                                                                  user.uid,
                                                                  '',
                                                                  '',
                                                                  data['Type']);
                                                          if (res == 'OK') {
                                                            setState(() {
                                                              isSimpan2 = false;
                                                              editAparHeight =
                                                                  0;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isSimpan2 = false;
                                                              editAparHeight =
                                                                  0;
                                                            });

                                                            EasyLoading.showError(
                                                                'Update gagal.',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2));
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ///hanya teknisi yang bisa lihat
                                        SizedBox(
                                          height: 5,
                                        ),

                                        if (int.parse(provider.userLevel) <= 3)
                                          Container(
                                            color:
                                                Colors.purple.withOpacity(0.1),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ///foto user
                                                  GestureDetector(
                                                      onTap: () async {
                                                        var res = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfileCameraBackScreen()));
                                                        //print(res);
                                                        if (res != null) {
                                                          //print(res);
                                                          setState(() {
                                                            path =
                                                                res; //res[0].thumbPath;
                                                          });

                                                          EasyLoading.show(
                                                              maskType:
                                                                  EasyLoadingMaskType
                                                                      .custom);
                                                          var save = await service
                                                              .saveUserPicture(
                                                                  path: path,
                                                                  idAsset: data[
                                                                      'ID_Asset']);
                                                          if (save == 'OK') {
                                                            EasyLoading.showSuccess(
                                                                'Updated',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2));
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds: 3),
                                                                () {
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                            setState(() {});
                                                          } else if (save ==
                                                              'NOK') {
                                                            showDialogError(
                                                                'Update gagal. Cobalah beberapa saat lagi.');
                                                            EasyLoading
                                                                .dismiss();
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey[400]),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.camera,
                                                                size: 15,
                                                                color: Colors
                                                                    .blueAccent,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text('User'),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  ///foto mesin
                                                  GestureDetector(
                                                      onTap: () async {
                                                        var res = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AssetCameraBackScreen()));
                                                        //print(res);

                                                        if (res != null) {
                                                          //print(res);
                                                          setState(() {
                                                            pathAsset =
                                                                res; //res[0].thumbPath;
                                                          });

                                                          EasyLoading.show(
                                                              maskType:
                                                                  EasyLoadingMaskType
                                                                      .custom);
                                                          var save = await service
                                                              .saveAssetPicture(
                                                                  path:
                                                                      pathAsset,
                                                                  idAsset: data[
                                                                      'ID_Asset']);
                                                          //var save = await service.saveUserPicture(path: pathAsset, idAsset: provider.asset.id_asset);
                                                          if (save == 'OK') {
                                                            EasyLoading.showSuccess(
                                                                'Updated',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2));
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds: 3),
                                                                () {
                                                              EasyLoading
                                                                  .dismiss();
                                                            });

                                                            setState(() {});
                                                          } else if (save ==
                                                              'NOK') {
                                                            showDialogError(
                                                                'Update gagal. Cobalah beberapa saat lagi.');
                                                            EasyLoading
                                                                .dismiss();
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12)),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.camera,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text('Asset'),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  ///link user
                                                  if (provider.userLevel ==
                                                          '0' ||
                                                      provider.userLevel == '3')
                                                    GestureDetector(
                                                        onTap: () async {
                                                          var res = await Navigator
                                                              .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          LinkedScreen(
                                                                            nama:
                                                                                data['uid'],
                                                                          )));
                                                          //print(res);
                                                          if (res ==
                                                              'updated') {
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          12)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .insert_link,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text('Linked'),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                ],
                                              ),
                                            ),
                                          ),

                                        if (data['Type'] == 'GS')
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, bottom: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () async {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PemanasanGenset()));
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          12)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                          .grey[
                                                                      400]),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .flash_on_sharp,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Text(
                                                                      'Pemanasan'),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )),

                              ///title
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Riwayat Perbaikan'),
                                ),
                              ),

                              ///card problem
                              snapshot.data['data'][1]['exist'] > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data['data'][1]
                                          ['exist'],
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = snapshot.data['data'][1]
                                            ['dataDetail'][index];

                                        return InkWell(
                                          onTap: () {
                                            //EasyLoading.show(maskType: EasyLoadingMaskType.custom);
                                            //provider.getSelectedCase(data);
                                            provider.getSelectedIdCase(
                                                data['ID_Request']);

                                            var upd = Navigator.pushNamed(
                                                context,
                                                CaseDetailScreen.route);
                                            // ignore: unrelated_type_equality_checks
                                            if (upd == 'update') {
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.grey[200]))
                                                //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                //color: Colors.green
                                                ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 18,
                                                  top: 8,
                                                  left: 8,
                                                  right: 8),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                data[
                                                                    'ID_Request'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    color: int.parse(data['Step']) <
                                                                            7
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              if (data[
                                                                      'Maintenance_Type'] ==
                                                                  "CM")
                                                                Icon(
                                                                  Icons
                                                                      .build_circle,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 18,
                                                                )
                                                            ],
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: int.parse(data[
                                                                            'Step']) <
                                                                        7
                                                                    ? Colors.red
                                                                        .withOpacity(
                                                                            0.1)
                                                                    : Colors.grey[
                                                                        100],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .handyman_outlined,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(data[
                                                                          'Time_Request'])
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .person_outline,
                                                                        size:
                                                                            23,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                      child: Row(
                                                                          children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            data['Requestor'],
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        )
                                                                      ]))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        data['Problem'],
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Text('Belum ada data.'),
                            ],
                          ),
                        );
                      }
                      return Container(
                          child: Center(
                        child: JumpingDotsProgressIndicator(
                            fontSize: 50.0, color: Colors.orange),
                      ));
                    }),
                AnimatedContainer(
                  height: _showAppbar ? 90.0 : 0.0,
                  duration: Duration(milliseconds: 100),
                  child: AppBar(
                    elevation: 1,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.grey,
                        )),
                    flexibleSpace: SafeArea(
                      child: GestureDetector(
                        onTap: () async {
                          var x = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchDetailScreen()));
                          if (x == null) {
                            _controller.animateTo(
                                _controller.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            clipBehavior: Clip.hardEdge,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 12, left: 50),
                              child: Container(
                                //color: Colors.grey[100],
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Icon(Icons.search),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Search description'),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SafeArea(
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

  _customAppBarDefault() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
      elevation: 2.0,
      backgroundColor: Colors.greenAccent,
      title: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*
            Text(
              "Balifoam", style: TextStyle(
              color: Colors.black87,
              fontSize: 12.0,
              fontWeight: FontWeight.w400,

            ),

            ),
            SizedBox(height: 5,),

             */
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.book_outlined,
                  size: 20.0,
                  color: Color.fromRGBO(238, 100, 83, 1),
                ),
                SizedBox(width: 2.5),
                Flexible(
                  child: Text(
                    'Asset List',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  requestService(idAsset, description, manufacture, model, type, kelas) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestFormScreen(
                  idAsset: idAsset,
                  description: description,
                  manufacture: manufacture,
                  model: model,
                )));
    if (res != null) {
      setState(() {});

      ///perlu di touchup disable sementara
      dioService.sendNotificationCM('1', type, kelas, user.uid, res);
    } else {
      print('ga jadi');
    }
  }

  showDialogDouble() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text(
                'Sudah ada permintaan perbaikan/perawatan lain untuk mesin ini'),
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

  showDialogOption(idAsset, description, manufacture, model, type, kelas, no,
      scheduleKm, nextMaintenance) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Pilih layanan.'),
            actions: [
              TextButton(
                child: Text(
                  'Perbaikan',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  requestService(
                      idAsset, description, manufacture, model, type, kelas);
                },
              ),
              TextButton(
                child: Text(
                  'Perawatan Rutin',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaintenanceScreen(
                                idAsset: idAsset,
                                manufacture: manufacture,
                                model: model,
                                no: no,
                                nextKm: scheduleKm,
                                nextMaintenance: nextMaintenance,
                              )));
                  if (res != null) {
                    setState(() {});
                    dioService.sendNotificationCM(
                        '1', type, kelas, user.uid, res);
                  }
                },
              ),
              TextButton(
                child: Text(
                  'Cancel',
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

  showDialogError(e) {
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

  showModalDatePicker() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                color: Colors.white),
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  ///print(DateFormat('yyyy-MM-dd').format(args.value).toString());
                  dateExpired =
                      DateFormat('dd-MM-yyyy').format(args.value).toString();
                });
                Navigator.pop(context);
              },
              selectionMode: DateRangePickerSelectionMode.single,
            ),
          );
        });
  }

  checkValidSimpan2() {
    if (textField4.text.length > 0 && textField5.text.length > 0) {
      setState(() {
        validSimpan2 = true;
      });
    } else {
      setState(() {
        validSimpan2 = false;
      });
    }
  }
}
