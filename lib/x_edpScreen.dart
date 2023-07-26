
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mita/card.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'dio_service.dart';

class EDPScreen extends StatefulWidget {

  @override
  _EDPScreenState createState() => _EDPScreenState();
}

class _EDPScreenState extends State<EDPScreen> {
  DioService dioService = DioService();
  bool ind = false;
  int aktif = -1;
  String keyword = '';
  String address = 'https://mita.balifoam.com/mobile/flutter/image_profile';
  ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Text('EDP', style: TextStyle(color: Colors.black),),

      ),
      body: FutureBuilder(
        future: dioService.getEDPData(keyword),
        builder: (context, snapshot){
          if(snapshot.hasData){
            //print(snapshot.data['data'][0]['category']);
            //print(snapshot.data['data'][1]['dataDetail'][0]['Step']);
            if(snapshot.data['data'].length>0){
              return ListView.builder(
                  controller: _controller,
                  itemCount: snapshot.data['data'].length,
                  itemBuilder: (context, index1) {

                    return StickyHeader(
                      //controller: _controller,
                        header: snapshot.data['data'][index1]['exist']>0? Material(
                          elevation: 1,
                          child: Container(
                            height: 40.0,
                            color: Colors.blueGrey,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data['data'][index1]['category'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ):
                        SizedBox.shrink(),
                        content: Column(
                          children: [

                            SizedBox(height:4),
                            ListView.builder(
                              itemCount: snapshot.data['data'][index1]['exist'],
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2){
                                if(snapshot.data['data'][index1]['exist'] > 0){
                                  final now = DateTime.now();
                                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                  //final today = DateTime(now.year, now.month, now.day);
                                  //final dateToCheck = data['Time_Request'];
                                  //final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

                                  var data = snapshot.data['data'][index1]['dataDetail'][index2];

                                  return Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: InkWell(
                                        onTap: ()async{
                                          provider.getSelectedIdCase(data['ID_Request']);
                                          var res = await Navigator.pushNamed(context, CaseDetailScreen.route);
                                          if(res==null){
                                            setState(() {

                                            });
                                          }



                                        },
                                        child: ServiceCard(
                                          assetImage: data['image'],
                                          userImage: data['imageUrl'],
                                          requestor: data['Requestor'],
                                          today: data['Today'],
                                          idRequest: data['ID_Request'],
                                          description: data['Description'],
                                          manufacture: data['Manufacture'],
                                          model: data['Model'],
                                          no: data['No'],
                                          mType: data['Maintenance_Type'],
                                          step: data['Step'],
                                          timeRequest: data['Time_Request'],
                                          type: data['Type'],
                                          problem: data['Problem'],
                                          tnow: formatter.format(now),

                                        )
                                    ),
                                  );


                                }
                                return SizedBox.shrink();
                              },
                            ),
/*
                            ListView.builder(
                              itemCount: snapshot.data['data'][index1]['exist'],
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2){
                                if(snapshot.data['data'][index1]['exist'] > 0){
                                  final now = DateTime.now();
                                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                  //final today = DateTime(now.year, now.month, now.day);
                                  //final dateToCheck = data['Time_Request'];
                                  //final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

                                  var data = snapshot.data['data'][index1]['dataDetail'][index2];

                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: ()async{
                                        provider.getSelectedIdCase(data['ID_Request']);
                                        var res = await Navigator.pushNamed(context, CaseDetailScreen.route);
                                        if(res==null){
                                          setState(() {

                                          });
                                        }



                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              //color: Colors.white,
                                              //border: Border.all(color: Colors.grey),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [Colors.white, Colors.teal.withOpacity(0.1)]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[200],
                                                    spreadRadius: 2
                                                )
                                              ],),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ///requestor
                                                  Row(
                                                      children:[
                                                        GestureDetector(
                                                          onTap:(){
                                                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePreviewScreen(imageUrl: 'http://mita.balifoam.com/mobile/flutter/image_profile/CNa21Kkxlpbh3pJT9PF0IGJIToA220211202114210.jpg',)));

                                                          },
                                                          child: data['imageUrl']!=""?Container(
                                                              width: 40,
                                                              height:40,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                  color: Colors.grey,
                                                                  image: DecorationImage(
                                                                      image: CachedNetworkImageProvider('$address/${data['imageUrl']}')

                                                                    //image: NetworkImage('$address/${data['imageUrl']}')
                                                                  )
                                                              )
                                                          ):Container(
                                                            width: 40,
                                                            height:40,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                                              color: Colors.red.withOpacity(0.4),

                                                            ),
                                                            child: Center(
                                                                child: Text(data['Requestor'][0].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width:5),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(data['Requestor'], style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                                                            data['Today']==formatter.format(now)? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(data['Time_Request'], style: TextStyle(color: Colors.deepPurple),),

                                                          ],
                                                        ),
                                                      ]
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [

                                                      Text(data['ID_Request'],),
                                                      SizedBox(width: 5,),
                                                      if(data['Maintenance_Type'] == 'CM')
                                                        Icon(Icons.build_circle, color: Colors.red,size: 15,),
                                                      /*
                                                  if(formatter.format(now) == data['Today'])
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Badge(
                                                        badgeColor: Colors.red,
                                                        shape: BadgeShape.square,
                                                        borderRadius: BorderRadius.circular(3),
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

                                                   */

                                                    ],
                                                  ),
                                                  //Divider(color: Colors.blueGrey),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('${data['Description']} ${data['Manufacture']}',style: TextStyle(fontWeight: FontWeight.bold)),
                                                          data['Model']==null? SizedBox.shrink():Text(' ${data['Model']}',style: TextStyle(fontWeight: FontWeight.bold)),

                                                        ],
                                                      ),

                                                      if(data['Type']=='K')
                                                        Text(' | ${data['No']}',style: TextStyle(fontWeight: FontWeight.bold))
                                                    ],
                                                  ),
                                                  /*
                                              Row(
                                                children: [
                                                  Text('Requested by ${data['Requestor']} ', style: TextStyle(color: Colors.deepPurple),),
                                                  data['Today']==formatter.format(now)? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(data['Time_Request'], style: TextStyle(color: Colors.deepPurple),),
                                                ],
                                              ),

                                               */

                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Expanded(child: Text('Keluhan : ${data['Problem']}')),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          if(data['Step']=="1")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  //width:40,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topRight: Radius.circular(8)),
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
                                                    child: Center(child: Text('NEW', style: TextStyle(color: Colors.white, ),)),
                                                  ),
                                                ),


                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  );


                                }
                                return SizedBox.shrink();
                              },
                            ),

 */



                          ],
                        )
                    );
                  });
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
                fontSize: 40.0,
                color: Colors.orange
            ),
          );
        },
      ),
    );
  }
}
