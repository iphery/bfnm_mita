import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/api_service.dart';
import 'package:mita/checklist/checklist_apar.dart';
import 'package:mita/checklist/checklist_box_hydrant.dart';
import 'package:mita/checklist/checklist_kendaraan_1.dart';
import 'package:mita/checklist/checklist_kendaraan_2.dart';
import 'package:mita/checklist/checklist_kendaraan_3.dart';
import 'package:mita/checklist/checklist_komputer.dart';
import 'package:mita/checklist/checklist_mesin_1.dart';
import 'package:mita/checklist/checklist_mesin_2.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_acMaintenanceComplete.dart';
import 'package:mita/x_addPictureScreen.dart';
import 'package:mita/x_checklistScreen.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_maintenanceCompleteScreen.dart';
import 'package:mita/x_orderPartScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_serviceCompleteScreen.dart';
import 'package:mita/x_userApproveScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'checklist/checklist_ac.dart';
import 'checklist/checklist_hydrant.dart';
import 'checklist/checklist_kendaraan.dart';
import 'checklist/checklist_panel.dart';

class CaseDetailScreen extends StatefulWidget {
  static const route = '/casedetailscreen';

  @override
  _CaseDetailScreenState createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  ApiService service = ApiService();

  DioService dioService = DioService();
  List pathList = [];

  User user = FirebaseAuth.instance.currentUser;

  final textEditing = TextEditingController();
  bool showClearIcon = false;

  bool isTechResponse = false;
  bool isPosRequired = false;
  bool isPosCompleted = false;
  bool isServiceComplete = false;
  bool isTechSpv = false;
  bool isProdSpv = false;

  double panelHeight = 0;
  //String user = '111111';
  bool isShowPanel = false;

  double serviceCompleteHeight = 0;

  double boxJobAcceptHeight = 0;
  double boxServiceCompleteHeight = 0;
  double boxSparePartOrderHeight = 0;
  double boxSparePartReceiveHeight = 0;
  double boxTechSpvCheckedHeight = 0;
  double boxUserApprovedHeight = 0;
  double boxUserApprovedMPHeight = 0;

  bool isBoxJobAccept = false;
  bool isBoxSparePartReceive = false;
  bool isBoxServiceComplete = false;
  bool isBoxTechSpvChecked = false;

  bool isPanelShow = false;
  bool isPanelShowB = false;

  int overtime = 0;
  final focus = FocusNode();

  Future loadData;

  bool isTechAccept = false;
  bool isSparePartOrder = false;
  bool isSparePartReceive = false;
  bool isServiceCompleted = false;
  bool isSpvChecked = false;
  bool isUserApproved = false;

  bool pauseIsLoading = false;

  StreamSubscription internetconnection;
  bool isoffline = false;

  var textField4 = TextEditingController();
  bool textIcon4 = false;
  FocusNode focusText4 = FocusNode();
  bool textField4Error = false;

  bool isSimpan2 = false;
  bool validSimpan2 = false;
/*
  getUserLevel()async{
    final provider = Provider.of<AssetProvider>(context, listen: false);
    var userLevel = await dioService.getUserLevel(user.uid);

    provider.getUserLevel(userLevel['Level']);
  }

 */

  getCaseStep() async {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    var caseStep = await dioService.getCaseStep(provider.selectedIdCase);

    int step = int.parse(caseStep['Step']);
    String type = caseStep['Type'];
    String idRequestor = caseStep['ID_Requestor'];
    String idTech = caseStep['ID_Tech'];
    String maintenanceType = caseStep['Maintenance_Type'];
    String kelas = caseStep['Kelas'];
    String assetUid = caseStep['uid'];
    String based = caseStep['Based'];

    switch (caseStep['Step']) {
      case '1':

        ///untuk teknisi
        if (type != 'PC' &&
            (provider.userLevel == '0' ||
                provider.userLevel == '1' ||
                provider.userLevel == '2')) {
          setState(() {
            boxJobAcceptHeight = 80;
            isPanelShow = true;
          });

          ///untuk edp
        } else if (type == 'PC' && provider.userLevel == '3') {
          setState(() {
            boxJobAcceptHeight = 80;
            isPanelShow = true;
          });
        }

        break;

      case '2':

        ///untuk yang terima job
        if (user.uid == idTech) {
          setState(() {
            boxSparePartOrderHeight = 80;
            isPanelShow = true;
          });
        }

        break;

      case '3':

        ///untuk yang terima job
        if (user.uid == idTech) {
          setState(() {
            boxSparePartReceiveHeight = 80;
            isPanelShow = true;
          });
        }

        break;

      case '4':

        ///untuk yang terima job
        if (user.uid == idTech) {
          setState(() {
            boxServiceCompleteHeight = 80;
            isPanelShow = true;
          });
        }

        break;

      case '5':

        ///untuk spv me
        if (type != 'PC' &&
            (provider.userLevel == '0' || provider.userLevel == '1')) {
          setState(() {
            boxTechSpvCheckedHeight = 150;
            isPanelShowB = true;
          });

          ///untuk edp
        } else if (type == 'PC' && provider.userLevel == '3') {
          setState(() {
            boxTechSpvCheckedHeight = 150;
            isPanelShowB = true;
          });
        }

        break;

      case '6':

        ///untuk user/requestor
        ///khusus untuk MP validasi dari group atau kepala produksi
        if (maintenanceType == 'PM' && type == 'MP') {
          if ((provider.userDivisi == 'Produksi') ||
              (provider.userDivisi == 'Produksi A' && kelas != 'Spon') ||
              (provider.userDivisi == 'Produksi B' && kelas == 'Spon')) {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' && (type == 'GS' || type == 'PN')) {
          if (provider.userLevel == '0') {
            setState(() {
              boxUserApprovedHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' &&
            (type == 'AP' || type == 'HY' || type == 'BH')) {
          if (provider.userDivisi == 'HRD') {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' && type == 'PC') {
          if (user.uid == assetUid) {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' && type == 'AC') {
          if (user.uid == assetUid) {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' && type == 'K' && based == 'Time') {
          if (provider.userDivisi == kelas ||
              provider.userDivisi == 'Produksi') {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else if (maintenanceType == 'PM' && type == 'FK') {
          if (user.uid == assetUid) {
            setState(() {
              boxUserApprovedMPHeight = 80;
              isPanelShow = true;
            });
          }
        } else {
          if (user.uid == idRequestor) {
            setState(() {
              boxUserApprovedHeight = 80;
              isPanelShow = true;
            });
          }
        }

        break;
    }
  }

  @override
  void initState() {
    //getUserLevel();
    getCaseStep();

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

    // TODO: implement initState
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
          title: Text('Detail', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: !isoffline
            ? FutureBuilder(
                future: dioService.getCaseDetail(provider.selectedIdCase),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var dataInfo = snapshot.data['data'][0]['dataDetail'];
                    final now = DateTime.now();
                    final DateFormat formatter = DateFormat('H');

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 4, right: 8, left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('# ${dataInfo['ID_Request']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.blueGrey)),
                                ],
                              ),
                            ),
                            SmoothStarRating(
                              rating: double.parse(dataInfo['Rating']),
                              isReadOnly: false,
                              size: 20,
                              color: Colors.orangeAccent,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 2.0,
                            ),

                            ///info
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 4, right: 8, left: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.25,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            dataInfo['ID_Asset'],
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          dataInfo['User'] == null
                                              ? SizedBox.shrink()
                                              : Text(
                                                  ' | ${dataInfo['User']}',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      if (dataInfo['Type'] == 'K')
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${dataInfo['Manufacture']} ${dataInfo['Model']} | ${dataInfo['No']} ',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (dataInfo['Type'] != 'K')
                                        Row(
                                          children: [
                                            Expanded(
                                              child: dataInfo['Model'] != null
                                                  ? Text(
                                                      '${dataInfo['Description']} ${dataInfo['Manufacture']} ${dataInfo['Model']}',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  : Text(
                                                      '${dataInfo['Description']} ${dataInfo['Manufacture']}',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Issued by ${dataInfo['Requestor']} on ${dataInfo['Time_Request']}',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.black45,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Problem'),
                                              //Text('Edit', style: TextStyle(color:Colors.blue),)
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.blueAccent,
                                          ),
                                          //if(dataInfo['Maintenance_Type'] == 'CM')
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                dataInfo['Problem'],
                                                maxLines: 4,
                                              )),
                                            ],
                                          ),
                                          //if(dataInfo['Maintenance_Type'] == 'PM' && dataInfo['Based'] == 'Time')
                                          //Text('Perawatan rutin. ${dataInfo['Solution']}'),
                                          //if(dataInfo['Maintenance_Type'] == 'PM' && dataInfo['Based']=='KM')
                                          //Text('${snapshot.data['data'][3]['dataDetail']['Next_Maintenance']} @ KM ${snapshot.data['data'][3]['dataDetail']['Schedule_KM']}. ${dataInfo['Solution']}'),
                                          ///next development
                                          /*
                                      Container(

                                        //height: 100,

                                        child: Container(
                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: Colors.grey[200],
                                          ),


                                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        //borderRadius: BorderRadius.all(Radius.circular(8)),
                                                        color: Colors.yellow.withOpacity(0.3),
                                                      ),


                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                      child: TextField(
                                                        controller: textField4,
                                                        textAlignVertical: TextAlignVertical.center,
                                                        focusNode: focusText4,
                                                        onChanged: (val){
                                                          if(textField4.text.isNotEmpty){
                                                            setState(() {
                                                              textIcon4 = true;
                                                              textField4Error =false;
                                                            });
                                                          } else if(textField4.text.isEmpty){
                                                            setState(() {
                                                              textIcon4 = false;

                                                            });
                                                          }


                                                        },
                                                        onTap: (){
                                                          textField4.selection = TextSelection(baseOffset: 0, extentOffset: textField4.text.length);
                                                          if(textField4.text.isNotEmpty){
                                                            setState(() {
                                                              textIcon4 = true;
                                                            });
                                                          } else if(textField4.text.isEmpty){
                                                            setState(() {
                                                              textIcon4 = false;
                                                            });
                                                          }
                                                        },



                                                        decoration: InputDecoration(
                                                          hintText: 'Nama Asuransi',
                                                          icon: Icon(Icons.house_outlined),

                                                          suffixIcon: textIcon4 && focusText4.hasFocus? IconButton(
                                                            icon: Icon(Icons.clear),
                                                            iconSize: 20,
                                                            onPressed: (){
                                                              textField4.clear();
                                                              setState(() {
                                                                textIcon4 = false;

                                                              });

                                                            },

                                                          ) : SizedBox.shrink() ,
                                                          border: InputBorder.none,
                                                          isDense: true,
                                                          //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                                                        ),
                                                      ),


                                                    ),
                                                    textField4Error?Text('Kolom ini tidak boleh kosong.', style: TextStyle(color:Colors.red)):SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),




                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  RaisedButton(

                                                    child: Text('Cancel', style: TextStyle(color: Colors.white),),
                                                    color: Colors.grey,
                                                    onPressed: (){
                                                      focusText4.unfocus();


                                                      setState(() {
                                                        //editInsuranceHeight = 0;
                                                      });

                                                      textField4.clear();

                                                    },
                                                  ),
                                                  SizedBox(width: 20),
                                                  RaisedButton(

                                                    child: isSimpan2? Row(
                                                      children: [
                                                        CupertinoActivityIndicator(radius: 10,),
                                                        SizedBox(width: 4,),
                                                        Text('Please wait..',style: TextStyle(color: Colors.white))
                                                      ],
                                                    ):Text('Simpan', style: TextStyle(color: Colors.white),),
                                                    color: validSimpan2?Colors.blue:Colors.grey,
                                                    onPressed: ()async{


                                                      if(validSimpan2){

                                                        focusText4.unfocus();

                                                        setState(() {
                                                          isSimpan2 = true;
                                                        });
var res = false;
                                                        //var res = await dioService.updateAsuransi(provider.selectedIdAsset, dateExpired, user.uid, textField4.text, textField5.text, data['Type']);
                                                        if(res == 'OK'){
                                                          setState(() {
                                                            isSimpan2 = false;
                                                            //editInsuranceHeight = 0;
                                                          });

                                                          textField4.clear();


                                                        } else{
                                                          setState(() {
                                                            isSimpan2 = false;
                                                            //editInsuranceHeight = 0;
                                                          });

                                                          textField4.clear();
                                                          EasyLoading.showError('Update gagal.',duration: Duration(seconds : 2));

                                                        }

                                                      }else{
                                                        if(textField4.text.isEmpty){
                                                          setState(() {
                                                            textField4Error = true;
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

                                       */
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///pause panel
                            if (int.parse(provider.userLevel) <= 3 &&
                                (int.parse(dataInfo['Step']) == 2 ||
                                    int.parse(dataInfo['Step']) == 4) &&
                                (int.parse(formatter.format(now)) >= 8 &&
                                    int.parse(formatter.format(now)) <= 16))
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      pauseIsLoading = true;
                                    });

                                    Future.delayed(Duration(milliseconds: 1000),
                                        () async {
                                      if (dataInfo['Hold'] == '0') {
                                        var hold =
                                            await dioService.setHoldMaintenance(
                                                provider.selectedIdCase);
                                        if (hold == 'OK_Hold') {
                                          setState(() {
                                            pauseIsLoading = false;
                                          });
                                        }
                                      } else {
                                        var lanjut = await dioService
                                            .setContinueMaintenance(
                                                provider.selectedIdCase);
                                        if (lanjut == 'OK_Continue') {
                                          setState(() {
                                            pauseIsLoading = false;
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    //height: 50,
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.all(Radius.circular(8)),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                          Colors.redAccent.withOpacity(0.5),
                                          Colors.blueAccent.withOpacity(0.5)
                                        ])),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  'Click untuk menunda aktivitas',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                border: Border.all(
                                                    color: Colors.white),
                                              ),
                                              child: Stack(
                                                children: [
                                                  pauseIsLoading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : SizedBox.shrink(),
                                                  Center(
                                                      child: Icon(dataInfo[
                                                                  'Hold'] ==
                                                              '0'
                                                          ? Icons
                                                              .play_arrow_rounded
                                                          : Icons.pause))
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ///status
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8, left: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.25,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Status'),
                                      Divider(
                                        color: Colors.blueAccent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Request issued by ${dataInfo['Requestor']}'),
                                                    Text(dataInfo[
                                                        'Time_Request'])
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///teknisi response
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: int.parse(
                                                            dataInfo['Step']) >=
                                                        2
                                                    ? Colors.green
                                                    : Colors.grey),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            2
                                                        ? Text(
                                                            'Response by ${dataInfo['Technician']}')
                                                        : Text(
                                                            'Technician response',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            2
                                                        ? Text(dataInfo[
                                                            'Time_Response'])
                                                        : Container()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///spare part order
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: dataInfo['POS_Required'] ==
                                                      '1'
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Spare part order / service',
                                                      style: TextStyle(
                                                          color: dataInfo[
                                                                      'POS_Required'] ==
                                                                  '1'
                                                              ? Colors.black
                                                              : Colors.grey),
                                                    ),
                                                    dataInfo['POS_Required'] ==
                                                            '1'
                                                        ? Text(dataInfo[
                                                            'Time_POS'])
                                                        : Text(
                                                            'No order/service part',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: dataInfo['POS_Required'] ==
                                                      '1'
                                                  ? int.parse(dataInfo[
                                                              'Step']) >=
                                                          4
                                                      ? Colors.green
                                                      : Colors.grey
                                                  : Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Spare part receive',
                                                      style: TextStyle(
                                                          color: dataInfo[
                                                                      'POS_Required'] ==
                                                                  '1'
                                                              ? int.parse(dataInfo[
                                                                          'Step']) >=
                                                                      4
                                                                  ? Colors.black
                                                                  : Colors.grey
                                                              : Colors.grey),
                                                    ),
                                                    dataInfo['POS_Required'] ==
                                                            '1'
                                                        ? int.parse(dataInfo[
                                                                    'Step']) >=
                                                                4
                                                            ? Text(dataInfo[
                                                                'Time_POS_Complete'])
                                                            : Container()
                                                        : Container()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  int.parse(dataInfo['Step']) >=
                                                          5
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            5
                                                        ? Text(
                                                            'Service complete by ${dataInfo['Technician']}')
                                                        : Text(
                                                            'Job Completion',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            5
                                                        ? Text(dataInfo[
                                                            'Time_Repair_Complete'])
                                                        : Container()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  int.parse(dataInfo['Step']) >=
                                                          6
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            6
                                                        ? Text(
                                                            'Checked by ${dataInfo['Tech_SPV_Name']}')
                                                        : Text(
                                                            'Tech Spv checking',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            6
                                                        ? Text(dataInfo[
                                                            'Tech_SPV'])
                                                        : Container()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  int.parse(dataInfo['Step']) >=
                                                          7
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            7
                                                        ? Text(
                                                            'Approved by ${dataInfo['Approver_Name']}')
                                                        : Text(
                                                            'User approval',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                    int.parse(dataInfo[
                                                                'Step']) >=
                                                            7
                                                        ? Text(dataInfo[
                                                            'Prod_SPV'])
                                                        : Container()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///Solution
                            int.parse(dataInfo['Step']) >= 5
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4, right: 8, left: 8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.25,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Solution'),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueAccent,
                                            ),
                                            if (dataInfo['Maintenance_Type'] ==
                                                'CM')
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    dataInfo['Solution'],
                                                  )),
                                                ],
                                              ),
                                            if (dataInfo['Maintenance_Type'] ==
                                                'PM')
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    'Refer to Checklist. ${dataInfo['Solution']}',
                                                    maxLines: 4,
                                                  )),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),

                            ///summary
                            int.parse(dataInfo['Step']) >= 5
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4, right: 8, left: 8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.25,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Summary'),
                                            Divider(
                                              color: Colors.blueAccent,
                                            ),
                                            Text(
                                                'Respon teknisi ${dataInfo['Response_Time']} jam'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'Lama perbaikan ${dataInfo['Repair_Time']} jam')
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),

                            ///gambar
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8, left: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.25,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Picture'),
                                          if (int.parse(dataInfo['Step']) < 6)
                                            GestureDetector(
                                                onTap: () async {
                                                  var res = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddPictureScreen()));
                                                  if (res == 'submitted') {
                                                    setState(() {});
                                                  }
                                                },
                                                child:
                                                    Icon(Icons.add, size: 20))
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.blueAccent,
                                      ),
                                      snapshot.data['data'][2]['exist'] > 0
                                          ? Container(
                                              height: 120,
                                              child: ListView.builder(
                                                itemCount: snapshot.data['data']
                                                    [2]['exist'],
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  var pic =
                                                      snapshot.data['data'][2]
                                                              ['dataDetail']
                                                          [index]['Image_Name'];

                                                  String address =
                                                      'https://mita.balifoam.com/mobile/flutter/image_case';
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImagePreviewScreen(
                                                                          imageUrl:
                                                                              '$address/$pic',
                                                                        )));
                                                      },
                                                      child: Container(
                                                        width: 150,
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.yellow,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    '$address/$pic'),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Text('Tidak ada data')
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///spare part
                            if (dataInfo['POS_Required'] == '1')
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 8, left: 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.25,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Spare Part Order / Service'),
                                        Divider(
                                          color: Colors.blueAccent,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              dataInfo['POS_Description'],
                                              maxLines: 5,
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ///checklist
                            if (dataInfo['Maintenance_Type'] == 'PM' &&
                                int.parse(dataInfo['Step']) >= 2)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 8, left: 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.25,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Checklist'),
                                            if (int.parse(dataInfo['Step']) >=
                                                    2 &&
                                                int.parse(dataInfo['Step']) < 5)
                                              GestureDetector(
                                                onTap: () async {
                                                  var res =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChecklistScreen(
                                                                    idRequest:
                                                                        provider
                                                                            .selectedIdCase,
                                                                  )));
                                                  print(res);
                                                  if (res == 'submitted') {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    if (snapshot
                                                                .data['data'][1]
                                                                    [
                                                                    'dataDetail']
                                                                .length ==
                                                            0 &&
                                                        dataInfo['ID_Tech'] ==
                                                            user.uid)
                                                      Text('Add New',
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                          )),
                                                    if (snapshot
                                                                .data['data'][1]
                                                                    [
                                                                    'dataDetail']
                                                                .length !=
                                                            0 &&
                                                        dataInfo['ID_Tech'] ==
                                                            user.uid)
                                                      Text('Edit',
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                          ))
                                                  ],
                                                ),
                                              )
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.blueAccent,
                                        ),
                                        snapshot.data['data'][1]['dataDetail']
                                                    .length !=
                                                0
                                            ? ListView.builder(
                                                itemCount: snapshot
                                                    .data['data'][1]
                                                        ['dataDetail']
                                                    .length,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  var dataCheck =
                                                      snapshot.data['data'][1]
                                                          ['dataDetail'][index];

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    Colors.grey[
                                                                        300]))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              bottom: 4),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            flex: 10,
                                                            child: Text(
                                                              dataCheck['Code'],
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 80,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  dataCheck[
                                                                      'Description'],
                                                                  maxLines: 2,
                                                                ),
                                                                dataCheck['Input_Type'] ==
                                                                        'T'
                                                                    ? Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Container(
                                                                                  color: Colors.blue.shade50,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: Text(
                                                                                      '${dataCheck['Action']}',
                                                                                      maxLines: 2,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ))),
                                                                        ],
                                                                      )
                                                                    : SizedBox
                                                                        .shrink()
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                              flex: 10,
                                                              child: dataCheck[
                                                                          'Input_Type'] ==
                                                                      'C'
                                                                  ? Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color: dataCheck['Action'] ==
                                                                              '1'
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .grey[400],
                                                                      size: 20,
                                                                    )
                                                                  : SizedBox
                                                                      .shrink()),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : SizedBox.shrink()

                                        //Text('Respon teknisi ${dataInfo.response_time} jam'),

                                        //Text('Lama perbaikan ${dataInfo.repair_time} jam')
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            SizedBox(
                              height: isPanelShow
                                  ? 80
                                  : isPanelShowB
                                      ? 150
                                      : 0,
                            )
                          ]),
                        ),

                        ///terima job

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxJobAcceptHeight,
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
                                        onTap: () async {
                                          setState(() {
                                            isBoxJobAccept = true;
                                          });

                                          //scanQR(provider.selectedIdCase, provider.asset.id_asset);
                                          scanQR(
                                              provider.selectedIdCase,
                                              dataInfo['ID_Asset'],
                                              dataInfo['Type'],
                                              dataInfo['Class'],
                                              dataInfo['ID_Requestor']);
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: isBoxJobAccept
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CupertinoActivityIndicator(
                                                          radius: 11,
                                                        )),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Please wait...",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  "Service",
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
                        ),

                        ///order part atau complete
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxSparePartOrderHeight,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 50,
                                    child: InkWell(
                                      onTap: () async {
                                        var order = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderPartScreen()));
                                        if (order == 'submitted') {
                                          print('sudah disubmit');
                                          setState(() {
                                            boxSparePartOrderHeight = 0;
                                            isPanelShow = false;
                                          });
                                          EasyLoading.showSuccess(
                                              'Harap hubungi pihak pembelian !!',
                                              duration: Duration(seconds: 2));
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          print('belum di submit');
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 8,
                                            right: 4),
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Text(
                                            "Order spare part",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 50,
                                    child: InkWell(
                                      onTap: () {
                                        lastCheck(
                                            dataInfo['Maintenance_Type'],
                                            dataInfo['Type'],
                                            dataInfo['ID_Asset'],
                                            dataInfo['Class'],
                                            provider.selectedIdCase,
                                            dataInfo['Description'],
                                            dataInfo['Manufacture'],
                                            dataInfo['Model'],
                                            dataInfo['Problem'],
                                            dataInfo['Checklist']);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8,
                                            left: 4,
                                            right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Selesai",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        ///receive part
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxSparePartReceiveHeight,
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
                                        onTap: () async {
                                          setState(() {
                                            isBoxSparePartReceive = true;
                                          });

                                          var res = await dioService
                                              .getSparepartReceive(
                                                  provider.selectedIdCase);
                                          if (res == 'OK') {
                                            setState(() {
                                              isBoxSparePartReceive = false;
                                            });
                                            EasyLoading.showSuccess(
                                                'Waktunya beraksi lagi !!',
                                                duration: Duration(seconds: 2));
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            setState(() {
                                              isBoxSparePartReceive = false;
                                            });
                                            showDialogError(
                                                'Update gagal. Cobalah beberapa saat lagi.');
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: isBoxSparePartReceive
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CupertinoActivityIndicator(
                                                          radius: 11,
                                                        )),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Please wait...",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  "Terima spare part",
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
                        ),

                        ///service complete
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxServiceCompleteHeight,
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
                                        onTap: () async {
                                          setState(() {
                                            isBoxServiceComplete = true;
                                          });

                                          lastCheck(
                                              dataInfo['Maintenance_Type'],
                                              dataInfo['Type'],
                                              dataInfo['ID_Asset'],
                                              dataInfo['Class'],
                                              provider.selectedIdCase,
                                              dataInfo['Description'],
                                              dataInfo['Manufacture'],
                                              dataInfo['Model'],
                                              dataInfo['Problem'],
                                              dataInfo['Checklist']);

                                          setState(() {
                                            boxServiceCompleteHeight = 0;
                                            isPanelShow = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Selesai",
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
                        ),

                        ///spv check
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxTechSpvCheckedHeight,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                            'Tulis overtime jika ada ( jam )'),
                                      ),
                                      isBoxTechSpvChecked
                                          ? SizedBox.shrink()
                                          : Container(
                                              //color: Colors.red,
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: TextField(
                                                  controller: textEditing,
                                                  focusNode: focus,
                                                  onChanged: (val) {
                                                    if (textEditing
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        showClearIcon = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showClearIcon = false;
                                                      });
                                                    }
                                                  },
                                                  onTap: () {
                                                    textEditing.selection =
                                                        TextSelection(
                                                            baseOffset: 0,
                                                            extentOffset:
                                                                textEditing.text
                                                                    .length);
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: '',
                                                      border: InputBorder.none,
                                                      suffixIcon: showClearIcon
                                                          ? IconButton(
                                                              icon: Icon(
                                                                  Icons.clear),
                                                              iconSize: 20,
                                                              onPressed: () {
                                                                textEditing
                                                                    .clear();
                                                                setState(() {
                                                                  showClearIcon =
                                                                      false;
                                                                });
                                                              },
                                                            )
                                                          : SizedBox.shrink()),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () async {
                                        focus.unfocus();

                                        setState(() {
                                          isBoxTechSpvChecked = true;
                                        });
                                        String lembur = '';
                                        if (textEditing.text.isEmpty) {
                                          lembur = '0';
                                        } else {
                                          lembur = textEditing.text;
                                        }

                                        var res = await dioService.getLastCheck(
                                            provider.selectedIdCase,
                                            lembur,
                                            user.uid);

                                        if (res == 'OK') {
                                          setState(() {
                                            isBoxTechSpvChecked = false;
                                            boxTechSpvCheckedHeight = 0;
                                            isPanelShowB = false;
                                          });

                                          EasyLoading.showSuccess('Awesome !!',
                                              duration: Duration(seconds: 2));
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });

                                          if (dataInfo['Maintenance_Type'] ==
                                              'PM') {
                                            await dioService.sendNotificationPM(
                                                '6',
                                                dataInfo['Type'],
                                                dataInfo['Class'],
                                                provider.selectedIdCase);
                                          } else {
                                            ///ini cm
                                            await dioService.sendNotificationCM(
                                                '6',
                                                dataInfo['Type'],
                                                dataInfo['Class'],
                                                user.uid,
                                                provider.selectedIdCase);
                                          }
                                          /*

                                    if(dataInfo['Type'] == 'MP' && dataInfo['Maintenance_Type'] == 'PM'){
                                      ///handle notif MP
                                      await dioService.sendNotificationPM('6', dataInfo['Type'], dataInfo['Class'], provider.selectedIdCase);
                                    } else if(dataInfo['Type'] == 'AP' && dataInfo['Maintenance_Type'] == 'PM'){
                                      ///handle notif AP
                                      await dioService.sendNotificationPM('6', dataInfo['Type'], dataInfo['Class'], provider.selectedIdCase);

                                    }
                                    else if(dataInfo['Type'] == 'FH' && dataInfo['Maintenance_Type'] == 'PM'){
                                      ///handle notif FH
                                      await dioService.sendNotificationPM('6', dataInfo['Type'], dataInfo['Class'], provider.selectedIdCase);

                                    }else {

                                      await dioService.sendNotificationCM('6', dataInfo['Type'], dataInfo['Class'], user.uid, provider.selectedIdCase);

                                    }


                                     */
                                        } else {
                                          setState(() {
                                            isBoxTechSpvChecked = false;
                                          });
                                          showDialogError(
                                              'Update gagal. Cobalah beberapa saat lagi.');
                                          //print(res);
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Material(
                                          elevation: 2,
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Column(
                                            children: [
                                              AnimatedContainer(
                                                duration: Duration(seconds: 1),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: isBoxTechSpvChecked
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  CupertinoActivityIndicator(
                                                                radius: 11,
                                                              )),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "Please wait...",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Text(
                                                        "Periksa",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        ///user approve
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxUserApprovedHeight,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () async {
                                  var approve = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserApproveScreen(
                                                idAsset: dataInfo['ID_Asset'],
                                              )));
                                  if (approve == 'done') {
                                    print('close');
                                    setState(() {
                                      boxUserApprovedHeight = 0;
                                      isPanelShow = false;
                                    });

                                    EasyLoading.showSuccess(
                                        'Terima kasih atas kerjasamanya !!',
                                        duration: Duration(seconds: 2));
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    print('belum acc');
                                  }
                                },
                                child: Material(
                                  elevation: 2,
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Selesai",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        ///user approve untuk PM && MP
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: boxUserApprovedMPHeight,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () async {
                                  var approve = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserApproveScreen(
                                                idAsset: dataInfo['ID_Asset'],
                                              )));
                                  if (approve == 'done') {
                                    print('close');
                                    setState(() {
                                      boxUserApprovedHeight = 0;
                                      isPanelShow = false;
                                    });

                                    EasyLoading.showSuccess(
                                        'Terima kasih atas kerjasamanya !!',
                                        duration: Duration(seconds: 2));
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    print('belum acc');
                                  }
                                },
                                child: Material(
                                  elevation: 2,
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Selesai",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return Container(
                      child: Center(
                    child: JumpingDotsProgressIndicator(
                        fontSize: 50.0, color: Colors.orange),
                  ));
                })
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

  lastCheck(maintenanceType, category, idAsset, kelas, idCase, description,
      manufacture, model, problem, checklist) async {
    if (maintenanceType == 'CM') {
      ///jika perbaikan
      var complete = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceCompleteScreen(
                    description: description,
                    manufacture: manufacture,
                    model: model,
                    problem: problem,
                  )));
      if (complete == 'completed') {
        print('sudah selesai');
        setState(() {
          boxSparePartOrderHeight = 0;
          boxServiceCompleteHeight = 0;
          isBoxServiceComplete = false;
          isPanelShow = false;
        });

        EasyLoading.showSuccess('Good job !!', duration: Duration(seconds: 2));
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        //notifikasi
        //dioService.sendNotificationCM('5', typeAsset, kelas, '', idCase);
        await dioService.sendNotificationCM(
            '5', category, kelas, user.uid, idCase);
      } else {
        //print('belum selesai');
      }
    } else {
      ///cek ada checklist atau tidak
      if (checklist != '') {
        var complete = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MaintenanceCompleteScreen(
                      kelas: kelas,
                    )));
        if (complete == 'completed') {
          //print('sudah selesai');
          setState(() {
            boxSparePartOrderHeight = 0;
            boxServiceCompleteHeight = 0;
            isBoxServiceComplete = false;
            isPanelShow = false;
          });

          EasyLoading.showSuccess('Good job !!',
              duration: Duration(seconds: 2));
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
          //notifikasi
          //dioService.sendNotificationCM('5', typeAsset, kelas, '', idCase);
          await dioService.sendNotificationCM(
              '5', category, kelas, user.uid, idCase);
        } else {
          //print('belum selesai');
        }
      } else {
        ///dialog gagal

        showDialogError("Checklist belum disubmit, mohon periksa kembali.");
      }
    }
  }

  Future<void> scanQR(idCase, idAsset, type, kelas, userUid) async {
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
      if (barcodeScanRes == idAsset) {
        var res = await dioService.getTechResponse(idAsset, idCase, user.uid);
        //print(res);
        if (res == 'OK') {
          setState(() {
            isBoxJobAccept = false;
            boxJobAcceptHeight = 0;
            isPanelShow = false;
          });

          ///kirim notifikasi masih masalah
          //disable sementara
          await dioService.sendNotificationCM(
              '2', type, kelas, userUid, idCase);
          EasyLoading.showSuccess('Keep fighting !!',
              duration: Duration(seconds: 2));
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        } else {
          setState(() {
            isBoxJobAccept = false;
          });
          showDialogError('Update gagal. Cobalah beberapa saat lagi.');
        }
      } else {
        setState(() {
          ///jika tidak sama
          isBoxJobAccept = false;
        });
        showDialog();
      }
    } else {
      ///jika batal scan
      setState(() {
        isBoxJobAccept = false;
      });
    }

    ///jika sama lanjut ke step berikutnya
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('ID Request tidak sesuai. Mohon diperiksa kembali.'),
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

  ///summary
  ///terima job -> scanQR -> notification
  ///order part ->
  ///receive part ->
  ///part complete ->
  ///
}
