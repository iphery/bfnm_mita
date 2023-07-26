import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mita/model/assets.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_assetDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class LinkedScreen extends StatefulWidget {
  String nama;
  LinkedScreen({this.nama});

  @override
  _LinkedScreenState createState() => _LinkedScreenState();
}

class _LinkedScreenState extends State<LinkedScreen> {
  var textFieldController = TextEditingController();
  bool textFieldIconShow = false;
  String keyword = '';
  FocusNode focusTextField = FocusNode();
  DioService dioService = DioService();

  List<Assets> dataAsset = [];

  StreamSubscription internetconnection;
  bool isoffline = false;

  @override
  void initState() {
    focusTextField.requestFocus();

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Padding(
            padding:
                const EdgeInsets.only(left: 50, top: 4, bottom: 4, right: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.grey[100],
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: textFieldController,
                textAlignVertical: TextAlignVertical.center,
                focusNode: focusTextField,
                onChanged: (val) {
                  if (textFieldController.text.isNotEmpty) {
                    setState(() {
                      textFieldIconShow = true;
                    });
                  } else if (textFieldController.text.isEmpty) {
                    setState(() {
                      textFieldIconShow = false;
                    });
                  }

                  keyword = val;
                },
                onTap: () {
                  textFieldController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textFieldController.text.length);
                  if (textFieldController.text.isNotEmpty) {
                    setState(() {
                      textFieldIconShow = true;
                    });
                  } else if (textFieldController.text.isEmpty) {
                    setState(() {
                      textFieldIconShow = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search",

                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                  suffixIcon: textFieldIconShow
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          iconSize: 20,
                          onPressed: () {
                            textFieldController.clear();
                            setState(() {
                              textFieldIconShow = false;
                            });
                            keyword = '';
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
          backgroundColor: Colors.white,
        ),
        body: !isoffline
            ? FutureBuilder(
                future: dioService.loadUserLinked(keyword, widget.nama),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['exist'] > 0) {
                      return Column(children: [
                        SizedBox(
                          //height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    border: Border.all(
                                        color: Colors.red.withOpacity(0.6))),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: widget.nama == null
                                            ? Text(
                                                'No linked',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(
                                                'This asset linked to ${snapshot.data['nama']}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      )
                                    ],
                                  ),
                                )),
                          ), //link user
                        ),
                        Expanded(
                            child: ListView.builder(
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data['exist'],
                          itemBuilder: (BuildContext context, int index) {
                            var dataDetail = snapshot.data['dataDetail'][index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border:
                                          Border.all(color: Colors.grey[200])),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(dataDetail['Name']),
                                            SizedBox(height: 5),
                                            Text(dataDetail['Uid'],
                                                style: TextStyle(
                                                    color: Colors.blue))
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String msg =
                                                  'Pilih - ${dataDetail['Name']} - sebagai Approver untuk asset ini ?';
                                              showDialogMsg(
                                                msg,
                                                dataDetail['Uid'],
                                                provider.selectedIdAsset,
                                              );
                                              //print(dataDetail['nama']);
                                            },
                                            child:
                                                Icon(Icons.select_all_outlined))
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ))
                      ]);
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Ups.. data tidak ditemukan.'),
                        ),
                      ],
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: JumpingDotsProgressIndicator(
                          fontSize: 40.0, color: Colors.orange),
                    ),
                  );
                },
              )
            : Column(
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

  showDialogMsg(message, uid, idAsset) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(
                  'CANCEL',
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
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  focusTextField.unfocus();
                  var res = await dioService.updateUserLinked(uid, idAsset);
                  if (res == 'OK') {
                    EasyLoading.showSuccess('Update berhasil.',
                        duration: Duration(seconds: 2));
                    Navigator.pop(context);
                    Navigator.pop(context, 'updated');
                  } else {
                    EasyLoading.showError('Update gagal.',
                        duration: Duration(seconds: 2));
                    Navigator.pop(context);
                  }

                  //Navigator.pop(context);
                  //Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
