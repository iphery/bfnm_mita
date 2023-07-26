
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_imagepreviewScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'card.dart';
import 'dio_service.dart';

class RutinScreen extends StatefulWidget {

  @override
  _RutinScreenState createState() => _RutinScreenState();
}

class _RutinScreenState extends State<RutinScreen> {
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
        title: Text('Maintenance', style: TextStyle(color: Colors.black),),

      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: FutureBuilder(
              future: dioService.loadCategoryOutstandingPM(),
              builder: (context, snapshot){


                if(snapshot.hasData){

                  return CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(

                        delegate: SliverChildBuilderDelegate((context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){

                                _controller.animateTo(
                                    _controller.position.minScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);


                                setState(() {
                                  aktif = -1;
                                  keyword = '';

                                });


                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(color: Colors.grey[300]),
                                    color: aktif==-1? Colors.teal.withOpacity(0.2): Colors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('All'),
                                ),
                              ),
                            ),
                          );
                        },
                            childCount: 1


                        ),



                      ),
                      SliverList(

                        delegate: SliverChildBuilderDelegate((context, index){

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){

                                _controller.animateTo(
                                    _controller.position.minScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);



                                setState(() {

                                  aktif = index;
                                  keyword = snapshot.data['data'][0]['dataDetail'][index]['Class'];

                                });






                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(color: Colors.grey[300]),
                                    color: index==aktif? Colors.teal.withOpacity(0.2): Colors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data['data'][0]['dataDetail'][index]['Class']),
                                ),
                              ),
                            ),
                          );
                        },
                            childCount:snapshot.data['data'][0]['exist']


                        ),



                      ),

                    ],
                  );


                    /*
                    ListView.builder(
                    itemCount: snapshot.data['data'][0]['exist'],
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){


                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              aktif = index;
                              keyword = snapshot.data['data'][0]['dataDetail'][index]['Class'];

                            });
                            print(keyword);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey[300]),
                              color: index==aktif? Colors.teal.withOpacity(0.2): Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data['data'][0]['dataDetail'][index]['Class']),
                            ),
                          ),
                        ),
                      );
                    },
                  );

                     */
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: dioService.getPMData(keyword),
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
                            //controller:_controller,
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
                                children:[
                                  SizedBox(height:4),
                                  ListView.builder(
                                    //controller:_controller,

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
                                          padding: const EdgeInsets.all(4.0),
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
                                  )
                                ]
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
          )
        ],
      ),
    );
  }
}
