import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class UserApproveOtherScreen extends StatefulWidget {
  final String idRequest;
  UserApproveOtherScreen({this.idRequest});

  @override
  _UserApproveOtherScreenState createState() => _UserApproveOtherScreenState();
}

class _UserApproveOtherScreenState extends State<UserApproveOtherScreen> {
  bool isLoading = false;
  var rating = 5.0;
  DioService dioService = DioService();
  bool showClearIcon = false;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.withOpacity(0.1), Colors.white])),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/thankyou.png'))),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Berikan penilaian atas service kami',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                SmoothStarRating(
                  rating: rating,
                  isReadOnly: false,
                  size: 50,
                  color: Colors.yellow,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {
                    rating = value;
                  },
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            elevation: 2,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final provider =
                          Provider.of<AssetProvider>(context, listen: false);

                      setState(() {
                        isLoading = true;
                      });

                      var res = await dioService.confirmOtherRequest(
                          widget.idRequest, rating.toStringAsFixed(1));
                      if (res == 'OK') {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context, 'done');
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog();
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    child: CupertinoActivityIndicator(
                                      radius: 11,
                                    )),
                                SizedBox(width: 10),
                                Text(
                                  "Please wait...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Update gagal. Cobalah beberapa saat lagi.'),
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
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
