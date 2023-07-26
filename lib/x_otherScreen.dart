import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/service_other.dart';
import 'package:mita/test_dummy.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_otherRequestComplete.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_requestOtherScreen.dart';
import 'package:mita/x_userApproveOtherScreen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class OtherScreen extends StatefulWidget {
  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  String keyword = '';
  bool iniTeknisi = false;
  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;

  Future getUserLevel() async {
    //final provider = Provider.of<AssetProvider>(context, listen: false);
    var userLevel = await dioService.getUserLevel(user.uid);

    if (userLevel['Level'] == "0" ||
        userLevel['Level'] == "1" ||
        userLevel['Level'] == "2") {
      if (mounted) {
        setState(() {
          iniTeknisi = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lainnya', style: (TextStyle(color: Colors.black))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestUtilityScreen(
                              idAsset: '1',
                              description: '2',
                              manufacture: '3',
                              model: '4',
                            )));
                //var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>TestDummy()));
                if (res != null) {
                  setState(() {});
                }
                dioService.sendNotificationOther('1', res);
              } else {
                showDialogError(
                    'Sudah melewati jam kerja 08:00 - 16.00. Coba lagi lain waktu.');
              }

              //Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample()));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: dioService.loadOtherRequest(''),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            //print(data['data'].length);
            //print(data['data'][1]['category']);

            return ListView.builder(
              itemCount: data['data'].length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, indexA) {
                var data1 = data['data'][indexA];
                //var dataDetail = data['dataDetail'][index];
                //print(data['data'][0]['dataDetail'].length);
                return StickyHeader(
                    header: data1['exist'] > 0
                        ? Material(
                            elevation: 1,
                            child: Container(
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      data1['category'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    content: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data['data'][indexA]['dataDetail'].length,
                      itemBuilder: (context, indexB) {
                        var data2 = data['data'][indexA]['dataDetail'][indexB];
                        final now = DateTime.now();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        //print('https://mita.balifoam.com/${data2['Image']}');
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    /*
                                  GestureDetector(
                                    onTap:(){
                                      if(data2['Image']!=''){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePreviewScreen(imageUrl: 'https://mita.balifoam.com/${data2['Image']}',)));

                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                          image: DecorationImage(
                                              image: data2['Image']!=''?NetworkImage('https://mita.balifoam.com/${data2['Image']}'):AssetImage('assets/images/no_image.png'),
                                              fit: BoxFit.cover
                                          ),
                                          border: Border.all(color: Colors.grey[400])
                                      ),

                                      height:MediaQuery.of(context).size.width/1.7,

                                    ),
                                  ),

                                   */
                                    FutureBuilder(
                                        future:
                                            dioService.loadImageOtherRequest(
                                                data2['ID_Request']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var img = snapshot.data;
                                            if (img['exist'] > 0) {
                                              //print(snapshot.data['dataDetail'][0]);
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (img['dataDetail']
                                                              [0] !=
                                                          '') {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImagePreviewScreen(
                                                                          imageUrl:
                                                                              'https://mita.balifoam.com/mobile/flutter/image_case/${img['dataDetail'][0]}',
                                                                        )));
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      12),
                                                              topRight:
                                                                  Radius.circular(
                                                                      12)),
                                                          image: DecorationImage(
                                                              image: img['dataDetail']
                                                                          [0] !=
                                                                      ''
                                                                  ? NetworkImage(
                                                                      'https://mita.balifoam.com/mobile/flutter/image_case/${img['dataDetail'][0]}')
                                                                  : AssetImage(
                                                                      'assets/images/no_image.png'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey[400])),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                    ),
                                                  ),
                                                  img['exist'] > 1
                                                      ? Container(
                                                          //color: Colors.blue.shade50,
                                                          height: 80,

                                                          child:
                                                              ListView.builder(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemCount:
                                                                      img['exist'] -
                                                                          1,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ImagePreviewScreen(
                                                                                        imageUrl: 'https://mita.balifoam.com/mobile/flutter/image_case/${img['dataDetail'][index + 1]}',
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              80 * 1.7,
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(image: img['dataDetail'][index + 1] != '' ? NetworkImage('https://mita.balifoam.com/mobile/flutter/image_case/${img['dataDetail'][index + 1]}') : AssetImage('assets/images/no_image.png'), fit: BoxFit.cover),
                                                                              border: Border.all(color: Colors.grey[300])),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                        )
                                                      : SizedBox.shrink(),
                                                ],
                                              );
                                            }
                                          }
                                          return Container();
                                        }),
                                    Positioned(
                                      //bottom: 10,
                                      child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight:
                                                      Radius.circular(12)),
                                              color: Colors.black
                                                  .withOpacity(0.1))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  color: Colors.grey,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://mita.balifoam.com/mobile/flutter/image_profile/${data2['imageUrl']}')))),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data2['Type'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    data2['ID_Request'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  if (formatter.format(now) ==
                                                      data2['Today'])
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: badges.Badge(
                                                        badgeColor: Colors.red,
                                                        shape: badges
                                                            .BadgeShape.square,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        toAnimate: false,
                                                        badgeContent: Text(
                                                          'NEW',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                              if (data2['Step'] == '6')
                                                Row(
                                                  children: [
                                                    SmoothStarRating(
                                                      rating: double.parse(
                                                          data2['Rating']),
                                                      isReadOnly: false,
                                                      size: 17,
                                                      color:
                                                          Colors.orangeAccent,
                                                      filledIconData:
                                                          Icons.star,
                                                      halfFilledIconData:
                                                          Icons.star_half,
                                                      defaultIconData:
                                                          Icons.star_border,
                                                      starCount: 5,
                                                      allowHalfRating: true,
                                                      spacing: 1.0,
                                                      borderColor: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  //height:160,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12)),
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 15,
                                            ),
                                            Text(data2['Requestor']),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.calendar_today,
                                              size: 15,
                                            ),
                                            Text(formatter.format(now) ==
                                                    data2['Today']
                                                ? 'Hari ini'
                                                : data2['Tanggal_Request']),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 15,
                                            ),
                                            Text(data2['Jam_Request']),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text('Location : '),
                                            Expanded(
                                                child: Text(
                                              data2['Location'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 3,
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text('Keluhan : '),
                                            Expanded(
                                                child: Text(
                                              data2['Description'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 3,
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 5),

                                        int.parse(data2['Step']) >= 5
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Solusi : '),
                                                  Expanded(
                                                      child: Text(
                                                    data2['Solution'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    maxLines: 3,
                                                  )),
                                                ],
                                              )
                                            : SizedBox.shrink(),

                                        int.parse(data2['Step']) >= 5
                                            ? Column(
                                                children: [
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        'Close by ${data2['Technician']} pada ${data2['Tanggal_Selesai']}',
                                                        maxLines: 2,
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink(),

                                        ///hanya teknisi yang liat
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            int.parse(data2['Step']) < 5 &&
                                                    iniTeknisi
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text(
                                                          'Selesai',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .blue),
                                                        onPressed: () async {
                                                          //print(data2['ID_Request']);
                                                          provider.getSelectedIdCaseOther(
                                                              data2[
                                                                  'ID_Request']);
                                                          var res = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          RequestOtherCompleteScreen()));
                                                          if (res ==
                                                              'completed') {
                                                            setState(() {});
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                            int.parse(data2['Step']) == 5 &&
                                                    data2['ID_Requestor'] ==
                                                        user.uid
                                                ? ElevatedButton(
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue),
                                                    onPressed: () async {
                                                      //print(data2['ID_Request']);
                                                      //provider.getSelectedIdCaseOther(data2['ID_Request']);
                                                      var res =
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UserApproveOtherScreen(
                                                                            idRequest:
                                                                                data2['ID_Request'],
                                                                          )));
                                                      print(res);
                                                      if (res == 'done') {
                                                        setState(() {});
                                                      }
                                                    },
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );

                        Padding(
                          padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              top: indexB == 0 ? 12 : 0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: data2['Image'] != ''
                                                  ? NetworkImage(
                                                      'https://mita.balifoam.com/${data2['Image']}')
                                                  : AssetImage(
                                                      'assets/images/no_image.png'),
                                              fit: BoxFit.cover))),
                                  Row(
                                    children: [
                                      Text(data2['ID_Request']),
                                      if (formatter.format(now) ==
                                          data2['Today'])
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: badges.Badge(
                                            badgeColor: Colors.red,
                                            shape: badges.BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            toAnimate: false,
                                            badgeContent: Text(
                                              'NEW',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.blueGrey,
                                  ),
                                  Text(
                                    data2['Type'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),

                                  Row(
                                    children: [
                                      Text('Keluhan : '),
                                      Expanded(
                                          child: Text(
                                        data2['Description'],
                                        style: TextStyle(color: Colors.black),
                                        maxLines: 3,
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 15,
                                      ),
                                      Text(data2['Requestor']),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 15,
                                      ),
                                      Text(formatter.format(now) ==
                                              data2['Today']
                                          ? 'Hari ini'
                                          : data2['Tanggal_Request']),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 15,
                                      ),
                                      Text(data2['Jam_Request']),
                                      SizedBox(width: 10),
                                      data2['Step'] == '5'
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.design_services,
                                                  size: 15,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  data2['Technician'],
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (data2['Image'] != '') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImagePreviewScreen(
                                                        imageUrl:
                                                            'https://mita.balifoam.com/${data2['Image']}',
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: data2['Image'] != ''
                                                    ? NetworkImage(
                                                        'https://mita.balifoam.com/${data2['Image']}')
                                                    : AssetImage(
                                                        'assets/images/no_image.png'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  ),

                                  data2['Step'] == '5'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Solusi : '),
                                            Expanded(
                                                child: Text(
                                              data2['Solution'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 3,
                                            )),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  ///hanya teknisi yang liat
                                  data2['Step'] != '5' && iniTeknisi
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child: Text(
                                                'Selesai',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue),
                                              onPressed: () async {
                                                //print(data2['ID_Request']);
                                                provider.getSelectedIdCaseOther(
                                                    data2['ID_Request']);
                                                var res = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RequestOtherCompleteScreen()));
                                                if (res == 'finished') {
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ));
              },
            );
          }

          return Container();
        },
      ),
    );
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
}
