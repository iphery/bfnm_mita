import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class EditUserScreen extends StatefulWidget {
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  DioService dioService = DioService();
  int aktif = -1;
  String category = '';
  String keyword = '';

  var textFieldController = TextEditingController();
  bool textFieldIconShow = false;
  FocusNode focusTextField = FocusNode();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

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
          'Edit User',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: FutureBuilder(
              future: dioService.loadEmployeeCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  aktif = -1;
                                  category = '';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(color: Colors.grey[300]),
                                    color: aktif == -1
                                        ? Colors.teal.withOpacity(0.2)
                                        : Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('All'),
                                ),
                              ),
                            ),
                          );
                        }, childCount: 1),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  aktif = index;
                                  category = snapshot.data['data'][0]
                                      ['dataDetail'][index]['divisi'];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(color: Colors.grey[300]),
                                    color: index == aktif
                                        ? Colors.teal.withOpacity(0.2)
                                        : Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data['data'][0]
                                      ['dataDetail'][index]['divisi']),
                                ),
                              ),
                            ),
                          );
                        }, childCount: snapshot.data['data'][0]['exist']),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.grey[200],
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
          ),
          Expanded(
            child: FutureBuilder(
              future: dioService.loadEmployeeDetail(category, keyword),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data['data'][0];
                  //print(snapshot.data['data'][0]['dataDetail'][1]);
                  //print(snapshot.data['data'][1]['dataDetail'][0]['Step']);
                  if (data['exist'] > 0) {
                    return ListView.builder(
                      itemCount: data['exist'],
                      itemBuilder: (context, index) {
                        var dataDetail = data['dataDetail'][index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: Colors.grey[200])),
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
                                        Text(dataDetail['nama']),
                                        SizedBox(height: 5),
                                        Text(dataDetail['divisi'],
                                            style:
                                                TextStyle(color: Colors.blue))
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          String msg =
                                              'Pilih - ${dataDetail['nama']} - sebagai user untuk asset ini ?';
                                          showDialogMsg(
                                              msg,
                                              provider.selectedIdAsset,
                                              dataDetail['nama']);
                                          //print(dataDetail['nama']);
                                        },
                                        child: Icon(Icons.select_all_outlined))
                                  ],
                                ),
                              )),
                        );
                      },
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tidak ada data.'),
                      ),
                    ],
                  );
                }
                return Center(
                  child: JumpingDotsProgressIndicator(
                      fontSize: 40.0, color: Colors.orange),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  showDialogMsg(message, idAsset, userName) {
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
                  var res = await dioService.updateUserName(idAsset, userName);
                  if (res == 'OK') {
                    EasyLoading.showSuccess('Update berhasil.',
                        duration: Duration(seconds: 2));
                    Navigator.pop(context);
                    Navigator.pop(context, 'updated');
                    Future.delayed(Duration(seconds: 3), () {});
                  } else {
                    EasyLoading.showError('Update gagal.',
                        duration: Duration(seconds: 2));
                    Navigator.pop(context);
                    Future.delayed(Duration(seconds: 3), () {});
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
