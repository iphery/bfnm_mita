import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CP01 extends StatefulWidget {
  final String kelas;
  CP01({this.kelas});

  @override
  _CP01State createState() => _CP01State();
}

class _CP01State extends State<CP01> {
  bool _p101 = false;
  String _p101s = '';
  bool _p102 = false;
  String _p102s = '';
  bool _p103 = false;
  String _p103s = '';
  bool _p104 = false;
  String _p104s = '';

  bool _value = false;

  bool isLoading = false;
  bool isCompleted = false;

  final textEditingProblem = TextEditingController();
  final textEditingSolution = TextEditingController();

  FocusNode focusProblem = FocusNode();
  FocusNode focusSolution = FocusNode();

  bool showClearIconProblem = false;
  bool showClearIconSolution = false;
  bool isError = false;

  int count = 0;

  final textRS = TextEditingController();
  FocusNode focusRS = FocusNode();
  bool clearRS = false;
  bool errorRS = false;

  final textRT = TextEditingController();
  FocusNode focusRT = FocusNode();
  bool clearRT = false;
  bool errorRT = false;

  final textST = TextEditingController();
  FocusNode focusST = FocusNode();
  bool clearST = false;
  bool errorST = false;

  final textRN = TextEditingController();
  FocusNode focusRN = FocusNode();
  bool clearRN = false;
  bool errorRN = false;

  final textSN = TextEditingController();
  FocusNode focusSN = FocusNode();
  bool clearSN = false;
  bool errorSN = false;

  final textTN = TextEditingController();
  FocusNode focusTN = FocusNode();
  bool clearTN = false;
  bool errorTN = false;

  final textPhaseR = TextEditingController();
  FocusNode focusPhaseR = FocusNode();
  bool clearPhaseR = false;
  bool errorPhaseR = false;

  final textPhaseS = TextEditingController();
  FocusNode focusPhaseS = FocusNode();
  bool clearPhaseS = false;
  bool errorPhaseS = false;

  final textPhaseT = TextEditingController();
  FocusNode focusPhaseT = FocusNode();
  bool clearPhaseT = false;
  bool errorPhaseT = false;

  DioService dioService = DioService();
  bool isKeyBShow = false;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      //print(visible);
      if (visible) {
        //setState(() {
        isKeyBShow = true;
        //});
      } else {
        //setState(() {
        isKeyBShow = false;

        //});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Checklist P01',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          //physics: AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.only(bottom: 80.0),
            child: Column(
              children: [
                Container(
                    color: Colors.deepOrange.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Checklist Panel Listrik'),
                          Text('F.ME.013/0'),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Pemeriksaan Fisik',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                ///panel
                CheckboxListTile(
                  title: const Text('Panel'),
                  subtitle: const Text(
                      'Panel dalam kondisi baik, tidak penyok/rusak, pintu panel tidak rusak.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _p101,
                  value: _p101,
                  onChanged: (bool value) {
                    setState(() {
                      _p101 = value;
                    });
                    checkComplete();
                  },
                ),

                ///mcb
                CheckboxListTile(
                  title: const Text('MCCB/MCB'),
                  subtitle: const Text(
                      'Tidak ada bekas terbakar. Handle tidak rusak/patah.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _p102,
                  value: _p102,
                  onChanged: (bool value) {
                    setState(() {
                      _p102 = value;
                    });
                    checkComplete();
                  },
                ),

                ///Kabel
                CheckboxListTile(
                  title: const Text('Kabel'),
                  subtitle: const Text('Tidak kendor/ lepas/ robek.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _p103,
                  value: _p103,
                  onChanged: (bool value) {
                    setState(() {
                      _p103 = value;
                    });
                    checkComplete();
                  },
                ),

                ///Indikator
                CheckboxListTile(
                  title: const Text('Meter / Lampu Indikator'),
                  subtitle: const Text('Masih berfungsi dengan baik.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _p104,
                  value: _p104,
                  onChanged: (bool value) {
                    setState(() {
                      _p104 = value;
                    });
                    checkComplete();
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),

                Text(
                  'Pengukuran Tegangan 380V',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///R-S
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('R-S'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorRS
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textRS,
                                    focusNode: focusRS,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textRS.text.isNotEmpty) {
                                        setState(() {
                                          clearRS = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRS = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textRS.text.isNotEmpty) {
                                        setState(() {
                                          clearRS = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRS = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearRS && focusRS.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textRS.clear();
                                                  setState(() {
                                                    clearRS = false;
                                                    isCompleted = false;
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
                      ),

                      ///R-T
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('R-T'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorRT
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textRT,
                                    focusNode: focusRT,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textRT.text.isNotEmpty) {
                                        setState(() {
                                          clearRT = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRT = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textRT.text.isNotEmpty) {
                                        setState(() {
                                          clearRT = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRT = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearRT && focusRT.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textRT.clear();
                                                  setState(() {
                                                    clearRT = false;
                                                    isCompleted = false;
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
                      ),

                      ///S-T
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('S-T'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorST
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textST,
                                    focusNode: focusST,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textST.text.isNotEmpty) {
                                        setState(() {
                                          clearST = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearST = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textST.text.isNotEmpty) {
                                        setState(() {
                                          clearST = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearST = false;
                                          isCompleted = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearST && focusST.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textST.clear();
                                                  setState(() {
                                                    clearST = false;
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
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),

                Text(
                  'Pengukuran Tegangan 220V',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///R-N
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('R-N'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorRN
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textRN,
                                    focusNode: focusRN,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textRN.text.isNotEmpty) {
                                        setState(() {
                                          clearRN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRN = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textRN.text.isNotEmpty) {
                                        setState(() {
                                          clearRN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearRN = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearRN && focusRN.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textRN.clear();
                                                  setState(() {
                                                    clearRN = false;
                                                    isCompleted = false;
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
                      ),

                      ///S-N
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('S-N'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorSN
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textSN,
                                    focusNode: focusSN,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textSN.text.isNotEmpty) {
                                        setState(() {
                                          clearSN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearSN = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textSN.text.isNotEmpty) {
                                        setState(() {
                                          clearSN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearSN = false;
                                          isCompleted = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearSN && focusSN.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textSN.clear();
                                                  setState(() {
                                                    clearSN = false;
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
                      ),

                      ///T-N
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('T-N'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorTN
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textTN,
                                    focusNode: focusTN,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textTN.text.isNotEmpty) {
                                        setState(() {
                                          clearTN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearTN = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textTN.text.isNotEmpty) {
                                        setState(() {
                                          clearTN = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearTN = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Volt',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon: clearTN && focusTN.hasFocus
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                iconSize: 20,
                                                onPressed: () {
                                                  textTN.clear();
                                                  setState(() {
                                                    clearTN = false;
                                                    isCompleted = false;
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
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),

                Text(
                  'Pengukuran Beban Arus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///R
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('Phase R'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorPhaseR
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textPhaseR,
                                    focusNode: focusPhaseR,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textPhaseR.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseR = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseR = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textPhaseR.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseR = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseR = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Ampere',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon:
                                            clearPhaseR && focusPhaseR.hasFocus
                                                ? IconButton(
                                                    icon: Icon(Icons.clear),
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      textPhaseR.clear();
                                                      setState(() {
                                                        clearPhaseR = false;
                                                        isCompleted = false;
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
                      ),

                      ///S
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('Phase S'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorPhaseS
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textPhaseS,
                                    focusNode: focusPhaseS,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textPhaseS.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseS = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseS = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textPhaseS.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseS = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseS = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Ampere',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon:
                                            clearPhaseS && focusPhaseS.hasFocus
                                                ? IconButton(
                                                    icon: Icon(Icons.clear),
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      textPhaseS.clear();
                                                      setState(() {
                                                        clearPhaseS = false;
                                                        isCompleted = false;
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
                      ),

                      ///T
                      Expanded(
                        flex: 30,
                        child: Column(
                          children: [
                            Text('Phase R'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                        color: errorPhaseT
                                            ? Colors.red
                                            : Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextField(
                                    controller: textPhaseT,
                                    focusNode: focusPhaseT,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      if (textPhaseT.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseT = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseT = false;
                                        });
                                      }
                                      checkComplete();
                                    },
                                    onTap: () {
                                      if (textPhaseT.text.isNotEmpty) {
                                        setState(() {
                                          clearPhaseT = true;
                                        });
                                      } else {
                                        setState(() {
                                          clearPhaseT = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Ampere',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        suffixIcon:
                                            clearPhaseT && focusPhaseT.hasFocus
                                                ? IconButton(
                                                    icon: Icon(Icons.clear),
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      textPhaseT.clear();
                                                      setState(() {
                                                        clearPhaseT = false;
                                                        isCompleted = false;
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
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Informasi Lain'),
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
                        controller: textEditingProblem,
                        focusNode: focusProblem,
                        onChanged: (val) {
                          if (textEditingProblem.text.isNotEmpty) {
                            setState(() {
                              showClearIconProblem = true;
                            });
                          } else {
                            setState(() {
                              showClearIconProblem = false;
                            });
                          }
                        },
                        onTap: () {
                          if (textEditingProblem.text.isNotEmpty) {
                            setState(() {
                              showClearIconProblem = true;
                            });
                          } else {
                            setState(() {
                              showClearIconProblem = false;
                            });
                          }
                        },
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: 'Deskripsikan kerusakan mesin...',
                            border: InputBorder.none,
                            suffixIcon:
                                showClearIconProblem && focusProblem.hasFocus
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        iconSize: 20,
                                        onPressed: () {
                                          textEditingProblem.clear();
                                          setState(() {
                                            showClearIconProblem = false;
                                          });
                                        },
                                      )
                                    : SizedBox.shrink()),
                      ),
                    ),
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
                        controller: textEditingSolution,
                        focusNode: focusSolution,
                        onChanged: (val) {
                          if (textEditingSolution.text.isNotEmpty) {
                            setState(() {
                              showClearIconSolution = true;
                            });
                          } else {
                            setState(() {
                              showClearIconSolution = false;
                            });
                          }
                        },
                        onTap: () {
                          if (textEditingSolution.text.isNotEmpty) {
                            setState(() {
                              showClearIconSolution = true;
                            });
                          } else {
                            setState(() {
                              showClearIconSolution = false;
                            });
                          }
                        },
                        minLines: 1,
                        maxLines: 3,
                        decoration: isError
                            ? InputDecoration(
                                hintText: 'Tuliskan tindakan perbaikan...',
                                border: InputBorder.none,
                                errorText: 'Kolom tidak boleh kosong',
                                suffixIcon: showClearIconSolution &&
                                        focusProblem.hasFocus
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        iconSize: 20,
                                        onPressed: () {
                                          textEditingSolution.clear();
                                          setState(() {
                                            showClearIconSolution = false;
                                          });
                                        },
                                      )
                                    : SizedBox.shrink())
                            : InputDecoration(
                                hintText: 'Tuliskan tindakan perbaikan...',
                                border: InputBorder.none,
                                suffixIcon: showClearIconSolution &&
                                        focusSolution.hasFocus
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        iconSize: 20,
                                        onPressed: () {
                                          textEditingSolution.clear();
                                          setState(() {
                                            showClearIconSolution = false;
                                          });
                                        },
                                      )
                                    : SizedBox.shrink()),
                      ),
                    ),
                  ),
                ),

                //Chec
              ],
            ),
          ),
        ),
        bottomSheet: isKeyBShow
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () async {
                    focusRS.unfocus();
                    focusRT.unfocus();
                    focusST.unfocus();
                    focusRN.unfocus();
                    focusSN.unfocus();
                    focusTN.unfocus();
                    focusPhaseR.unfocus();
                    focusPhaseS.unfocus();
                    focusPhaseT.unfocus();
                    focusProblem.unfocus();
                    focusSolution.unfocus();

                    if (isCompleted) {
                      setState(() {
                        isLoading = true;
                      });

                      var provider =
                          Provider.of<AssetProvider>(context, listen: false);
                      if (_p101) {
                        _p101s = 'P101:Panel:Periksa#';
                      } else {
                        _p101s = '';
                      }
                      if (_p102) {
                        _p102s = 'P102:MCCB/MCB:Periksa#';
                      } else {
                        _p102s = '';
                      }
                      if (_p103) {
                        _p103s = 'P103:Kabel:Periksa#';
                      } else {
                        _p103s = '';
                      }
                      if (_p104) {
                        _p104s = 'P104:Meter/Lampu Indikator:Periksa#';
                      } else {
                        _p104s = '';
                      }
                      String rs = 'P105:R-S ${textRS.text} Volt:#';
                      String rt = 'P106:R-T ${textRT.text} Volt:#';
                      String st = 'P107:S-T ${textST.text} Volt:#';
                      String rn = 'P108:R-N ${textRN.text} Volt:#';
                      String sn = 'P109:S-N ${textSN.text} Volt:#';
                      String tn = 'P110:T-N ${textTN.text} Volt:#';
                      String phaser =
                          'P111:Phase R ${textPhaseR.text} Ampere:#';
                      String phases =
                          'P112:Phase S ${textPhaseS.text} Ampere:#';
                      String phaset =
                          'P113:Phase T ${textPhaseT.text} Ampere:#';

                      String result = _p101s +
                          _p102s +
                          _p103s +
                          _p104s +
                          rs +
                          rt +
                          st +
                          rn +
                          sn +
                          tn +
                          phaser +
                          phases +
                          phaset;
                      String problem = textEditingProblem.text;
                      String solution = textEditingSolution.text;

                      var res = await dioService.getMaintenanceComplete(
                          provider.selectedIdCase,
                          result,
                          problem,
                          solution,
                          widget.kelas);
                      if (res == 'OK') {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context, 'completed');
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialogError();
                      }
                    } else {
                      showDialog();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 2,
                      color: isCompleted
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
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
                                "SUBMIT",
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

  void checkComplete() {
    if (_p101 &&
        _p102 &&
        _p103 &&
        _p104 &&
        textRS.text.length > 0 &&
        textRT.text.length > 0 &&
        textST.text.length > 0 &&
        textRN.text.length > 0 &&
        textSN.text.length > 0 &&
        textTN.text.length > 0 &&
        textPhaseR.text.length > 0 &&
        textPhaseS.text.length > 0 &&
        textPhaseT.text.length > 0) {
      setState(() {
        isCompleted = true;
      });
    } else {
      setState(() {
        isCompleted = false;
      });
    }
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Form checklist tidak lengkap !'),
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
                },
              )
            ],
          );
        });
  }

  showDialogError() {
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
