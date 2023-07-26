import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_caseDetailScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:mita/x_reportMesinProduksi.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class MyJobScreen extends StatefulWidget {

  @override
  _MyJobScreenState createState() => _MyJobScreenState();
}

class _MyJobScreenState extends State<MyJobScreen> {

  DioService dioService = DioService();
  User user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Progress', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },

        ),
      ),
      body: FutureBuilder(
          future: dioService.loadMyRequest(user.uid, provider.userLevel),
          builder: (context, snapshot){
            if(snapshot.hasData){
              //print(snapshot.data['data'][1]['dataDetail'][0]['ID_Request']);
              return CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: [




                  ///sign here
                  if(snapshot.data['data'][1]['exist']>0 && (provider.userLevel == '0' || provider.userLevel == '1' || provider.userLevel == '3') )
                    SliverList(

                      delegate: SliverChildBuilderDelegate((context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text('SIGN HERE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              ],
                            ),
                          ),
                        );
                      },
                          childCount: 1


                      ),



                    ),
                  //perbakikan asset
                if(snapshot.data['data'][1]['exist']>0 && (provider.userLevel == '0' || provider.userLevel == '1' || provider.userLevel == '3'))
                  SliverList(

                    delegate: SliverChildBuilderDelegate((context, index){

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap:(){
                            provider.getSelectedIdCase(snapshot.data['data'][1]['dataDetail'][index]['ID_Request']);
                            Navigator.pushNamed(context, CaseDetailScreen.route);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.green.withOpacity(0.2), Colors.greenAccent]
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Request Form', style: TextStyle(color: Colors.blue),),
                                      Text('Perbaikan Asset', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                                      Text(snapshot.data['data'][1]['dataDetail'][index]['ID_Request']),
                                      Text('Request on ${snapshot.data['data'][1]['dataDetail'][index]['Time_Request']}'),

                                    ],
                                  ),

                                  Icon(Icons.sticky_note_2_outlined, size: 40, color: Colors.blueGrey,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                        childCount:snapshot.data['data'][1]['exist']


                    ),



                  ),


                  SliverList(

                    delegate: SliverChildBuilderDelegate((context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text('YOUR JOB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
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
                        child: InkWell(
                          onTap: (){
                            provider.getSelectedIdCase(snapshot.data['data'][0]['dataDetail'][index]['ID_Request']);
                            Navigator.pushNamed(context, CaseDetailScreen.route);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey[300]),
                                color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Request Form', style: TextStyle(color: Colors.blue),),
                                      Text('Perbaikan Asset', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                                      Text(snapshot.data['data'][0]['dataDetail'][index]['ID_Request']),
                                      Text('Request on ${snapshot.data['data'][0]['dataDetail'][index]['Time_Request']}'),

                                    ],
                                  )


                                ],
                              ),
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
            }
            return Center(
              child: JumpingDotsProgressIndicator(
                  fontSize: 40.0,
                  color: Colors.orange
              ),
            );//loading
          }
      ),
    );
  }
}
