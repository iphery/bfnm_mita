import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class SearchDetailScreen extends StatefulWidget {
  static const route = '/assetdetailscreen';

  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  ScrollController _controller;
  bool _showAppbar = false;

  ApiService service = ApiService();
  DioService dioService = DioService();

  User user = FirebaseAuth.instance.currentUser;
  var textFieldController = TextEditingController();
  bool textFieldIconShow = false;
  FocusNode focusTextField = FocusNode();

  StreamSubscription internetconnection;
  bool isoffline = false;

  String keyword = '';

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
              setState(() {
                keyword = '';
              });
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
                  hintText: "Search description",

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
            ? SingleChildScrollView(
                child: FutureBuilder(
                  future: dioService.getAssetDetailSearch(
                      provider.selectedIdAsset, keyword),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data['exist'] > 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data['exist'],
                          itemBuilder: (BuildContext context, int index) {
                            var data = snapshot.data['dataDetail'][index];

                            return InkWell(
                              onTap: () {
                                //EasyLoading.show(maskType: EasyLoadingMaskType.custom);
                                //provider.getSelectedCase(data);
                                provider.getSelectedIdCase(data['ID_Request']);

                                var upd = Navigator.pushNamed(
                                    context, CaseDetailScreen.route);
                                // ignore: unrelated_type_equality_checks
                                if (upd == 'update') {
                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey[200]))
                                    //borderRadius: BorderRadius.all(Radius.circular(12)),
                                    //color: Colors.green
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 18, top: 8, left: 8, right: 8),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    data['ID_Request'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  if (data[
                                                          'Maintenance_Type'] ==
                                                      "CM")
                                                    Icon(
                                                      Icons.build_circle,
                                                      color: Colors.red,
                                                      size: 18,
                                                    )
                                                ],
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .handyman_outlined,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
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
                                                            size: 23,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                              data['Requestor'])
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            data['Problem'],
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Sementara belum ada data.'),
                          ),
                        ],
                      );
                    }
                    return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: JumpingDotsProgressIndicator(
                              fontSize: 50.0, color: Colors.orange),
                        ));
                  },
                ),
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

  _customAppBarDefault() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () {
          setState(() {
            keyword = '';
          });
          Navigator.pop(context);
        },
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
/*
  Future loadList(id_asset, keyword) {
    Future<List<Cases>> futureCases = service.getCasesPreview(id_asset, keyword);
    futureCases.then((casesList) {
      setState(() {
        this.casesPreviewList = casesList;
      });
    });
    return futureCases;
  }

  Future loadMaintenanceStatus(id_asset) {
    Future<List<MaintenanceStatus>> futureMaintenanceStatus = service.getMaintenanceStatus(id_asset);
    futureMaintenanceStatus.then((maintenanceStatus) {
      setState(() {
        this.maintenanceStatusList = maintenanceStatus;
      });
    });
    return futureMaintenanceStatus;
  }

 */

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
}
