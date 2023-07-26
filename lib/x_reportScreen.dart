import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_progressMaintenance.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_qualityObjective.dart';
import 'package:mita/x_reportApar.dart';
import 'package:mita/x_reportMesinProduksi.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isLoadingQP = false;
  bool isLoadingQF = false;
  bool isLoadingDS = false;
  bool isLoadingPR = false;
  bool isLoadingSP = false;
  bool isLoadingEK = false;
  bool isLoadingMK = false;
  bool isLoadingAP = false;
  bool isLoadingHY = false;
  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: (){

              Navigator.pop(context);
            },
          ),
          title: Text('Report', style: TextStyle(color: Colors.black),),




          backgroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>QualityObjectiveScreen()));
                  showYearList(context, DateTime.now());
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.green, Colors.black87]
                      ),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Laporan', style: TextStyle(color: Colors.white),),
                            SizedBox(height: 10,),
                            Text('Quality Objective', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image : AssetImage('assets/images/report.png')
                          )
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.blueGrey,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){

                  var now = new DateTime.now();
                  var formatter1 = new DateFormat('yyyy');
                  var formatter2= new DateFormat('MM');
                  String tahun = formatter1.format(now);
                  String bulan = formatter2.format(now);

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProgressScreen(tahun: tahun,bulan: bulan ,)));
                  //showYearList(context, DateTime.now());
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.lightBlue, Colors.black87]
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Laporan', style: TextStyle(color: Colors.white),),
                            SizedBox(height: 10,),
                            Text('Progress Maintenance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image : AssetImage('assets/images/report.png')
                            )
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
/*
            FutureBuilder(
              future: dioService.progressMaintenance(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  var data = snapshot.data['data'][0];
                  var progress_mesin = data['mesin']/data['qty_mesin'];
                  var percentage_mesin = (data['mesin']/data['qty_mesin'])*100;

                  var progress_mesinQF = data['mesinQF']/data['qty_mesinQF'];
                  var percentage_mesinQF = (data['mesinQF']/data['qty_mesinQF'])*100;

                  var progress_mesinQP = data['mesinQP']/data['qty_mesinQP'];
                  var percentage_mesinQP = (data['mesinQP']/data['qty_mesinQP'])*100;

                  var progress_mesinDS = data['mesinDS']/data['qty_mesinDS'];
                  var percentage_mesinDS = (data['mesinDS']/data['qty_mesinDS'])*100;

                  var progress_mesinPR = data['mesinPR']/data['qty_mesinPR'];
                  var percentage_mesinPR = (data['mesinPR']/data['qty_mesinPR'])*100;

                  var progress_mesinSP = data['mesinSP']/data['qty_mesinSP'];
                  var percentage_mesinSP = (data['mesinSP']/data['qty_mesinSP'])*100;

                  var progress_kendaraanEK = data['kendaraanEK']/data['qty_kendaraanEK'];
                  var percentage_kendaraanEK = (data['kendaraanEK']/data['qty_kendaraanEK'])*100;

                  var progress_kendaraanMK = data['kendaraanMK']/data['qty_kendaraanMK'];
                  var percentage_kendaraanMK = (data['kendaraanMK']/data['qty_kendaraanMK'])*100;

                  var progressApar = data['apar']/data['qty_apar'];
                  var percentageApar = (data['apar']/data['qty_apar'])*100;

                  var progressHydrant = data['hydrant']/data['qty_hydrant'];
                  var percentageHydrant = (data['hydrant']/data['qty_hydrant'])*100;


                  return Column(
                      children:[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('PROGRESS MAINTENANCE', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            ),

                          ],
                        ),
///Q. Finishing
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quilting Finishing'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_mesinQF,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_mesinQF.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['mesinQF']}/${data['qty_mesinQF']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportQF']<1 && data['mesinQF']==data['qty_mesinQF']?
                                        child: data['mesinQF']!=data['qty_mesinQF']? data['reportQF']<1 ? Container(): RaisedButton(
                                            child: isLoadingQF?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingQF = true;
                                              });

                                              var res = await dioService.createReportMesin('Quilting Finishing', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingQF = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    await dioService.sendNotificationReport('Quilting Finishing', 'Monthly Report Mesin - Quilting Finishing');
                                                    await dioService.sendNotificationReport('Produksi', 'Monthly Report Mesin - Quilting Finishing');

                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingQF = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingQF = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportQF']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportQF'],step: data['step_reportQF'],userLevel: int.parse(provider.userLevel),)));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

///Q. Persediaan
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quilting Persediaan'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_mesinQP,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_mesinQP.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['mesinQP']}/${data['qty_mesinQP']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      ///data['reportQP']<1 && data['mesinQP']==data['qty_mesinQP']?
                                      child: data['mesinQP']!=data['qty_mesinQP']? data['reportQP']<1 ? Container():RaisedButton(
                                          child: isLoadingQP?Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: CupertinoActivityIndicator(radius: 11,)),

                                            ],
                                          ):
                                          Text('Create report'),
                                          onPressed: ()async{
                                            setState(() {
                                              isLoadingQP = true;
                                            });

                                            var res = await dioService.createReportMesin('Quilting Persediaan', user.uid);
                                           //print(res);
                                            if(res == 'Exist'){
                                              EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                              setState(() {
                                                isLoadingQP = false;
                                              });
                                            } else {
                                              if(res != null){
                                                var write = await dioService.createPdfReportMesin(res);
                                                if(write == 'OK'){
                                                  await dioService.sendNotificationReport('Quilting Persediaan', 'Monthly Report Mesin - Quilting Finishing');
                                                  await dioService.sendNotificationReport('Produksi', 'Monthly Report Mesin - Quilting Finishing');

                                                  EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingQP = false;
                                                  });
                                                }
                                              } else if(res == 'NOK'){
                                                EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingQP = false;
                                                });
                                              }
                                            }

                                          }
                                      )
                                          :Row(
                                            children: [
                                              data['step_reportQP']=='1'? Text('Approved'):Text('Submitted'),
                                              SizedBox(width:10),
                                              GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportQP'],step: data['step_reportQP'],userLevel: int.parse(provider.userLevel))));
                                                    if(res == 'completed'){
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                  child: Icon(Icons.picture_as_pdf_outlined))
                                            ],
                                          )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

///Divan sandaran
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Divan Sandaran'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_mesinDS,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_mesinDS.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['mesinDS']}/${data['qty_mesinDS']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportDS']<1 && data['mesinDS']==data['qty_mesinDS']?
                                        child: data['mesinDS']!=data['qty_mesinDS']? data['reportDS']<1 ?Container():RaisedButton(
                                            child: isLoadingDS?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingDS = true;
                                              });

                                              var res = await dioService.createReportMesin('Divan Sandaran', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingDS = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    await dioService.sendNotificationReport('Divan Sandaran', 'Monthly Report Mesin - Quilting Finishing');
                                                    await dioService.sendNotificationReport('Produksi', 'Monthly Report Mesin - Quilting Finishing');

                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingDS = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingDS = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportDS']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportDS'],step: data['step_reportDS'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

/// Peer
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Peer'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_mesinPR,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_mesinPR.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['mesinPR']}/${data['qty_mesinPR']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportPR']<1 && data['mesinPR']==data['qty_mesinPR']?
                                        child: data['mesinPR']!=data['qty_mesinPR'] ? data['reportPR']<1 ? Container(): RaisedButton(
                                            child: isLoadingPR?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ): Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingPR = true;
                                              });

                                              var res = await dioService.createReportMesin('Peer', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingPR = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    await dioService.sendNotificationReport('Peer', 'Monthly Report Mesin - Quilting Finishing');
                                                    await dioService.sendNotificationReport('Produksi', 'Monthly Report Mesin - Quilting Finishing');

                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingPR = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingPR = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportPR']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportPR'],step: data['step_reportPR'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

/// spon
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Spon'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_mesinSP,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_mesinSP.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['mesinSP']}/${data['qty_mesinSP']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportSP']<1 ?
                                        child: data['mesinSP']!=data['qty_mesinSP'] ? data['reportSP']<1? Container(): RaisedButton(
                                            child: isLoadingSP?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingSP = true;
                                              });

                                              var res = await dioService.createReportMesin('Spon', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingSP = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    await dioService.sendNotificationReport('Spon', 'Monthly Report Mesin - Quilting Finishing');
                                                    await dioService.sendNotificationReport('Produksi', 'Monthly Report Mesin - Quilting Finishing');

                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingSP = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingSP = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportSP']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportSP'],step: data['step_reportSP'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

///kendaraan ekspedisi
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kendaraan Ekspedisi'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_kendaraanEK,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_kendaraanEK.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['kendaraanEK']}/${data['qty_kendaraanEK']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportEK']<1 && data['kendaraanEK']==data['qty_kendaraanEK']?
                                        child: data['kendaraanEK']!=data['qty_kendaraanEK']?data['reportEK']<1? Container():RaisedButton(
                                            child: isLoadingEK?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingEK = true;
                                              });

                                              var res = await dioService.createReportMesin('Ekspedisi', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingEK = false;
                                                });
                                              } else{
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingEK = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingEK = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportEK']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportEK'],step: data['step_reportEK'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

///kendaraan marketing
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kendaraan Operasional'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progress_kendaraanMK,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentage_kendaraanMK.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['kendaraanMK']}/${data['qty_kendaraanMK']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportMK']<1 && data['kendaraanMK']==data['qty_kendaraanMK']?
                                        child: data['kendaraanMK']!=data['qty_kendaraanMK']? data['reportMK']<1? Container():RaisedButton(
                                            child: isLoadingMK?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingMK = true;
                                              });

                                              var res = await dioService.createReportMesin('Marketing', user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingMK = false;
                                                });
                                              } else{
                                                if(res != null){
                                                  var write = await dioService.createPdfReportMesin(res);
                                                  if(write == 'OK'){
                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingMK = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingMK = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportMK']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: data['id_reportMK'],step: data['step_reportMK'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


///apar
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fire Extinguisher'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progressApar,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentageApar.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['apar']}/${data['qty_apar']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        ///data['reportAP']<1 && data['apar']==data['qty_apar']?

                                        child: data['apar']!=data['qty_apar']?data['reportAP']<1 ?Container():RaisedButton(
                                            child: isLoadingAP?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingAP = true;
                                              });

                                              var res = await dioService.createReportApar(user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingAP = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportApar(res);
                                                  if(write == 'OK'){
                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingAP = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingAP = false;
                                                  });
                                                }
                                              }





                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportAP']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportApar(id: data['id_reportAP'],step: data['step_reportAP'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
///hydarnt
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hydrant'),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:30,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(

                                            value: progressHydrant,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                            backgroundColor: Colors.grey[200],),

                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(percentageHydrant.toStringAsFixed(2)),
                                          Text('%'),
                                          Text(' (${data['hydrant']}/${data['qty_hydrant']}) ',style: TextStyle(color:Colors.blue),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex:30,
                                        //data['reportHY']<1 && data['hydrant']==data['qty_hydrant']?
                                        child: data['hydrant']!=data['qty_hydrant'] ?data['reportHY']<1 ?Container():RaisedButton(
                                            child: isLoadingHY?Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: CupertinoActivityIndicator(radius: 11,)),

                                              ],
                                            ):
                                            Text('Create report'),
                                            onPressed: ()async{
                                              setState(() {
                                                isLoadingHY = true;
                                              });

                                              var res = await dioService.createReportHydrant(user.uid);

                                              if(res == 'Exist'){
                                                EasyLoading.showInfo('Report Exist.',duration: Duration(seconds: 2));
                                                setState(() {
                                                  isLoadingHY = false;
                                                });
                                              } else {
                                                if(res != null){
                                                  var write = await dioService.createPdfReportHydrant(res);
                                                  if(write == 'OK'){
                                                    EasyLoading.showSuccess('Report created.',duration: Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadingHY = false;
                                                    });
                                                  }
                                                } else if(res == 'NOK'){
                                                  EasyLoading.showError('Server failed.',duration: Duration(seconds: 2));
                                                  setState(() {
                                                    isLoadingHY = false;
                                                  });
                                                }
                                              }

                                            }
                                        )
                                            :Row(
                                          children: [
                                            data['step_reportHY']=='1'? Text('Approved'):Text('Submitted'),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: ()async{
                                                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportApar(id: data['id_reportHY'],step: data['step_reportHY'],userLevel: int.parse(provider.userLevel))));
                                                  if(res == 'completed'){
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.picture_as_pdf_outlined))
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height:10)

                      ]
                  );
                }
                return Container();
              },
            ),

 */





          ],
        ),
      ),
    );
  }
  showYearList(context,_selectedDate){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container( // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) async{
                // close the dialog when year is selected.
                await Navigator.push(context, MaterialPageRoute(builder: (context)=>QualityObjectiveScreen(yearPicked: dateTime.year.toString(),)));

                //setState(() {
                  //yearPicked = dateTime.year.toString();
                //});
                Navigator.pop(context);

                print(dateTime.year);
                // Do something with the dateTime selected.
                // Remember that you need to use dateTime.year to get the year
              },
            ),
          ),
        );
      },
    );
  }
}


