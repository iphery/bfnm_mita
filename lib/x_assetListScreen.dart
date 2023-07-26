import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mita/api_service.dart';
import 'package:mita/model/assets.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_assetDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_searchScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class AssetListScreen extends StatefulWidget {
  static const route = '/assetlistscreen';
  //const AssetListScreen({Key key}) : super(key: key);

  @override
  _AssetListScreenState createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {

  ScrollController _controller;
  bool _showAppbar = false;
  double heightAppBar = 0.0;
  ApiService service = ApiService();
  DioService dioService = DioService();

  List<Assets> dataAsset = [];

  String keyword = '';

  var textFieldController = TextEditingController();
  bool textFieldIconShow = false;
  var textFieldSmallController = TextEditingController();
  bool textFieldSmallIconShow = false;
  String imageUrl = '';
  Color startColor;
  Color endColor;

  StreamSubscription internetconnection;
  bool isoffline = false;
  String address = 'https://mita.balifoam.com/mobile/flutter/image_group';
  double _opacity = 0;
  double _scrollPosition = 0;


  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    final provider = Provider.of<AssetProvider>(context, listen: false);

    switch (provider.category) {
      case 'MP':
        imageUrl = '$address/mesin.png';
        startColor = Colors.red;
        endColor = Colors.orangeAccent;
        break;
      case 'K':
        imageUrl = '$address/bmw.png';
        startColor = Colors.purple;
        endColor = Colors.blue;
        break;
      case 'AC':
        imageUrl = '$address/ac.png';
        startColor = Colors.blue;
        endColor = Colors.pinkAccent;
        break;
      case 'PC':
        imageUrl = '$address/pc.png';
        startColor = Colors.green;
        endColor = Colors.lightBlueAccent;
        break;
      case 'AP':
        imageUrl = '$address/apar.png';
        startColor = Colors.yellow;
        endColor = Colors.lightBlueAccent;
        break;
      case 'UT':
        imageUrl = '$address/genset.png';
        startColor = Colors.yellow;
        endColor = Colors.lightBlueAccent;
        break;
    }




    ///check internet
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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

  _scrollListener() {
    setState(() {
      _scrollPosition = _controller.position.pixels;
    });
  }

  @override
  void dispose() {
    internetconnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<AssetProvider>(context, listen: false);

    var screenSize = MediaQuery.of(context).size;

    _opacity = _scrollPosition < screenSize.height * 0.1
        ? _scrollPosition / (screenSize.height * 0.1) : 1;
    return Scaffold(
      //backgroundColor: Colors.white,

      body: Stack(
        children: [
          !isoffline?
            SingleChildScrollView(

            controller: _controller,
            child: Column(
              children: [
                ///panel atas
                Container(
                  height: 150,

                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [startColor, endColor])
                        ),
                      ),

                      Positioned(
                        //top: 10,
                        right: 10,
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imageUrl),

                              ),

                          ),
                        ),
                      ),



                    ],
                  ),


                ),
                ///taruh di dalam listview

                FutureBuilder(
                  future: dioService.getAssetListCategory(provider.category),
                  builder: (context, snapshot){

                    if(snapshot.hasData){
                      if(snapshot.data['exist']>0){


                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data['exist'],
                          itemBuilder: (BuildContext context, int index){
                            var data = snapshot.data['dataDetail'][index];

                            return InkWell(
                              onTap: (){
                                //EasyLoading.show(status: 'Loading',maskType: EasyLoadingMaskType.custom);
                                //provider.getSelectedAsset(data);
                                provider.getSelectedIdAsset(data['ID_Asset']);
                                Navigator.pushNamed(context, AssetDetailScreen.route);
                                /*
                                dataAsset = [];
                                dataAsset.add(Assets(
                                    id_asset: data['ID_Asset'],
                                    description: data['Description'],
                                    manufacture: data['Manufacture'],
                                    model: data['Model'],
                                    user: data['User'],
                                    location: data['Location'],
                                    available: data['Available'],
                                    reserve: data['Reserve'],
                                    image: data['Image'],
                                    userImage: data['Profile_Image'],
                                    type: data['Type'],
                                    based: data['Based'],
                                    kelas: data['Class']
                                ));


                                provider.getSelectedAsset(dataAsset[0]);

                                 */


                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[300])
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            image: DecorationImage(
                                                image: data['Image'] != null? NetworkImage('http://mita.balifoam.com/mobile/flutter/image_asset/${data['Image']}')
                                                    : AssetImage('assets/images/no_image.png'),
                                                fit: BoxFit.cover

                                            )

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Row(
                                              children: [
                                                Text(data['ID_Asset'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                SizedBox(width:5),
                                                data['Available']=='1'? Icon(Icons.check_circle, color: Colors.green,size: 18):Icon(Icons.warning, size: 18, color: Colors.red,)
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            if(data['Type'] != 'K')
                                              Row(
                                                children:[
                                                  Expanded(
                                                    child: data['Model']!=null?Text('${data['Description']} ${data['Manufacture']} ${data['Model']}', style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,)
                                                        : Text('${data['Description']} ${data['Manufacture']}', style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,)

                                                  )
                                                ]
                                              ),
                                              if(data['Type'] == 'K')
                                              Row(
                                                children: [
                                                  Text('${data['Manufacture']} ${data['Model']}', style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,),
                                                  data['No']==null? SizedBox.shrink():Text(' | ${data['No']}', style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,),

                                                ],
                                              ),

                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Icon(Icons.person_outline, size: 23,),
                                                SizedBox(width: 5,),
                                                data['User']==null? Text('-'):
                                                Expanded(child: Text(data['User'], overflow: TextOverflow.ellipsis,))
                                              ],
                                            ),
                                            /*
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.warning, size: 20, color: data['Available']=='1'?Colors.black: Colors.red,),
                                                    SizedBox(width: 5,),
                                                    Text(data['Available']=='1'? 'Ready': 'Maintenance')
                                                  ],
                                                ),
                                                /*
                                                SizedBox(width: 10,),
                                                Row(
                                                  children: [
                                                    Icon(Icons.person_outline, size: 23,),
                                                    SizedBox(width: 5,),
                                                    data['User']==null? Text('-'):
                                                      Text(data['User'], overflow: TextOverflow.ellipsis,)
                                                  ],
                                                ),


                                                 */
                                              ],
                                            ),

                                             */
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                            child: Text('Ups.. data tidak ditemukan.'),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: JumpingDotsProgressIndicator(
                          fontSize: 40.0,
                          color: Colors.orange
                      ),
                    );
                  },
                ),





              ],
            ),
          )
              : SafeArea(
                child: Column(
            children: [
                Container(
                  padding: EdgeInsets.all(10.00),
                  margin: EdgeInsets.only(bottom: 10.00),
                  color: Colors.red,
                  child: Row(children: [

                    Container(
                      margin: EdgeInsets.only(right:6.00),
                      child: Icon(Icons.info, color: Colors.white),
                    ), // icon for error message

                    Text('No Internet Connection Available', style: TextStyle(color: Colors.white)),
                    //show error message text
                  ]),
                ),
                Expanded(child: Center(child: Icon(Icons.cloud_off, size: 60, color: Colors.grey[400],)))
            ],
          ),
              ),
          Container(
            height: 93.5,
            color: Colors.white.withOpacity(_opacity),
          ),
          _customAppBarChange()


        ],
      ),
    );
  }

  _customAppBarChange(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GestureDetector(
                  onTap: (){Navigator.pop(context);},
                  child: Icon(Icons.arrow_back_ios_rounded, color: _opacity>0.7?Colors.black:Colors.white,)),
            ),
            Expanded(
              child: GestureDetector(
                onTap: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                },
                child: Container(
                    decoration: BoxDecoration(
                        //color: Colors.white.withOpacity(0.5),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [_opacity>0.7?Colors.yellow.withOpacity(0.3):Colors.white, _opacity>0.7?Colors.yellow.withOpacity(0.3):Colors.white.withOpacity(0.5)]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Icon(Icons.search),
                          ),
                          SizedBox(width: 10,),
                          Text('Search', style: TextStyle(color:Colors.black),),
                        ],
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }







}
