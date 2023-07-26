import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mita/dio_service.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ReportMesinProduksi extends StatefulWidget {

  final String id;
  final String step;
  final int userLevel;
  ReportMesinProduksi({this.id, this.step, this.userLevel});

  @override
  _ReportMesinProduksiState createState() => _ReportMesinProduksiState();
}

class _ReportMesinProduksiState extends State<ReportMesinProduksi> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  bool loaded = false;

  bool isLoading =false;

  bool isPdf = false;
  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }
/*
  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }


 */
  @override
  void initState() {
    //requestPersmission();
    getFileFromUrl("https://mita.balifoam.com/mobile/flutter/report/file_report/${widget.id}.pdf").then(
          (value) => {
        setState(() {
          if (value != null) {
            urlPDFPath = value.path;
            loaded = true;
            exists = true;
          } else {
            exists = false;
          }
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int page, int total) {
            setState(() {
              _currentPage = page;
            });
          },
          onPageError: (page, e) {},
        ),
        /*
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('APPROVE')
          ],
        ),

         */
        bottomSheet: widget.step=='0' && widget.userLevel >= 4 ?AnimatedContainer(
          duration: Duration(milliseconds: 1500),
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 2,

              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    InkWell(
                      onTap: ()async{
                        setState(() {
                          isLoading = true;

                        });
                        var resData = await dioService.approveDataReportMesin(user.uid, widget.id);
                        print(resData);
                        if(resData == 'OK'){
                          setState(() {
                            isPdf=true;
                          });
                          var resPdf = await dioService.approvePdfReportMesin(widget.id);
                          print(resPdf);

                            EasyLoading.showSuccess('Terima kasih atas partisipasinya.',duration: Duration(seconds: 2));
                            setState(() {
                              isLoading = false;
                              isPdf =false;
                            });
                            Navigator.pop(context,'completed');

                        } else {
                          ///gagal
                          EasyLoading.showError('Failed creating file.',duration: Duration(seconds: 2));
                          setState(() {
                            isLoading = false;
                            isPdf =false;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: isLoading? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 30,
                                width: 30,
                                child: CupertinoActivityIndicator(radius: 11,)),
                            SizedBox(width: 10),
                            isPdf? Text('Create Pdf...',
                                style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                            ),):Text(
                              "Updating...",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ) : Text(
                          "Approve",
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

        ) : SizedBox.shrink(),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
        return Scaffold(

          body: Center(
            child: JumpingDotsProgressIndicator(
              fontSize: 40.0,
            ),
          )
        );
      } else {
        //Replace Error UI
        return Scaffold(
          body: Text(
            "PDF Not Available",
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }
}