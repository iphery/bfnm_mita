/*
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';



// ignore: must_be_immutable
class OutstandingScreen extends StatefulWidget {
  int selectedPage;
  OutstandingScreen(this.selectedPage);

  @override
  _OutstandingScreenState createState() => _OutstandingScreenState();
}

class _OutstandingScreenState extends State<OutstandingScreen> with SingleTickerProviderStateMixin {


  DioService dioService = DioService();
  List<Widget> _tabTitle() => [
    Tab(text: 'ME', ),
    Tab(text: 'EDP',),

  ];


  TabBar _tabBarIndicatorUnder() => TabBar(
    tabs: _tabTitle(),
    labelColor: Colors.white,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.purple, width: 4),
      insets: EdgeInsets.symmetric(horizontal: 20),
    ),
  );


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Outstanding Screen', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },

        ),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex:widget.selectedPage,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
//              constraints: BoxConstraints.expand(height: 50),
              child: _tabBarIndicatorUnder(),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    child: WidgetPerbaikan(),
                  ),
                  Container(
                    child: WidgetComputer(),
                  ),

                ]),
              ),
            )
          ],
        ),
      ),


    );
  }
}

// ignore: must_be_immutable
class WidgetPerbaikan extends StatelessWidget {

  DioService dioService = DioService();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return FutureBuilder(
      future: dioService.getDummy(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          //print(snapshot.data['data'][0]['category']);
          //print(snapshot.data['data'][1]['dataDetail'][0]['Step']);

          return ListView.builder(
              itemCount: snapshot.data['data'].length,
              itemBuilder: (context, index1) {

            return StickyHeader(
              header: snapshot.data['data'][index1]['exist']>0? Material(
                elevation: 1,
                child: Container(
                  height: 50.0,
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(snapshot.data['data'][index1]['category'],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ):
                SizedBox.shrink(),
              content: ListView.builder(
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
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          provider.getSelectedIdCase(data['ID_Request']);
                          Navigator.pushNamed(context, CaseDetailScreen.route);




                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                            //border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  spreadRadius: 2
                              )
                            ],),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(data['ID_Request'],),
                                    SizedBox(width: 5,),
                                    if(data['Maintenance_Type'] == 'CM')
                                      Icon(Icons.build_circle, color: Colors.red,size: 15,),

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

                                  ],
                                ),
                                Divider(color: Colors.blueGrey),
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
                                Row(
                                  children: [
                                    Text('Requested by ${data['Requestor']} ', style: TextStyle(color: Colors.lightBlue),),
                                    data['Today']==formatter.format(now)? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(data['Time_Request'], style: TextStyle(color: Colors.lightBlue),),
                                  ],
                                ),

                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    Text('Keluhan : ${data['Problem']}'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );


                  }
                  return SizedBox.shrink();
                },
              )
            );
          });
        }
        return Container();
      },
    );
  }
}

// ignore: must_be_immutable
/*
class WidgetMaintenance extends StatelessWidget {

  DioService dioService = DioService();
  String keyword = '';
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return FutureBuilder(
      future: dioService.getPMData(keyword),
      builder: (context, snapshot){
        if(snapshot.hasData){
          //print(snapshot.data['data'][0]['category']);
          //print(snapshot.data['data'][1]['dataDetail'][0]['Step']);
          if(snapshot.data['data'].length>0){
            return ListView.builder(
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index1) {

                  return StickyHeader(
                      header: snapshot.data['data'][index1]['exist']>0? Material(
                        elevation: 1,
                        child: Container(
                          height: 50.0,
                          color: Colors.grey[300],
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(snapshot.data['data'][index1]['category'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ):
                      SizedBox.shrink(),
                      content: ListView.builder(
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
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  provider.getSelectedIdCase(data['ID_Request']);
                                  Navigator.pushNamed(context, CaseDetailScreen.route);




                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    color: Colors.white,
                                    //border: Border.all(color: Colors.grey),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          spreadRadius: 2
                                      )
                                    ],),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(data['ID_Request'],),
                                            SizedBox(width: 5,),
                                            if(data['Maintenance_Type'] == 'CM')
                                              Icon(Icons.build_circle, color: Colors.red,size: 15,),

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

                                          ],
                                        ),
                                        Divider(color: Colors.blueGrey),
                                        Row(
                                          children: [
                                            Text('${data['Description']} ${data['Manufacture']} ${data['Model']}',style: TextStyle(fontWeight: FontWeight.bold)),

                                            if(data['Type']=='K')
                                              Text(' | ${data['No']}',style: TextStyle(fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Requested by ${data['Requestor']} ', style: TextStyle(color: Colors.lightBlue),),
                                            data['Today']==formatter.format(now)? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(data['Time_Request'], style: TextStyle(color: Colors.lightBlue),),
                                          ],
                                        ),

                                        SizedBox(height: 10),

                                        Row(
                                          children: [
                                            Text('Keluhan : ${data['Problem']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );


                          }
                          return SizedBox.shrink();
                        },
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
        return Container();
      },
    );
  }
}

 */

class WidgetComputer extends StatelessWidget {

  DioService dioService = DioService();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return FutureBuilder(
      future: dioService.getPMITData(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          print(snapshot.data['data'].length>0);
          //print(snapshot.data['data'][0]['category']);
          //print(snapshot.data['data'][1]['dataDetail'][0]['Step']);
          if(snapshot.data['data'].length>0){
            return ListView.builder(
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index1) {

                  return StickyHeader(
                      header: snapshot.data['data'][index1]['exist']>0? Material(
                        elevation: 1,
                        child: Container(
                          height: 50.0,
                          color: Colors.grey[300],
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(snapshot.data['data'][index1]['category'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ):
                      SizedBox.shrink(),
                      content: ListView.builder(
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
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  provider.getSelectedIdCase(data['ID_Request']);
                                  Navigator.pushNamed(context, CaseDetailScreen.route);




                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    color: Colors.white,
                                    //border: Border.all(color: Colors.grey),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          spreadRadius: 2
                                      )
                                    ],),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(data['ID_Request'],),
                                            SizedBox(width: 5,),
                                            if(data['Maintenance_Type'] == 'CM')
                                              Icon(Icons.build_circle, color: Colors.red,size: 15,),

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

                                          ],
                                        ),
                                        Divider(color: Colors.blueGrey),
                                        Row(
                                          children: [
                                            Text('${data['Description']} ${data['ID_Asset']}',style: TextStyle(fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Requested by ${data['Requestor']} ', style: TextStyle(color: Colors.lightBlue),),
                                            data['Today']==formatter.format(now)? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(data['Time_Request'], style: TextStyle(color: Colors.lightBlue),),
                                          ],
                                        ),

                                        SizedBox(height: 10),

                                        Row(
                                          children: [
                                            Text('Keluhan : ${data['Problem']}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );


                          }
                          return SizedBox.shrink();
                        },
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
        return Container();
      },
    );
  }
}


 */