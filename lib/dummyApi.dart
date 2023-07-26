import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DummyApi extends StatefulWidget {
  @override
  _DummyApiState createState() => _DummyApiState();
}

class _DummyApiState extends State<DummyApi> {
  double x = 0;

  Future<dynamic> getAllData() async {
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
      };
      var response = await Dio().post(
        'https://mita.balifoam.com/mobile/flutter/dummy2.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.data);

        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  loadData() async {
    var b = await getAllData();
    print(b['id']);
    if (int.parse(b['id']) >= 50) {
      setState(() {
        x = 100;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                TextButton(
                  child: Text('refresh'),
                  onPressed: () async {
                    var res = await saveData('id');
                    if (res == 'OK') {
                      setState(() {});
                    }
                  },
                ),
                FutureBuilder(
                    future: getData('id'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (int.parse(snapshot.data['id']) >= 50) {
                          setState(() {
                            x = 100;
                          });
                        }
                        //print(snapshot.data);
                        return Row(
                          children: [
                            Text(snapshot.data['id']),
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: x,
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          var c = await saveData('id');
                          if (c == 'OK') {
                            setState(() {
                              loadData();
                            });
                          }
                        },
                        child: Text('Hallo')),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> getData(id) async {
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
      };
      var response = await Dio().post(
        'https://mita.balifoam.com/mobile/flutter/dummy2.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.data);

        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> saveData(id) async {
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
      };
      var response = await Dio().post(
        'https://mita.balifoam.com/mobile/flutter/dummy3.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.data);

        return data;
      }
    } catch (e) {
      print(e);
    }
  }
}
