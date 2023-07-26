import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:progress_indicators/progress_indicators.dart';

class PemanasanGenset extends StatefulWidget {
  @override
  _PemanasanGensetState createState() => _PemanasanGensetState();
}

class _PemanasanGensetState extends State<PemanasanGenset> {
  User user = FirebaseAuth.instance.currentUser;
  DioService dioService = DioService();
  bool isStart = false;
  bool isStop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            'Pemanasan Genset',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () async {
                final now = DateTime.now();
                final DateFormat formatter = DateFormat('H');

                //if(true){
                if (int.parse(formatter.format(now)) >= 8 &&
                    int.parse(formatter.format(now)) <= 16) {
                  var res = await dioService.requestPemanasanGenset();
                  if (res == 'OK') {
                    EasyLoading.showSuccess(
                        'Berhasil. Scan barcode untuk memulai.',
                        duration: Duration(seconds: 2));
                    setState(() {});
                  } else {
                    EasyLoading.showError('Gagal. Silahkan ulangi lagi.',
                        duration: Duration(seconds: 2));
                  }
                } else {
                  showDialogOut(
                      'Sudah melewati jam kerja 08:00 - 16.00. Coba lagi lain waktu.');
                }

                //Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample()));
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: dioService.loadDataGenset(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data['data'][0];
              if (data['exist'] > 0) {
                return ListView.builder(
                  itemCount: data['exist'],
                  itemBuilder: (context, index) {
                    var dataDetail = data['dataDetail'][index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: Colors.grey[300])),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataDetail['ID_Request'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataDetail['Time_Request']),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    dataDetail['Name'] == null
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                dataDetail['Name'],
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          )
                                  ],
                                ),
                                dataDetail['Step'] == '0' ||
                                        dataDetail['Step'] == '3'
                                    ? SizedBox.shrink()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'start: ${dataDetail['Time_Start']}'),
                                          dataDetail['Step'] == '1'
                                              ? Text('stop: -')
                                              : Text(
                                                  'stop: ${dataDetail['Time_Stop']}'),
                                        ],
                                      ),
                                if (dataDetail['Step'] == '3')
                                  Text(
                                    'Missed Out',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                if (dataDetail['Step'] == '0')
                                  ElevatedButton(
                                    child: isStart
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
                                                      color: Colors.white))
                                            ],
                                          )
                                        : Text(
                                            'Start',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () async {
                                      setState(() {
                                        isStart = true;
                                      });
                                      scanQR(0, dataDetail['ID_Request']);
                                    },
                                  ),
                                if (dataDetail['Step'] == '1')
                                  ElevatedButton(
                                    child: isStop
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
                                                      color: Colors.white))
                                            ],
                                          )
                                        : Text(
                                            'Stop',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () async {
                                      setState(() {
                                        isStop = true;
                                      });
                                      scanQR(1, dataDetail['ID_Request']);
                                    },
                                  ),
                                if (dataDetail['Step'] == '2')
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                if (dataDetail['Step'] == '3')
                                  Icon(Icons.cancel, color: Colors.red)
                              ]),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            }
            return Center(
              child: JumpingDotsProgressIndicator(
                  fontSize: 50.0, color: Colors.orange),
            );
          },
        ));
  }

  Future<void> scanQR(mode, idCase) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      if (barcodeScanRes == 'BFNMF0402') {
        if (mode == 0) {
          ///jika start

          var res = await dioService.getPemanasanGenset(idCase, '1', user.uid);

          if (res == 'OK') {
            setState(() {
              isStart = false;
            });
          }
        } else {
          ///jika stop
          ///
          var res = await dioService.getPemanasanGenset(idCase, '2', user.uid);

          if (res == 'OK') {
            setState(() {
              isStop = false;
            });
          }
        }
      } else {
        showDialogError();
      }
    } else {
      setState(() {
        isStart = false;
        isStop = false;
      });
    }
  }

  showDialogError() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('ID Asset tidak sesuai. Mohon diperiksa kembali.'),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    isStart = false;
                    isStop = false;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showDialogOut(e) {
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
