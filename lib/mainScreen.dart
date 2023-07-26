import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mita/api_service.dart';
import 'package:mita/checklist/checklist_pemanasan_genset.dart';
import 'package:mita/model/assets.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_OtherScreen.dart';
import 'package:mita/x_assetDetailScreen.dart';
import 'package:mita/x_assetListScreen.dart';
import 'package:mita/x_calcTank.dart';
import 'package:mita/x_carouselScreen.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_edpScreen.dart';
import 'package:mita/x_myJobScreen.dart';
import 'package:mita/x_myRequestScreen.dart';
import 'package:mita/x_outstandingCMScreen.dart';
import 'package:mita/x_outstandingScreen.dart';
import 'package:mita/x_peerScreen.dart';
import 'package:mita/x_profileScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_reportMesinProduksi.dart';
import 'package:mita/x_reportScreen.dart';
import 'package:mita/x_rutinScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const route = '/mainscreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  List pathList = [];
  String _scanBarcodeAsset = 'Unknown';
  bool _isLoading = false;

  ApiService service = ApiService();
  DioService dioService = DioService();

  List<Assets> scanAsset = [];
  List<Assets> assetFromNotif = [];

  User user = FirebaseAuth.instance.currentUser;
  String path;
  File imageFile;

  String userLevelX = '';

  StreamSubscription internetconnection;
  bool isoffline = false;

  bool _visible = true;
  bool _left = false;

  double thisVer = 1.3;

  String address = 'https://mita.balifoam.com/mobile/flutter/image_group';

  ScrollController _controllerComputer;

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      var data = await dioService.findIdAsset(barcodeScanRes);

      if (data['count'] == 0) {
        showDialogX();
      } else if (data['count'] == 1) {
        final provider = Provider.of<AssetProvider>(context, listen: false);
        provider.getSelectedIdAsset(barcodeScanRes);
        Navigator.pushNamed(context, AssetDetailScreen.route);
      }
    }
  }

  Future getUserToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      dioService.getUserToken(token, user.uid);
    });
  }

  Future getVersion() async {
    var ver = await dioService.checkVersion();
    if (double.parse(ver) > thisVer) {
      showDialogVersion();
    }
  }

  Future getUserLevel() async {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    var userLevel = await dioService.getUserLevel(user.uid);
    provider.getUserLevel(userLevel['Level']);
    provider.getUserDivisi(userLevel['divisi']);
    if (mounted) {
      setState(() {
        userLevelX = userLevel['Level'].toString();
      });
    }

    ///jika level 6 cek status mobil operasional, jika 5 mobil ekspedisi
    ///
    if (userLevel['Level'] == "5") {
      var info = await dioService.getUserEkspedisiCar();
      if (info != 0) {
        showModalReminderCarEkspedisi(context, info);
      }
    } else if (userLevel['Level'] == "6") {
      var info = await dioService.getUserOperasionalCar(user.uid);

      if (info != 0) {
        showModalReminderCarOperasional(context, info);
      }
    } else if (userLevel['Level'] == "0" ||
        userLevel['Level'] == "1" ||
        userLevel['Level'] == "2") {
      var info = await dioService.getNextScheduleCount();
      //print(info);
      if (info != 0) {
        //showModalReminderTeknisi(context, info);
      }
    } else if (userLevel['Level'] == "3") {
      var info = await dioService.getNextScheduleITCount();
      //print(info);
      if (info != 0) {
        //showModalReminderEDP(context, info);
      }
    }
  }
/*
  scanComplete(idCase)async{
    //--
    var data = await dioService.findIdAssetfromIdCase(idCase);

    if(data['count']==0){

    } else if(data['count']==1) {

      assetFromNotif = [];
      assetFromNotif.add(Assets(
          id_asset: data['data']['ID_Asset'],
          description: data['data']['Description'],
          manufacture: data['data']['Manufacture'],
          model: data['data']['Model'],
          user: data['data']['User'],
          location: data['data']['Location'],
          available: data['data']['Available'],
          reserve: data['data']['Reserve'],
          image: data['data']['Image'],
          userImage: data['data']['Profile_Image'],
          type: data['data']['Type'],
          based: data['data']['Based'],
          kelas: data['data']['Class']
      ));
      final provider = Provider.of<AssetProvider>(context, listen:false);
      provider.getSelectedAsset(assetFromNotif[0]);
      provider.getSelectedIdCase(idCase);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CaseDetailScreen()));
    }
    //--
  }

 */

  @override
  void initState() {
    EasyLoading.dismiss();
    final provider = Provider.of<AssetProvider>(context, listen: false);

    ///test notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'keep.xml',
                  styleInformation: BigTextStyleInformation('')),
            ));
      }
      if (message.data['case_id'] == 'notification') {
        getUserLevel();
      } else if (message.data['case_id'] == 'report') {
        Future(() {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRequestScreen()));
        });
      } else if (message.data['case_id'] == 'genset') {
        Future(() {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>PemanasanGenset()));
        });
      } else if (message.data['case_id'] == 'request_other') {
        Future(() {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherScreen()));
        });
      } else if (message.data['case_id'] == 'report_peer') {
        Future(() {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportPeerScreen()));
        });
      } else {
        //provider.getSelectedIdCase(message.data['case_id']);

        Future(() {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>CaseDetailScreen()));
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print('A new onMessageOpenedApp event was published!');

      if (message.data['case_id'] == 'notification') {
        getUserLevel();
      } else if (message.data['case_id'] == 'report') {
        Future(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyRequestScreen()));
        });
      } else if (message.data['case_id'] == 'genset') {
        Future(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PemanasanGenset()));
        });
      } else if (message.data['case_id'] == 'request_other') {
        Future(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OtherScreen()));
        });
      } else {
        provider.getSelectedIdCase(message.data['case_id']);

        Future(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CaseDetailScreen()));
        });
      }
    });

    ///

    getVersion();

    ///jika saya operasionl (level 6)
    ///dipakai nanti
    getUserLevel();

    //provider.loadUser(user.uid);
    getUserToken();

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

    _controllerComputer = ScrollController();
    _controllerComputer.addListener(_scrollListenerComputer);

    super.initState();
  }

  _scrollListenerComputer() {
    print(_controllerComputer.position.pixels);
    if (_controllerComputer.position.pixels >= 40 &&
        _controllerComputer.position.userScrollDirection ==
            ScrollDirection.reverse) {
      setState(() {
        _visible = false;
        //_showAppbar = true;
      });
    }
    if (_controllerComputer.position.pixels >= 0 &&
        _controllerComputer.position.userScrollDirection ==
            ScrollDirection.reverse) {
      setState(() {
        _left = true;
        //_showAppbar = true;
      });
    } else if (_controllerComputer.position.pixels < 100 &&
        _controllerComputer.position.userScrollDirection ==
            ScrollDirection.forward) {
      setState(() {
        _visible = true;
        _left = false;
      });
    }
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
          backgroundColor: Colors.grey[200],
          /*
        appBar: AppBar(
          flexibleSpace: Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ///logo
                new Image.asset(
                  "assets/images/logo3.png",
                  height: 60.0,
                  width: 60.0,
                ),

                FutureBuilder(
                  future: provider.loadUser(user.uid),
                  builder: (context, snapshot){

                    if(snapshot.hasData){
                      var data = snapshot.data;

                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Text('Welcome ${provider.userDetail[0].name}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, ProfileScreen.route);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color: Colors.white, width: 2),
                                    image: DecorationImage(
                                        image: data['imageUrl'] != ''?

                                        NetworkImage('https://mita.balifoam.com/mobile/flutter/image_profile/${data['imageUrl']}')
                                            : AssetImage('assets/images/avatar.png'),
                                        fit: BoxFit.cover

                                    )
                                ),

                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: 20.0,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,

        ),

         */
          body: !isoffline
              ? SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
/*
              Material(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ///logo
                      new Image.asset(
                        "assets/images/logo3.png",
                        height: 60.0,
                        width: 60.0,
                      ),

                      FutureBuilder(
                        future: provider.loadUser(user.uid),
                        builder: (context, snapshot){

                          if(snapshot.hasData){
                            var data = snapshot.data;

                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //Text('Welcome ${provider.userDetail[0].name}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, ProfileScreen.route);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          border: Border.all(color: Colors.white, width: 2),
                                          image: DecorationImage(
                                              image: data['imageUrl'] != ''?

                                              NetworkImage('https://mita.balifoam.com/mobile/flutter/image_profile/${data['imageUrl']}')
                                                  : AssetImage('assets/images/avatar.png'),
                                              fit: BoxFit.cover

                                          )
                                      ),

                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(
                            child: JumpingDotsProgressIndicator(
                              fontSize: 20.0,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),


 */

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
/*
                          setState(() {
                            _isLoading = true;
                          });

 */
                              await scanQR();
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.blueGrey.withOpacity(0.5),
                                      Colors.blueAccent.withOpacity(0.5)
                                    ])),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Scan QR Code untuk temukan Asset',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///carousel
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width / 1.7,
                            child: FutureBuilder(
                              future: provider.loadCarouselImages(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = provider.carouselImages;

                                  return Stack(
                                    children: [
                                      CarouselSlider.builder(
                                          itemCount: data.length,
                                          itemBuilder:
                                              (context, int index, realIdx) {
                                            //DocumentSnapshot sliderImage = snapshot.data[index];
                                            var dataDetail = data[index]['Url'];

                                            return ClipRRect(
                                              //borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              child: Image.network(
                                                  'https://mita.balifoam.com/mobile/flutter/image_carousel/${dataDetail}',
                                                  fit: BoxFit.cover,
                                                  width: 1000.0),
                                            );
                                          },
                                          options: CarouselOptions(
                                              viewportFraction: 1,
                                              initialPage: 0,
                                              autoPlay: true,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,

                                              //aspectRatio: 1.0,
                                              onPageChanged: (int i,
                                                  carouselPageChangedReason) {
                                                if (mounted) {
                                                  setState(() {
                                                    _index = i;
                                                  });
                                                }
                                              })),
                                      Positioned(
                                        bottom: 10,
                                        child: DotsIndicator(
                                          dotsCount: data.length,
                                          position: _index.toDouble(),
                                          decorator: DotsDecorator(
                                            size: const Size.square(6.0),
                                            activeSize: const Size(12.0, 6.0),
                                            activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          Positioned(
                              top: 10,
                              left: 10,
                              child: FutureBuilder(
                                future: provider.loadUser(user.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data;

                                    return Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Text('Welcome ${provider.userDetail[0].name}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, ProfileScreen.route);
                                            },
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  image: DecorationImage(
                                                      image: data['imageUrl'] !=
                                                              ''
                                                          ? CachedNetworkImageProvider(
                                                              'https://mita.balifoam.com/mobile/flutter/image_profile/${data['imageUrl']}')
                                                          //NetworkImage('https://mita.balifoam.com/mobile/flutter/image_profile/${data['imageUrl']}')
                                                          : AssetImage(
                                                              'assets/images/avatar.png'),
                                                      fit: BoxFit.cover)),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: JumpingDotsProgressIndicator(
                                      fontSize: 20.0,
                                    ),
                                  );
                                },
                              )),
                          if (userLevelX == '0')
                            Positioned(
                                top: 180,
                                right: 20,
                                child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CarouselScreen()));
                                    },
                                    child: Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                      size: 30,
                                    )))
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      ///menu
                      Container(
                        height: MediaQuery.of(context).size.width * 0.70,
                        //color: Colors.yellow,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'K';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            '$address/bmw.png'),
                                                    //NetworkImage('$address/bmw.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Kendaraan')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'MP';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            '$address/mesin.png'),
                                                    //NetworkImage('$address/mesin.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Mesin')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'AC';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            '$address/ac.png'),
                                                    //NetworkImage('$address/ac.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('AC')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'PC';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            '$address/pc.png'),
                                                    //NetworkImage('$address/pc.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Komputer')
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'AP';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            '$address/apar.png'),
                                                    //NetworkImage('$address/apar.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Fire Safety')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String category = 'UT';
                                        provider.getSelectedCategory(category);
                                        Navigator.pushNamed(
                                            context, AssetListScreen.route);
                                        /*
                                if(int.parse(userLevelX)<=3){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PemanasanGenset()));

                                }else{
                                  //showDialogError('ME personel only.');
                                  showDialogAccess();
                                }

                                 */
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        '$address/genset.png'),
                                                    //NetworkImage('$address/genset.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Power')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
//                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestOtherScreen()));

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherScreen()));
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '$address/lainnya.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Utility')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalMenu(context);
                                        /*
                                if(int.parse(userLevelX)<=1){
                                  ///ini untuk spv ME
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen()));

                                } else if(int.parse(userLevelX)==2){
                                  ///ini untuk EDP report

                                } else{
                                  //showDialogError('ME personel only.');
                                  showDialogAccess();
                                }

                                 */
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.grey[100],
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: Colors.grey[300])
                                            ]),
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        '$address/other_menu.png'),
                                                    //NetworkImage('$address/other_menu.png'),
                                                    fit: BoxFit.contain)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Lainnya')
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),

                      FutureBuilder(
                        future: dioService.getPreviewOutstanding(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var cm = snapshot.data['data'][0];
                            var pm = snapshot.data['data'][1];
                            var pc = snapshot.data['data'][2];
                            var ctn = snapshot.data['data'][3];
                            var reminder = snapshot.data['data'][4];
                            var ut = snapshot.data['data'][5];
                            var cnt = snapshot.data['data'][6]['dataDetail'];

                            return Column(children: [
                              if (cm['exist'] > 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Outstanding',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OutstandingCMScreen()));
                                              },
                                              child: Text(
                                                  'Lihat semua (${cnt['outstanding']})',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.lightBlue)))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.green.withOpacity(0.3),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.builder(
                                          itemCount: cm['exist'],
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = cm['dataDetail'][index];
                                            final now = DateTime.now();
                                            final DateFormat formatter =
                                                DateFormat('yyyy-MM-dd');
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    provider.getSelectedIdCase(
                                                        data['ID_Request']);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CaseDetailScreen()));
                                                  },
                                                  child: Container(
                                                    //height: 100,
                                                    //color: Colors.green.withOpacity(0.3),

                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              height: 80,
                                                              width: 120,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              8),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              8)),
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  image: DecorationImage(
                                                                      image: data['Image'] ==
                                                                              null
                                                                          ? AssetImage(
                                                                              'assets/images/no_image.png')
                                                                          : NetworkImage(
                                                                              'https://balifoam.com/mita/mobile/flutter/image_asset/${data['Image']}'),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                            //if(formatter.format(now) == data['Today'])
                                                            if (int.parse(data[
                                                                    'Step']) <
                                                                2)
                                                              Positioned(
                                                                top: 0,
                                                                left: 0,
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      //width:40,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(8)),
                                                                          color: Colors.red,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: Colors.black12,
                                                                                spreadRadius: 1)
                                                                          ]),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child: Center(
                                                                            child: Text(
                                                                          'NEW',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12),
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                        Container(
                                                          //height: 130,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          8)),
                                                              color:
                                                                  Colors.white),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    if (data[
                                                                            'Type'] !=
                                                                        'K')
                                                                      Text(
                                                                          data[
                                                                              'Description'],
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    if (data[
                                                                            'Type'] ==
                                                                        'K')
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Text(
                                                                            '${data['Class']} ',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child: data['Model'] == null
                                                                                ? Text(
                                                                                    '${data['Manufacture']}',
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  )
                                                                                : Text(
                                                                                    '${data['Manufacture']} ${data['Model']}',
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  )),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .person_outline,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          data[
                                                                              'Requestor'],
                                                                          style:
                                                                              TextStyle(color: Colors.blue),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .calendar_today,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          data[
                                                                              'Date_Request'],
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )),
                                                                        //Text('ddd dddd kddkd dkdkkd kkdkddk')
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .watch_later_outlined,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        Text(
                                                                            data[
                                                                                'Time_Request'],
                                                                            style:
                                                                                TextStyle(fontSize: 12))
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                              if (pm['exist'] > 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Maintenance',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>OutstandingScreen(1)));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RutinScreen()));
                                              },
                                              child: Text(
                                                  'Lihat semua (${cnt['maintenance']})',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.lightBlue)))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          itemCount: pm['exist'],
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = pm['dataDetail'][index];
                                            final now = DateTime.now();
                                            final DateFormat formatter =
                                                DateFormat('yyyy-MM-dd');
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  provider.getSelectedIdCase(
                                                      data['ID_Request']);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CaseDetailScreen()));
                                                },
                                                child: Container(
                                                  //height: 100,
                                                  //color: Colors.green.withOpacity(0.3),

                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8)),
                                                                color: Colors
                                                                    .grey[200],
                                                                image: DecorationImage(
                                                                    image: data['Image'] ==
                                                                            null
                                                                        ? AssetImage(
                                                                            'assets/images/no_image.png')
                                                                        : NetworkImage(
                                                                            'https://balifoam.com/mita/mobile/flutter/image_asset/${data['Image']}'),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                          ),
                                                          //if(formatter.format(now) == data['Today'])
                                                          if (int.parse(data[
                                                                  'Step']) <
                                                              2)
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    //width:40,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(8),
                                                                            bottomRight: Radius.circular(8)),
                                                                        color: Colors.red,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Colors.black12,
                                                                              spreadRadius: 1)
                                                                        ]),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child: Center(
                                                                          child: Text(
                                                                        'NEW',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 12),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      Container(
                                                        //height: 130,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8)),
                                                            color: Colors
                                                                .orangeAccent
                                                                .withOpacity(
                                                                    0.1)),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (data[
                                                                          'Type'] !=
                                                                      'K')
                                                                    Text(
                                                                        data[
                                                                            'Description'],
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  if (data[
                                                                          'Type'] ==
                                                                      'K')
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          '${data['No']} ',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: data['Model'] == null
                                                                              ? Text(
                                                                                  '${data['Manufacture']}',
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )
                                                                              : Text(
                                                                                  '${data['Manufacture']} ${data['Model']}',
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .person_outline,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Expanded(
                                                                          child: data['User'] == null
                                                                              ? Text(
                                                                                  '-',
                                                                                  style: TextStyle(color: Colors.green),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )
                                                                              : Text(
                                                                                  data['User'],
                                                                                  style: TextStyle(color: Colors.green),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Text(
                                                                        data[
                                                                            'Date_Request'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )),
                                                                      //Text('ddd dddd kddkd dkdkkd kkdkddk')
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .watch_later_outlined,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                          data[
                                                                              'Time_Request'],
                                                                          style:
                                                                              TextStyle(fontSize: 12))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                              if (pc['exist'] > 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Komputer',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EDPScreen()));
                                              },
                                              child: Text(
                                                  'Lihat semua (${cnt['it']})',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.lightBlue)))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 190,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.teal.withOpacity(0.5),
                                      child: Stack(
                                        children: [
                                          AnimatedPositioned(
                                            duration:
                                                Duration(milliseconds: 500),
                                            left: _left ? -40 : 6,
                                            child: AnimatedOpacity(
                                              opacity: _visible ? 1.0 : 0.0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: Container(
                                                height: 190,
                                                width: 100,
                                                child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/pc.png'))),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CustomScrollView(
                                              controller: _controllerComputer,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              slivers: [
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                          (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: Center(
                                                        child: Container(
                                                          width: 90,
                                                          height: 90,
                                                        ),
                                                      ),
                                                    );
                                                  }, childCount: 1),
                                                ),
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                          (context, index) {
                                                    var data =
                                                        pc['dataDetail'][index];
                                                    final now = DateTime.now();
                                                    final DateFormat formatter =
                                                        DateFormat(
                                                            'yyyy-MM-dd');
                                                    return Card(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                provider.getSelectedIdCase(
                                                                    data[
                                                                        'ID_Request']);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CaseDetailScreen()));
                                                              },
                                                              child: Container(
                                                                height: 130,
                                                                width: 130,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(4)),
                                                                        color: Colors
                                                                            .green
                                                                            .withOpacity(0.2),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              data['ID_Request'],
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            //SizedBox(width: 10,),
                                                                            //Icon(Icons.build_circle),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //if(formatter.format(now) == data['Today'])
                                                                    if (int.parse(
                                                                            data['Step']) <
                                                                        2)
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            //width:40,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)), color: Colors.red, boxShadow: [
                                                                              BoxShadow(color: Colors.black12, spreadRadius: 1)
                                                                            ]),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                'NEW',
                                                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    Expanded(
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(4)),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text('${data['ID_Asset']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                SizedBox(
                                                                                  height: 4,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.person_outline,
                                                                                      size: 15,
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    Expanded(child: Text(data['Requestor'], style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 4,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.calendar_today,
                                                                                      size: 15,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      data['Date_Request'],
                                                                                      style: TextStyle(fontSize: 12),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 4,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.watch_later_outlined,
                                                                                      size: 15,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      data['Time_Request'],
                                                                                      style: TextStyle(fontSize: 12),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )));
                                                  }, childCount: pc['exist']),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                              if (ut['exist'] > 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Utility',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>OutstandingScreen(1)));
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>RutinScreen()));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OtherScreen()));
                                              },
                                              child: Text('Lihat semua',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.lightBlue)))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          itemCount: ut['exist'],
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = ut['dataDetail'][index];
                                            final now = DateTime.now();
                                            final DateFormat formatter =
                                                DateFormat('yyyy-MM-dd');
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtherScreen()));
                                                },
                                                child: Container(
                                                  //height: 100,
                                                  //color: Colors.green.withOpacity(0.3),

                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8)),
                                                                color: Colors
                                                                    .grey[200],
                                                                image: DecorationImage(
                                                                    image: data['Image_Name'] ==
                                                                            null
                                                                        ? AssetImage(
                                                                            'assets/images/no_image.png')
                                                                        : NetworkImage(
                                                                            'https://balifoam.com/mita/mobile/flutter/image_case/${data['Image_Name']}'),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                          ),
                                                          //if(formatter.format(now) == data['Today'])
                                                          /*
                                                      if(int.parse(data['Step'])<2)
                                                        Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                //width:40,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                                                                    color: Colors.red,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.black12,
                                                                          spreadRadius: 1
                                                                      )
                                                                    ]

                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Center(child: Text('NEW', style: TextStyle(color: Colors.white, fontSize: 12),)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )

                                                       */
                                                        ],
                                                      ),
                                                      Container(
                                                        //height: 130,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8)),
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.1)),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      data[
                                                                          'Type'],
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .person_outline,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Text(
                                                                        data[
                                                                            'Requestor'],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Text(
                                                                        data[
                                                                            'Date_Request'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )),
                                                                      //Text('ddd dddd kddkd dkdkkd kkdkddk')
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .watch_later_outlined,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                          data[
                                                                              'Time_Request'],
                                                                          style:
                                                                              TextStyle(fontSize: 12))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                              ///statistik
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Statistik',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      //height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 8),
                                                child: Text('Total Asset'),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Kendaraan Ekspedisi : ${ctn['dataDetail']['ekspedisi']}')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Kendaraan Operasional : ${ctn['dataDetail']['operasional']}')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Angkutan Dalam : ${ctn['dataDetail']['angkutan']}')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Mesin Produksi : ${ctn['dataDetail']['mesin']}')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Komputer : ${ctn['dataDetail']['komputer']}')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        'Fire Safety : ${ctn['dataDetail']['apar']}')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

/*
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 50,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [

                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Kendaraan Ekspedisi : ${ctn['dataDetail']['ekspedisi']}')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Kendaraan Operasional : ${ctn['dataDetail']['operasional']}')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Angkutan Dalam : ${ctn['dataDetail']['angkutan']}')
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                flex: 40,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [

                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Mesin Produksi : ${ctn['dataDetail']['mesin']}')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Komputer : ${ctn['dataDetail']['komputer']}')
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.circle, size: 10,),
                                                          SizedBox(width: 5,),
                                                          Text('Fire Safety : ${ctn['dataDetail']['apar']}')
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

 */
                                        ],
                                      )),
                                ),
                              ]),

                              ///reminder
                              SizedBox(
                                height: 20,
                              ),
//Reminder
                              if ((userLevelX == "0" ||
                                      userLevelX == "1" ||
                                      userLevelX == "2") &&
                                  reminder['exist'] > 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Reminder',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: reminder['exist'],
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data =
                                            reminder['dataDetail'][index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            //height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,

                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[300]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              //color: Colors.yellow
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.grey[300]),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              topRight: Radius
                                                                  .circular(8)),
                                                      color: data['Type'] == 'K'
                                                          ? Colors.blueGrey
                                                          : Colors.red),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          data['Type'] == 'K'
                                                              ? 'Asuransi Expired'
                                                              : 'Fire Extinguisher',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                            data['Date_Expire'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.grey[300]),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.white),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 60,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '${data['Manufacture']} ${data['Model']}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            data['Type'] == 'K'
                                                                ? Text(
                                                                    data['No'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ))
                                                                : Text(
                                                                    data[
                                                                        'ID_Asset'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ))
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 40,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0,
                                                                    bottom: 4),
                                                            child: Container(
                                                              height: 70,
                                                              width: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(data['Type'] ==
                                                                            'K'
                                                                        ? 'assets/images/car_protect.jpg'
                                                                        : 'assets/images/fire.png'),
                                                                    fit: BoxFit
                                                                        .fitHeight),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                            ]);
                          }
                          return Center(
                            child: JumpingDotsProgressIndicator(
                                fontSize: 50.0, color: Colors.orange),
                          );
                        },
                      ),
                    ],
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
          floatingActionButton: FutureBuilder(
              future: dioService.loadMyRequest(user.uid, provider.userLevel),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (int.parse(provider.userLevel) >= 4) {
//print(snapshot.data['data'][1]['exist']);
                    var jml = snapshot.data['data'][1]['exist'] +
                        snapshot.data['data'][2]['exist'] +
                        snapshot.data['data'][3]['exist'];
                    return Visibility(
                      visible: snapshot.data['data'][0]['exist'] > 0 ||
                          snapshot.data['data'][1]['exist'] > 0 ||
                          snapshot.data['data'][2]['exist'] > 0 ||
                          snapshot.data['data'][3]['exist'] > 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyRequestScreen()));
                        },
                        child: Card(
                            //elevation: 10,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                // The child of a round Card should be in round shape
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.5),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: Center(
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.filter_frames_sharp,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    jml > 0
                                        ? Positioned(
                                            top: 1,
                                            right: 0,
                                            child: badges.Badge(
                                              //position: BadgePosition.topEnd(top: 22, end: 32),
                                              badgeContent: Text(
                                                jml.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              shape: badges.BadgeShape.circle,
                                              //borderRadius: BorderRadius.circular(8),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    );
                  }
                  /*
              else {

                var jml = snapshot.data['data'][1]['exist'];

                return Visibility(
                  visible: snapshot.data['data'][0]['exist']>0 || jml>0,
                  child: InkWell(
                    onTap: (){
                      print(provider.userLevel);
                      if(int.parse(provider.userLevel)<=3){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyJobScreen()));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRequestScreen()));

                      }

                    },
                    child: Card(
                      //elevation: 10,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),

                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            // The child of a round Card should be in round shape
                            shape: BoxShape.circle,
                            color: Colors.blueGrey.withOpacity(0.5),
                            border: Border.all(color: Colors.white, width: 1),

                          ),
                          child: Center(
                            child: Stack(
                              children: [

                                Icon(Icons.filter_frames_sharp, color: Colors.white, size: 35,),
                                if(snapshot.data['data'][1]['exist']>0)
                                  Positioned(
                                    top: 1,
                                    right: 0,
                                    child: Badge(
                                      //position: BadgePosition.topEnd(top: 22, end: 32),
                                      badgeContent: Text(jml.toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                      shape: BadgeShape.circle,
                                      //borderRadius: BorderRadius.circular(8),

                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                );



                print(jml);
              }

               */
                }
                return SizedBox.shrink();
              })),
    );
  }

  showDialogX() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Data tidak ditemukan.'),
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

  showModalReminderCarOperasional(context, info) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reminder'),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktunya untuk servis kendaraan anda.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hubungi ME atau abaikan jika sudah.'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        info['Next_Maintenance'] == 'Minor Service'
                            ? Text(
                                '${info['No']} >> Service Ringan',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )
                            : info['Next_Maintenance'] == 'Intermediate Service'
                                ? Text(
                                    '${info['No']} >> Service Sedang',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )
                                : info['Next_Maintenance'] == 'Full Service'
                                    ? Text(
                                        '${info['No']} >> Service Besar',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'KM ${info['Next_KM']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'https://www.teahub.io/photos/full/183-1834086_car-maintenance.jpg'),
                        fit: BoxFit.cover,
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showModalReminderCarEkspedisi(context, info) {
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reminder'),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktunya untuk servis kendaraan anda.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hubungi ME atau abaikan jika sudah.'),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: info.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (info.length >= 0) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(info[index]['No']),
                              info[index]['Next_Maintenance'] == 'Minor Service'
                                  ? Text(
                                      'Service Ringan',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : info[index]['Next_Maintenance'] ==
                                          'Intermediate Service'
                                      ? Text(
                                          'Service Sedang',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : info[index]['Next_Maintenance'] ==
                                              'Full Service'
                                          ? Text(
                                              'Service Besar',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(''),
                              Text(
                                info[index]['Next_KM'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'http://www.trackotag.com/public/front-panel/images/maintenance_overview_img1.png'),
                        fit: BoxFit.fitHeight,
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showModalReminderTeknisi(context, info) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 370,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reminder'),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktunya untuk aktifitas perawatan rutin.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$info item masuk dalam schedule'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>OutstandingScreen(1)));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Detail'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'https://www.smglobal.com/wp-content/uploads/preventative-maintenance-planning-calendar-300x201.jpg'),
                        fit: BoxFit.cover,
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showModalReminderEDP(context, info) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 370,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reminder'),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktunya untuk aktifitas perawatan rutin.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$info item masuk dalam schedule'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>OutstandingScreen(3)));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Detail'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'https://dione.cc/wp-content/uploads/2021/04/PC-maintenance-1.jpg'),
                        fit: BoxFit.cover,
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showModalMenu(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 370,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.70,
                    //color: Colors.yellow,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Menu Lainnya'),
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ]),
                        Divider(color: Colors.grey[300]),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (int.parse(userLevelX) <= 3) {
                                      ///ini untuk spv ME
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportScreen()));
                                    } else {
                                      //showDialogError('ME personel only.');
                                      showDialogAccess();
                                    }
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2,
                                              color: Colors.grey[300])
                                        ]),
                                    child: Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        '$address/report.png'),
                                                //NetworkImage('$address/report.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Report')
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CalcTank()));
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2,
                                              color: Colors.grey[300])
                                        ]),
                                    child: Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        '$address/tank.png'),
                                                //NetworkImage('$address/tank.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Tank')
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportPeerScreen()));
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2,
                                              color: Colors.grey[300])
                                        ]),
                                    child: Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '$address/peer.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Produksi Peer')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showDialogVersion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New Version Available',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            //Navigator.of(context).pop();
                            String _url =
                                'https://mita.balifoam.com/download/index.html';
                            await canLaunch(_url)
                                ? await launch(_url)
                                : throw 'Could not launch $_url';
                          },
                          //color: Colors.blue,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: Text(
                            'Download Page',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo3.png'))),
                    )),
              ],
            ));
      },
    );
  }

  showDialogAccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Restricted Area',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          //color: Colors.blue,
                          child: Text(
                            'BACK',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo3.png'))),
                    )),
              ],
            ));
      },
    );
  }
}

/*
class WidgetProgress extends StatefulWidget {
  final String title;
  final double progressValue;
  final double percentageValue;
  final Function function;
  WidgetProgress({this.title, this.progressValue, this.percentageValue, this.function});

  @override
  _WidgetProgressState createState() => _WidgetProgressState();
}

class _WidgetProgressState extends State<WidgetProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 10,),
                SizedBox(width:5),
                Text(widget.title),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      height: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(

                          value: widget.progressValue,valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                          backgroundColor: Colors.grey[300],),

                      ),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text(widget.percentageValue.toStringAsFixed(2)),
                        Text('%')
                      ],
                    )
                  ],
                ),
                //Text('10/107'),
                //if(widget.percentageValue == 100)
                ElevatedButton(
                  child: Text('Make report'),
                  onPressed: widget.function
                ),




              ],
            ),
          ],
        ),
      ),
    );
  }
}


 */






