import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_otherScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_reportApar.dart';
import 'package:mita/x_reportMesinProduksi.dart';
import 'package:mita/x_userApproveOtherScreen.dart';
import 'package:mita/x_userApproveAllScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import 'card.dart';

class MyRequestScreen extends StatefulWidget {
  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;

  double closeHeight = 0.0;
  bool minMax = false;
  bool isLoading = false;
  String address = 'https://mita.balifoam.com/mobile/flutter/image_profile';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Summary',
          style: TextStyle(color: Colors.black),
        ),
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
      body: FutureBuilder(
          future: dioService.loadMyRequest(user.uid, provider.userLevel),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final now = DateTime.now();
              final DateFormat formatter = DateFormat('yyyy-MM-dd');
              //print(snapshot.data['data'][1]['dataDetail'][0]['ID_Request']);
              return CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: [
//your request
                  if (snapshot.data['data'][0]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          color: Colors.blueGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'IN PROGRESS (${snapshot.data['data'][0]['exist']})',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: 1),
                    ),
                  if (snapshot.data['data'][0]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                provider.getSelectedIdCase(snapshot.data['data']
                                    [0]['dataDetail'][index]['ID_Request']);
                                Navigator.pushNamed(
                                    context, CaseDetailScreen.route);
                              },
                              child: ServiceCard(
                                assetImage: snapshot.data['data'][0]
                                    ['dataDetail'][index]['Image'],
                                userImage: snapshot.data['data'][0]
                                    ['dataDetail'][index]['imageUrl'],
                                requestor: snapshot.data['data'][0]
                                    ['dataDetail'][index]['Requestor'],
                                today: snapshot.data['data'][0]['dataDetail']
                                    [index]['Today'],
                                idRequest: snapshot.data['data'][0]
                                    ['dataDetail'][index]['ID_Request'],
                                description: snapshot.data['data'][0]
                                    ['dataDetail'][index]['Description'],
                                manufacture: snapshot.data['data'][0]
                                    ['dataDetail'][index]['Manufacture'],
                                model: snapshot.data['data'][0]['dataDetail']
                                    [index]['Model'],
                                no: snapshot.data['data'][0]['dataDetail']
                                    [index]['No'],
                                mType: snapshot.data['data'][0]['dataDetail']
                                    [index]['Maintenance_Type'],
                                step: snapshot.data['data'][0]['dataDetail']
                                    [index]['Step'],
                                timeRequest: snapshot.data['data'][0]
                                    ['dataDetail'][index]['Time_Request'],
                                type: snapshot.data['data'][0]['dataDetail']
                                    [index]['Type'],
                                problem: snapshot.data['data'][0]['dataDetail']
                                    [index]['Problem'],
                                tnow: formatter.format(now),
                              )),
                        );
                      }, childCount: snapshot.data['data'][0]['exist']),
                    ),
                  if (snapshot.data['data'][0]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SizedBox(height: 10);
                      }, childCount: 1),
                    ),

                  ///sign here
                  if (snapshot.data['data'][1]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Column(
                          children: [
                            Container(
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'COMPLETED MAINTENANCE (${snapshot.data['data'][1]['exist']})',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SIGN HERE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      minMax
                                          ? Icons.arrow_back_ios_rounded
                                          : Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                    ),
                                    onPressed: () {
                                      //print(minMax);
                                      if (minMax) {
                                        setState(() {
                                          closeHeight = 0;
                                          minMax = false;
                                        });
                                      } else {
                                        setState(() {
                                          closeHeight = 70;
                                          minMax = true;
                                        });
                                      }
                                    },
                                  ),
                                  minMax
                                      ? isLoading
                                          ? Row(
                                              children: [
                                                CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text('Please wait..',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontStyle:
                                                            FontStyle.italic))
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                //print('ok');
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                var res = "";
                                                //Future.delayed(Duration(seconds:1),()async{
                                                res = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserApproveAllScreen()));

                                                setState(() {
                                                  isLoading = false;
                                                });

                                                //});
                                                //request
                                                if (res == "done") {
                                                  EasyLoading.showSuccess(
                                                      'Terima kasih atas kerjasamanya !!',
                                                      duration:
                                                          Duration(seconds: 2));

                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(seconds: 3), () {
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Click to',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                                  Text('SIGN ALL',
                                                      style: TextStyle(
                                                          color: Colors.blue)),
                                                ],
                                              ),
                                            )
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                          ],
                        );
                      }, childCount: 1),
                    ),
                  if (snapshot.data['data'][1]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                              onTap: () async {
                                provider.getSelectedIdCase(snapshot.data['data']
                                    [1]['dataDetail'][index]['ID_Request']);
                                var res = await Navigator.pushNamed(
                                    context, CaseDetailScreen.route);

                                if (res == null) {
                                  setState(() {});
                                }
                              },
                              child: ServiceCard(
                                assetImage: snapshot.data['data'][1]
                                    ['dataDetail'][index]['Image'],
                                userImage: snapshot.data['data'][1]
                                    ['dataDetail'][index]['imageUrl'],
                                requestor: snapshot.data['data'][1]
                                    ['dataDetail'][index]['Requestor'],
                                today: snapshot.data['data'][1]['dataDetail']
                                    [index]['Today'],
                                idRequest: snapshot.data['data'][1]
                                    ['dataDetail'][index]['ID_Request'],
                                description: snapshot.data['data'][1]
                                    ['dataDetail'][index]['Description'],
                                manufacture: snapshot.data['data'][1]
                                    ['dataDetail'][index]['Manufacture'],
                                model: snapshot.data['data'][1]['dataDetail']
                                    [index]['Model'],
                                no: snapshot.data['data'][1]['dataDetail']
                                    [index]['No'],
                                mType: snapshot.data['data'][1]['dataDetail']
                                    [index]['Maintenance_Type'],
                                step: snapshot.data['data'][1]['dataDetail']
                                    [index]['Step'],
                                timeRequest: snapshot.data['data'][1]
                                    ['dataDetail'][index]['Time_Request'],
                                type: snapshot.data['data'][1]['dataDetail']
                                    [index]['Type'],
                                problem: snapshot.data['data'][1]['dataDetail']
                                    [index]['Problem'],
                                tnow: formatter.format(now),
                              )),
                        );
                      }, childCount: snapshot.data['data'][1]['exist']
                          // childCount: 2

                          ),
                    ),
                  if (snapshot.data['data'][1]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SizedBox(height: 10);
                      }, childCount: 1),
                    ),

                  //perbaikan other
                  if (snapshot.data['data'][3]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Column(
                          children: [
                            Container(
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'OTHER SERVICE (${snapshot.data['data'][3]['exist']})',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CONFIRM HERE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }, childCount: 1),
                    ),
                  if (snapshot.data['data'][3]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtherScreen()));
                              if (res == null) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Request Form',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      'Perbaikan Utility',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(snapshot.data['data'][3]['dataDetail']
                                        [index]['ID_Request']),
                                    Text(
                                        'Request on ${snapshot.data['data'][3]['dataDetail'][index]['Time_Request']}'),
                                    SizedBox(height: 10),
                                    Text(
                                        snapshot.data['data'][3]['dataDetail']
                                            [index]['Type'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Problem : ${snapshot.data['data'][3]['dataDetail'][index]['Description']}'),
                                    Text(
                                        'Lokasi : ${snapshot.data['data'][3]['dataDetail'][index]['Location']}'),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      child: Text(
                                        'Confirm Selesai',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        //print(data2['ID_Request']);
                                        //provider.getSelectedIdCaseOther(data2['ID_Request']);
                                        var res = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserApproveOtherScreen(
                                                      idRequest: snapshot
                                                                  .data['data']
                                                              [3]['dataDetail']
                                                          [index]['ID_Request'],
                                                    )));
                                        print(res);
                                        if (res == 'done') {
                                          setState(() {});
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }, childCount: snapshot.data['data'][3]['exist']),
                    ),
                  if (snapshot.data['data'][3]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SizedBox(height: 10);
                      }, childCount: 1),
                    ),

                  //montly report
                  if (snapshot.data['data'][2]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Column(
                          children: [
                            Container(
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'REPORTS (${snapshot.data['data'][2]['exist']})',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SIGN HERE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }, childCount: 1),
                    ),
                  if (snapshot.data['data'][2]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              //provider.getSelectedIdCase(snapshot.data['data'][3]['dataDetail'][index]['ID_Report']);
                              //Navigator.pushNamed(context, CaseDetailScreen.route);
                              var idReport = snapshot.data['data'][2]
                                  ['dataDetail'][index]['ID_Report'];
                              if (RegExp(r'RA').hasMatch(idReport) ||
                                  RegExp(r'RH').hasMatch(idReport)) {
                                ///untuk HRD
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportApar(
                                              id: snapshot.data['data'][2]
                                                      ['dataDetail'][index]
                                                  ['ID_Report'],
                                              step: '0',
                                              userLevel:
                                                  int.parse(provider.userLevel),
                                            )));
                                if (res == 'completed') {
                                  setState(() {});
                                }
                              } else if (RegExp(r'RM').hasMatch(idReport)) {
                                ///untuk produksi
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReportMesinProduksi(
                                              id: snapshot.data['data'][2]
                                                      ['dataDetail'][index]
                                                  ['ID_Report'],
                                              step: '0',
                                              userLevel:
                                                  int.parse(provider.userLevel),
                                            )));
                                if (res == 'completed') {
                                  setState(() {});
                                }
                              } else if (RegExp(r'RE').hasMatch(idReport)) {
                                ///untuk ekspedisi
                              } else if (RegExp(r'RS').hasMatch(idReport)) {
                                ///untuk marketing
                              }

/*
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportMesinProduksi(id: snapshot.data['data'][2]['dataDetail'][index]['ID_Report'],step: '0',userLevel: int.parse(provider.userLevel),)));
                          if(res == 'completed'){
                            setState(() {

                            });
                          }

 */
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.yellow.withOpacity(0.2),
                                        Colors.orangeAccent
                                      ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Monthly Report',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        Text(
                                          'Summary Report Asset',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(snapshot.data['data'][2]
                                            ['dataDetail'][index]['ID_Report']),
                                        Text(
                                            'Submitted on ${snapshot.data['data'][2]['dataDetail'][index]['Time_Create']}'),
                                      ],
                                    ),
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 35,
                                      color: Colors.blueGrey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }, childCount: snapshot.data['data'][2]['exist']),
                    ),
                  if (snapshot.data['data'][2]['exist'] > 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SizedBox(height: 10);
                      }, childCount: 1),
                    ),
                ],
              );
            }
            return Center(
              child: JumpingDotsProgressIndicator(
                  fontSize: 40.0, color: Colors.orange),
            ); //loading
          }),
    );
  }
}
