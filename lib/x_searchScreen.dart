import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mita/model/assets.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_assetDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var textFieldController = TextEditingController();
  bool textFieldIconShow = false;
  String keyword = '';
  FocusNode focusTextField = FocusNode();
  DioService dioService = DioService();

  List<Assets> dataAsset = [];

  StreamSubscription internetconnection;
  bool isoffline = false;


  @override
  void initState() {
    focusTextField.requestFocus();

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
            onPressed: (){

              Navigator.pop(context);
              },
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 50, top: 4, bottom: 4, right: 8),
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
                onChanged: (val){
                  if(textFieldController.text.isNotEmpty){
                    setState(() {
                      textFieldIconShow = true;
                    });
                  } else if(textFieldController.text.isEmpty){
                    setState(() {
                      textFieldIconShow = false;

                    });
                  }

                  keyword = val;

                },
                onTap: (){
                  textFieldController.selection = TextSelection(baseOffset: 0, extentOffset: textFieldController.text.length);
                  if(textFieldController.text.isNotEmpty){
                    setState(() {
                      textFieldIconShow = true;
                    });
                  } else if(textFieldController.text.isEmpty){
                    setState(() {
                      textFieldIconShow = false;
                    });
                  }
                },



                decoration: InputDecoration(
                  hintText: "Search",

                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search, size: 20,),
                  ),
                  suffixIcon: textFieldIconShow? IconButton(
                    icon: Icon(Icons.clear),
                    iconSize: 20,
                    onPressed: (){
                      textFieldController.clear();
                      setState(() {
                        textFieldIconShow = false;

                      });
                      keyword = '';
                    },

                  ) : SizedBox.shrink() ,
                  border: InputBorder.none,
                  isDense: true,
                  //contentPadding: EdgeInsets.only(left: 11.0, top: 20.0, bottom: 8.0),
                ),
              ),


            ),
          ),




          backgroundColor: Colors.white,
        ),
        body: !isoffline?
          SingleChildScrollView(
          child: FutureBuilder(
            future: dioService.getAssetListCategorySearch(provider.category, keyword),
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
                              based: data['Based']
                          ));



                           */
                          //provider.getSelectedAsset(dataAsset[0]);
                          Navigator.pushNamed(context, AssetDetailScreen.route);

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
                                          image: data['Image'] == null? AssetImage('assets/images/no_image.png'):
                                              NetworkImage('http://mita.balifoam.com/mobile/flutter/image_asset/${data['Image']}'),
                                          fit: BoxFit.fill

                                      )

                                  ),
                                ),
                              ),
                              Expanded(
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
                                  ],
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
              return Container(
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: JumpingDotsProgressIndicator(
                      fontSize: 40.0,
                      color: Colors.orange
                  ),
                ),
              );
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
    );
  }
}
