import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:mita/camera/front_camera.dart';
import 'package:mita/x_changePasswordScreen.dart';
import 'package:mita/x_helpMenuScreen.dart';
import 'package:mita/x_landingPage.dart';
import 'package:mita/x_loginScreen.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profilescreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = FirebaseAuth.instance.currentUser;
  String path;

  ApiService service = ApiService();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,)),
        title: Text('Profile', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: provider.loadUser(user.uid),
              builder: (context, snapshot){

                if(snapshot.hasData){
                  var data = snapshot.data;

                  return Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(80)),
                            border: Border.all(color: Colors.white, width: 2),

                            image: DecorationImage(
                                image: data['imageUrl'] != ''? NetworkImage('https://mita.balifoam.com/mobile/flutter/image_profile/${data['imageUrl']}'): NetworkImage('https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY317_CR4,0,214,317_AL_.jpg'),
                                fit: BoxFit.cover

                            )
                        ),

                      ),

                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['Name'], style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text(user.email),
                          SizedBox(height: 5,),
                          GestureDetector(
                              onTap: ()async{
                                var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileCameraScreen()));

                                if (res != null) {
                                  print(res);
                                  setState(() {
                                    path = res;//res[0].thumbPath;
                                  });
                                }

                                var response = await service.saveProfilePicture(path: path, idUser: user.uid, name: 'update_only');
                                if(response == 'OK'){
                                  EasyLoading.showSuccess('Tersimpan.', duration: Duration(milliseconds: 1000)).then((value) {
                                    EasyLoading.dismiss();
                                    setState((){});
                                  });
                                }

                                /*
                          List<Media> res = await ImagesPicker.pick(
                            count: 1,
                            pickType: PickType.all,
                            language: Language.System,
                            // maxSize: 500,
                            cropOpt: CropOption(
                              aspectRatio: CropAspectRatio.wh16x9,
                            ),
                          );
                          if (res != null) {

                            setState(() {
                              path = res[0].thumbPath;
                            });

                            await service.saveProfilePicture(path: path, idUser: user.uid).then((value) {
                              EasyLoading.showSuccess('Tersimpan.', duration: Duration(milliseconds: 500));
                              setState(() {
                                //refresh
                              });
                            });

                          }


                           */

                              },
                              child: Icon(Icons.camera_alt, size: 25, color: Colors.black,)
                          )



                        ],
                      )
                    ],
                  );
                }
                return Center(
                    child: CircularProgressIndicator()
                );
              },
            )
          ),
          Divider(color: Colors.blueGrey),
          Padding(
            padding: const EdgeInsets.only(top:8,bottom: 8 , left: 12, right: 12 ),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30)),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('Change Password')),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8,bottom: 8 , left: 12, right: 12 ),
            child: GestureDetector(
              onTap: () async{
                String _url = 'https://mita.balifoam.com/download/index.html';
                await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

                },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30)),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('Download Updates')),
                ),
              ),
            ),
          ),
          /*
          Padding(
            padding: const EdgeInsets.only(top:8,bottom: 8 , left: 12, right: 12 ),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpMenuScreen()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30)),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('Help')),
                ),
              ),
            ),
          ),

           */
          Container(

            child: GestureDetector(
              onTap: ()async{
                await FirebaseAuth.instance.signOut().then((value){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LandingPage()), (Route<dynamic> route) => false);

                });

              },
              child: Padding(
                padding: const EdgeInsets.only(top:8,bottom: 8 , left: 12, right: 12 ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    //color: Colors.red.withOpacity(0.8)

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Logout')),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Text('2021 \u00a9 Copyright: ME TEAM BFNM'),
          SizedBox(height: 10),
          Text('v 1.3')

        ],

      ),
    );
  }
}
