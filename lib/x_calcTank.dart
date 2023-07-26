import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class CalcTank extends StatefulWidget {
  @override
  _CalcTankState createState() => _CalcTankState();
}

class _CalcTankState extends State<CalcTank> {
  String option = 'PPG';

  ///0 ppg, 1 tdi
  bool ppg = true;
  bool tdi = false;
  String keyword = '';
  final textInput = TextEditingController();
  FocusNode focusInput = FocusNode();
  bool showClearIconInput = false;
  bool isError = false;
  bool isCompleted = false;
  bool isLoading = false;
  double heightResult = 0.0;
  String volCalc = '0.0';
  String massCalc = '0.0';
  bool isSave = false;
  DioService dioService = DioService();
  var data;

  final textDimPPG = TextEditingController();
  FocusNode focusDimPPG = FocusNode();
  bool showClearIconDimPPG = false;
  bool isErrorDimPPG = false;
  bool isCompletedDimPPG = false;
  bool isSaveDimPPG = false;
  double heightDimPPG = 0.0;

  final textSgPPG = TextEditingController();
  FocusNode focusSgPPG = FocusNode();
  bool showClearIconSgPPG = false;
  bool isErrorSgPPG = false;
  bool isCompletedSgPPG = false;
  bool isSaveSgPPG = false;
  double heightSgPPG = 0.0;

  final textDimTDI = TextEditingController();
  FocusNode focusDimTDI = FocusNode();
  bool showClearIconDimTDI = false;
  bool isErrorDimTDI = false;
  bool isCompletedDimTDI = false;
  bool isSaveDimTDI = false;
  double heightDimTDI = 0.0;

  final textSgTDI = TextEditingController();
  FocusNode focusSgTDI = FocusNode();
  bool showClearIconSgTDI = false;
  bool isErrorSgTDI = false;
  bool isCompletedSgTDI = false;
  bool isSaveSgTDI = false;
  double heightSgTDI = 0.0;

  @override
  void initState() {
    focusInput.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            'Calculate Tank',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Choose tank'),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () {
                            option = 'PPG';
                            setState(() {
                              ppg = true;
                              tdi = false;
                            });

                            if (ppg) {
                              textInput.clear();
                              setState(() {
                                //textInput.text = '';
                                heightResult = 0.0;
                                isCompleted = false;
                              });
                            }
                          },
                          child: CardTitle(
                            title: 'PPG',
                            status: ppg,
                          )),
                      GestureDetector(
                          onTap: () {
                            option = 'TDI';
                            setState(() {
                              ppg = false;
                              tdi = true;
                            });
                            if (tdi) {
                              textInput.clear();
                              setState(() {
                                //textInput.text = '';

                                heightResult = 0.0;
                                isCompleted = false;
                              });
                            }
                          },
                          child: CardTitle(
                            title: 'TDI',
                            status: tdi,
                          ))
                    ],
                  ),
                )),
            Expanded(
              child: FutureBuilder(
                future: dioService.loadTankInfo(option),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data[0];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.black.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  style: TextStyle(fontSize: 25),
                                  controller: textInput,
                                  focusNode: focusInput,
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                    setState(() {
                                      showClearIconInput = true;
                                    });
                                  },
                                  onChanged: (val) {
                                    if (textInput.text.isNotEmpty) {
                                      setState(() {
                                        showClearIconInput = true;
                                        isCompleted = true;
                                      });
                                    } else {
                                      setState(() {
                                        showClearIconInput = false;
                                        isCompleted = false;
                                        heightResult = 0.0;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Enter tank level in meter...',
                                      border: InputBorder.none,
                                      suffixIcon: showClearIconInput
                                          ? IconButton(
                                              icon: Icon(Icons.clear),
                                              iconSize: 20,
                                              onPressed: () {
                                                textInput.clear();
                                                setState(() {
                                                  showClearIconInput = false;
                                                  isCompleted = false;

                                                  heightResult = 0.0;
                                                  isCompleted = false;
                                                });
                                              },
                                            )
                                          : SizedBox.shrink())),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tank Diameter (meter)'),
                              Row(
                                children: [
                                  Text(data['diameter']),
                                  SizedBox(width: 10),
                                  if (int.parse(provider.userLevel) <= 1)
                                    GestureDetector(
                                        onTap: () {
                                          if (option == 'PPG') {
                                            setState(() {
                                              heightDimPPG = 50;
                                            });
                                          } else {
                                            setState(() {
                                              heightDimTDI = 50;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.edit, size: 18)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///edit dimPPG
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: heightDimPPG,
                            color: Colors.yellow.withOpacity(0.2),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      //width:200,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color:Colors.black)
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            controller: textDimPPG,
                                            focusNode: focusDimPPG,
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              if (textDimPPG.text.isNotEmpty) {
                                                setState(() {
                                                  showClearIconDimPPG = true;
                                                  isCompletedDimPPG = true;
                                                });
                                              } else {
                                                setState(() {
                                                  showClearIconDimPPG = false;
                                                  isCompletedDimPPG = false;
                                                  //heightResult = 0.0;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Enter value...',
                                                border: InputBorder.none,
                                                fillColor: Colors.yellow,
                                                suffixIcon: showClearIconDimPPG
                                                    ? IconButton(
                                                        icon: Icon(Icons.clear),
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          textDimPPG.clear();
                                                          setState(() {
                                                            showClearIconDimPPG =
                                                                false;
                                                            isCompletedDimPPG =
                                                                false;

                                                            //heightResult = 0.0;
                                                          });
                                                        },
                                                      )
                                                    : SizedBox.shrink())),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    ElevatedButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey)),
                                      onPressed: () {
                                        textDimPPG.clear();
                                        focusDimPPG.unfocus();

                                        setState(() {
                                          heightDimPPG = 0;
                                          showClearIconDimPPG = false;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      child: isSaveDimPPG
                                          ? Row(
                                              children: [
                                                CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('Please wait..',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )
                                          : Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        if (textDimPPG.text.isEmpty) {
                                          EasyLoading.showError(
                                              'Input some value..');
                                        } else {
                                          focusDimPPG.unfocus();
                                          showClearIconDimPPG = false;
                                          setState(() {
                                            isSaveDimPPG = true;
                                          });

                                          var res =
                                              await dioService.updateTankInfo(
                                                  textDimPPG.text, 'dPPG');
                                          if (res == 'OK') {
                                            EasyLoading.showSuccess(
                                                'Update berhasil.');
                                            setState(() {
                                              isSaveDimPPG = false;
                                              textDimPPG.clear();
                                            });
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                heightDimPPG = 0.0;
                                              });
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                'Update gagal.');
                                            setState(() {
                                              isSaveDimPPG = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ]),
                                ]),
                          ),
                        ),

                        ///edit dimTDI
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: heightDimTDI,
                            color: Colors.yellow.withOpacity(0.2),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      //width:200,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color:Colors.black)
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            controller: textDimTDI,
                                            focusNode: focusDimTDI,
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              if (textDimTDI.text.isNotEmpty) {
                                                setState(() {
                                                  showClearIconDimTDI = true;
                                                  isCompletedDimTDI = true;
                                                });
                                              } else {
                                                setState(() {
                                                  showClearIconDimTDI = false;
                                                  isCompletedDimTDI = false;
                                                  //heightResult = 0.0;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Enter value...',
                                                border: InputBorder.none,
                                                fillColor: Colors.yellow,
                                                suffixIcon: showClearIconDimTDI
                                                    ? IconButton(
                                                        icon: Icon(Icons.clear),
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          textDimTDI.clear();
                                                          setState(() {
                                                            showClearIconDimTDI =
                                                                false;
                                                            isCompletedDimTDI =
                                                                false;

                                                            //heightResult = 0.0;
                                                          });
                                                        },
                                                      )
                                                    : SizedBox.shrink())),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    ElevatedButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey)),
                                      onPressed: () {
                                        textDimTDI.clear();
                                        focusDimTDI.unfocus();

                                        setState(() {
                                          heightDimTDI = 0;
                                          showClearIconDimTDI = false;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      child: isSaveDimTDI
                                          ? Row(
                                              children: [
                                                CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('Please wait..',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )
                                          : Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        if (textDimTDI.text.isEmpty) {
                                          EasyLoading.showError(
                                              'Input some value..');
                                        } else {
                                          focusDimTDI.unfocus();
                                          showClearIconDimTDI = false;
                                          setState(() {
                                            isSaveDimTDI = true;
                                          });

                                          var res =
                                              await dioService.updateTankInfo(
                                                  textDimTDI.text, 'dTDI');
                                          if (res == 'OK') {
                                            EasyLoading.showSuccess(
                                                'Update berhasil.');
                                            setState(() {
                                              isSaveDimTDI = false;
                                              textDimTDI.clear();
                                            });
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                heightDimTDI = 0.0;
                                              });
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                'Update gagal.');
                                            setState(() {
                                              isSaveDimTDI = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ]),
                                ]),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Specific Gravity (g/cm3)'),
                              Row(
                                children: [
                                  Text(data['sg']),
                                  SizedBox(width: 10),
                                  if (int.parse(provider.userLevel) <= 1)
                                    GestureDetector(
                                        onTap: () {
                                          if (option == 'PPG') {
                                            setState(() {
                                              heightSgPPG = 50;
                                            });
                                          } else {
                                            setState(() {
                                              heightSgTDI = 50;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.edit, size: 18)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///edit sgPPG
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: heightSgPPG,
                            color: Colors.yellow.withOpacity(0.2),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      //width:200,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color:Colors.black)
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            controller: textSgPPG,
                                            focusNode: focusSgPPG,
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              if (textSgPPG.text.isNotEmpty) {
                                                setState(() {
                                                  showClearIconSgPPG = true;
                                                  isCompletedSgPPG = true;
                                                });
                                              } else {
                                                setState(() {
                                                  showClearIconSgPPG = false;
                                                  isCompletedSgPPG = false;
                                                  //heightResult = 0.0;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Enter value...',
                                                border: InputBorder.none,
                                                fillColor: Colors.yellow,
                                                suffixIcon: showClearIconSgPPG
                                                    ? IconButton(
                                                        icon: Icon(Icons.clear),
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          textSgPPG.clear();
                                                          setState(() {
                                                            showClearIconSgPPG =
                                                                false;
                                                            isCompletedSgPPG =
                                                                false;

                                                            //heightResult = 0.0;
                                                          });
                                                        },
                                                      )
                                                    : SizedBox.shrink())),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    ElevatedButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey)),
                                      onPressed: () {
                                        textSgPPG.clear();
                                        focusSgPPG.unfocus();

                                        setState(() {
                                          heightSgPPG = 0;
                                          showClearIconSgPPG = false;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      child: isSaveSgPPG
                                          ? Row(
                                              children: [
                                                CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('Please wait..',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )
                                          : Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        if (textSgPPG.text.isEmpty) {
                                          EasyLoading.showError(
                                              'Input some value..');
                                        } else {
                                          focusSgPPG.unfocus();
                                          showClearIconSgPPG = false;
                                          setState(() {
                                            isSaveSgPPG = true;
                                          });

                                          var res =
                                              await dioService.updateTankInfo(
                                                  textSgPPG.text, 'sgPPG');
                                          if (res == 'OK') {
                                            EasyLoading.showSuccess(
                                                'Update berhasil.');
                                            setState(() {
                                              isSaveSgPPG = false;
                                              textSgPPG.clear();
                                            });
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                heightSgPPG = 0.0;
                                              });
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                'Update gagal.');
                                            setState(() {
                                              isSaveSgPPG = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ]),
                                ]),
                          ),
                        ),

                        ///edit sgTDI
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: heightSgTDI,
                            color: Colors.yellow.withOpacity(0.2),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      //width:200,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color:Colors.black)
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            controller: textSgTDI,
                                            focusNode: focusSgTDI,
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              if (textSgTDI.text.isNotEmpty) {
                                                setState(() {
                                                  showClearIconSgTDI = true;
                                                  isCompletedSgTDI = true;
                                                });
                                              } else {
                                                setState(() {
                                                  showClearIconSgTDI = false;
                                                  isCompletedSgTDI = false;
                                                  //heightResult = 0.0;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Enter value...',
                                                border: InputBorder.none,
                                                fillColor: Colors.yellow,
                                                suffixIcon: showClearIconSgTDI
                                                    ? IconButton(
                                                        icon: Icon(Icons.clear),
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          textSgTDI.clear();
                                                          setState(() {
                                                            showClearIconSgTDI =
                                                                false;
                                                            isCompletedSgTDI =
                                                                false;

                                                            //heightResult = 0.0;
                                                          });
                                                        },
                                                      )
                                                    : SizedBox.shrink())),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    ElevatedButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey)),
                                      onPressed: () {
                                        textSgTDI.clear();
                                        focusSgTDI.unfocus();

                                        setState(() {
                                          heightSgTDI = 0;
                                          showClearIconSgTDI = false;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      child: isSaveSgTDI
                                          ? Row(
                                              children: [
                                                CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('Please wait..',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )
                                          : Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () async {
                                        if (textSgTDI.text.isEmpty) {
                                          EasyLoading.showError(
                                              'Input some value..');
                                        } else {
                                          focusSgTDI.unfocus();
                                          showClearIconSgTDI = false;
                                          setState(() {
                                            isSaveSgTDI = true;
                                          });

                                          var res =
                                              await dioService.updateTankInfo(
                                                  textSgTDI.text, 'sgTDI');
                                          if (res == 'OK') {
                                            EasyLoading.showSuccess(
                                                'Update berhasil.');
                                            setState(() {
                                              isSaveSgTDI = false;
                                              textSgTDI.clear();
                                            });
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                heightSgTDI = 0.0;
                                              });
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                'Update gagal.');
                                            setState(() {
                                              isSaveSgTDI = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ]),
                                ]),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: heightResult,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Volume',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '$volCalc m3',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Mass',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '$massCalc kg',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return JumpingDotsProgressIndicator(
                      fontSize: 50.0, color: Colors.orange);
                },
              ),
            ),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () async {
              if (textInput.text.isEmpty) {
                EasyLoading.showError('Input some value');
              } else {
                focusInput.unfocus();
                setState(() {
                  showClearIconInput = false;
                });

                ///perhitungan disini
                double h = double.parse(textInput.text);
                double d = double.parse(data['diameter']);
                double sg = double.parse(data['sg']) * 1000;
                var vol1 = 3.14 * ((d / 2) * (d / 2)) * h;
                var vol2 = (3.14 * ((d / 2) * (d / 2) * (d / 2))) / 24;
                var mass = (vol1 + vol2) * sg;

                setState(() {
                  heightResult = 100;
                  volCalc = (vol1 + vol2).toStringAsFixed(2);
                  massCalc = mass.toStringAsFixed(2);
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Material(
                elevation: 2,
                color:
                    isCompleted ? Theme.of(context).primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: 100,
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
                          "CALCULATE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardTitle extends StatefulWidget {
  final String title;
  final bool status;
  CardTitle({this.title, this.status});

  @override
  _CardTitleState createState() => _CardTitleState();
}

class _CardTitleState extends State<CardTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.grey[300]),
            color: widget.status == true
                ? Colors.teal.withOpacity(0.2)
                : Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class CardEdit extends StatefulWidget {
  TextEditingController controller;
  FocusNode focus;
  bool showClearIcon;
  bool isError;
  bool isCompleted;
  bool isSave;
  double height;
  Function(bool) callback;

  CardEdit(
      {this.controller,
      this.focus,
      this.showClearIcon,
      this.isError,
      this.isCompleted,
      this.isSave,
      this.height,
      this.callback});

  @override
  _CardEditState createState() => _CardEditState();
}

class _CardEditState extends State<CardEdit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: widget.height,
        color: Colors.yellow.withOpacity(0.2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
                //border: Border.all(color:Colors.black)
                ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focus,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (widget.controller.text.isNotEmpty) {
                      setState(() {
                        widget.showClearIcon = true;
                        widget.isCompleted = true;
                      });
                    } else {
                      setState(() {
                        widget.showClearIcon = false;
                        widget.isCompleted = false;
                        //heightResult = 0.0;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter value...',
                      border: InputBorder.none,
                      fillColor: Colors.yellow,
                      suffixIcon: widget.showClearIcon
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              iconSize: 20,
                              onPressed: () {
                                widget.controller.clear();
                                setState(() {
                                  widget.showClearIcon = false;
                                  widget.isCompleted = false;

                                  //heightResult = 0.0;
                                });
                              },
                            )
                          : SizedBox.shrink())),
            ),
          ),
          Row(children: [
            ElevatedButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.grey)),
              onPressed: () {
                widget.controller.clear();
                widget.focus.unfocus();

                setState(() {
                  widget.height = 0;
                  widget.callback(false);
                });
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: widget.isSave
                  ? Row(
                      children: [
                        CupertinoActivityIndicator(
                          radius: 10,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Please wait..',
                            style: TextStyle(color: Colors.white))
                      ],
                    )
                  : Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: () async {
                setState(() {
                  widget.isSave = true;
                });
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
