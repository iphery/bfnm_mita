import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {

  final String assetImage;
  final String userImage;
  final String requestor;
  final String today;
  final String idRequest;
  final String description;
  final String manufacture;
  final String model;
  final String no;
  final String mType;
  final String step;
  final String timeRequest;
  final String type;
  final String problem;
  final String tnow;

  ServiceCard({this.assetImage, this.userImage, this.requestor, this.today, this.idRequest, this.description,
  this.manufacture, this.model, this.no, this.mType, this.step, this.timeRequest, this.type, this.problem,
  this.tnow});

  String address = 'https://mita.balifoam.com/mobile/flutter/image_profile';


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:2, right:2),
          child: Container(
            //height: 100,
              decoration: BoxDecoration(
                  border:Border.all(color:Colors.grey[300]),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Row(
                  children:[
                    Container(
                        decoration: BoxDecoration(
                            //border:Border.all(color:Colors.grey),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                            color:mType=="CM"? Colors.red:Colors.green
                        ),
                        width: 10,
                        height: 120

                    ),
                    Container(
                        height: 120,
                        width:100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: assetImage==null?AssetImage('assets/images/no_image.png'):NetworkImage('https://balifoam.com/mita/mobile/flutter/image_asset/${assetImage}'),
                            fit:BoxFit.cover,

                          ),

                        )
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:2, bottom:2, left:4, right:2),
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
                                      child: userImage!=""?Container(
                                          width: 40,
                                          height:40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider('$address/${userImage}')

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
                                            child: Text(requestor[0].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(requestor, style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                                        today==tnow? Text('Today', style: TextStyle(color: Colors.lightBlue),):Text(timeRequest, style: TextStyle(color: Colors.deepPurple),),

                                      ],
                                    ),
                                  ]
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [

                                  Text(idRequest,),
                                  SizedBox(width: 5,),
                                  if(mType == 'CM')
                                    Icon(Icons.build_circle, color: Colors.red,size: 15,),


                                ],
                              ),
                              //Divider(color: Colors.blueGrey),
                              if(type=='K')
                                Row(
                                    children:[
                                      Expanded(
                                          child: Text(
                                            '$manufacture $model | $no', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,
                                          )
                                      )
                                    ]
                                ),
                              if(type!='K')
                                Row(
                                    children:[
                                      Expanded(
                                          child: model==null? Text(
                                            '$description $manufacture', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,
                                          )
                                              : Text(
                                            '$description $manufacture $model', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,
                                          )
                                      )
                                    ]
                                ),




                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(child: Text('Keluhan : $problem',overflow: TextOverflow.ellipsis,)),
                                ],
                              ),

                            ],
                          ),
                        )
                    )

                  ]
              )
          ),
        ),
        if(step=="1")
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
    );
  }
}
