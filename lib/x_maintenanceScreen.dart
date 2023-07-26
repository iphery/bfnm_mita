import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceScreen extends StatefulWidget {
  static const route = '/maintenancescreen';
  final String idAsset;
  final String manufacture;
  final String model;
  final String no;
  final String nextKm;
  final String nextMaintenance;

  MaintenanceScreen(
      {this.idAsset,
      this.manufacture,
      this.model,
      this.no,
      this.nextKm,
      this.nextMaintenance});

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final textEditing = TextEditingController();
  bool showClearIcon = false;
  User user = FirebaseAuth.instance.currentUser;
  ApiService service = ApiService();
  bool isError = false;

  final focus = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/bmw.png'))),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.manufacture} ${widget.model} | ${widget.no}',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.nextMaintenance} @ KM ${widget.nextKm}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditing,
                  focusNode: focus,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (textEditing.text.isNotEmpty) {
                      setState(() {
                        showClearIcon = true;
                        isError = false;
                      });
                    } else {
                      setState(() {
                        showClearIcon = false;
                      });
                    }
                  },
                  minLines: 1,
                  maxLines: 3,
                  decoration: isError
                      ? InputDecoration(
                          hintText: 'Masukkan angka km saat ini...',
                          border: InputBorder.none,
                          errorText: 'Kolom tidak boleh kosong',
                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink())
                      : InputDecoration(
                          hintText: 'Masukkan angka km saat ini...',
                          border: InputBorder.none,
                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink()),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () async {
              focus.unfocus();

              if (textEditing.text.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                var res = await service.getNewRequestMaintenance(
                    idAsset: widget.idAsset,
                    currentKm: textEditing.text,
                    idUser: user.uid);
                if (res == 'NOK') {
                  setState(() {
                    isLoading = false;
                  });

                  showDialog('Schedule asset tidak terdaftar. Hubungi admin.');
                } else {
                  EasyLoading.showSuccess('Submitted',
                          duration: Duration(seconds: 2))
                      .then((_) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context, res);
                    EasyLoading.dismiss();
                  });
                }
              } else {
                setState(() {
                  isError = true;
                });
              }
            },
            child: Material(
              elevation: 2,
              color:
                  showClearIcon ? Theme.of(context).primaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AnimatedContainer(
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
                              "Perawatan Rutin",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialog(e) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text(e),
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
