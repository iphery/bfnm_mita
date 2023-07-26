import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CH03 extends StatefulWidget {
  final String kelas;
  CH03({this.kelas});

  @override
  _CH03State createState() => _CH03State();
}

class _CH03State extends State<CH03> {
  bool _h101 = false;
  String _h101s = '';
  String _h101d = 'Selang';
  bool _h102 = false;
  String _h102s = '';
  String _h102d = 'Nozzle';
  bool _h103 = false;
  String _h103s = '';
  String _h103d = 'Kran';
  bool _value = false;

  bool isLoading = false;
  bool isCompleted = false;

  final textEditingProblem = TextEditingController();
  final textEditingSolution = TextEditingController();
  final textEditingTekanan = TextEditingController();

  FocusNode focusProblem = FocusNode();
  FocusNode focusSolution = FocusNode();
  FocusNode focusTekanan = FocusNode();

  bool showClearIconProblem = false;
  bool showClearIconSolution = false;
  bool showClearIconTekanan = false;
  bool isError = false;

  int count = 0;

  DioService dioService = DioService();
  bool isKeyBShow = false;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      print(visible);
      if (visible) {
        isKeyBShow = true;
      } else {
        isKeyBShow = false;
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
            'Checklist H03',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          //physics: AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.only(bottom: 100.0),
            child: Column(
              children: [
                Container(
                    color: Colors.deepOrange.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Checklist Kontrol Hydrant Box'),
                          Text('CL.ME.003/0'),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),

                CheckboxListTile(
                  title: const Text('Selang'),
                  subtitle: const Text('Pastikan selang tidak bocor, robek.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h101,
                  value: _h101,
                  onChanged: (bool value) {
                    setState(() {
                      _h101 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Nozzle'),
                  subtitle: const Text(
                      'Pastikan nozzle tidak bocor dan berfungsi dengan baik.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h102,
                  value: _h102,
                  onChanged: (bool value) {
                    setState(() {
                      _h102 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Kran'),
                  subtitle: const Text('Pastikan tidak bocor, karat.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h103,
                  value: _h103,
                  onChanged: (bool value) {
                    setState(() {
                      _h103 = value;
                    });
                    checkComplete();
                  },
                ),

                ///input tekanan
                Padding(
                  padding: const EdgeInsets.only(
                      left: 70.0, right: 20, top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.deepOrange.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: textEditingTekanan,
                        focusNode: focusTekanan,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          if (textEditingTekanan.text.isNotEmpty) {
                            setState(() {
                              showClearIconTekanan = true;
                            });
                          } else {
                            setState(() {
                              showClearIconTekanan = false;
                            });
                          }

                          checkComplete();
                        },
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: 'Tulis tekanan gauge jika ada (bar)',
                            border: InputBorder.none,
                            suffixIcon: showClearIconTekanan
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    iconSize: 20,
                                    onPressed: () {
                                      textEditingTekanan.clear();
                                      setState(() {
                                        showClearIconTekanan = false;
                                        isCompleted = false;
                                      });
                                    },
                                  )
                                : SizedBox.shrink()),
                      ),
                    ),
                  ),
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
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: 'Deskripsikan kerusakan mesin...',
                            border: InputBorder.none,
                            suffixIcon: showClearIconProblem
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
                          if (textEditingProblem.text.isNotEmpty) {
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
                                suffixIcon: showClearIconSolution
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
                                suffixIcon: showClearIconSolution
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
                    focusProblem.unfocus();
                    focusSolution.unfocus();
                    focusTekanan.unfocus();
                    if (isCompleted) {
                      setState(() {
                        isLoading = true;
                      });
                      String tekanan;
                      var provider =
                          Provider.of<AssetProvider>(context, listen: false);
                      if (_h101) {
                        _h101s = 'H301:$_h101d:Periksa#';
                      } else {
                        _h101s = '';
                      }
                      if (_h102) {
                        _h102s = 'H302:$_h101d:Periksa#';
                      } else {
                        _h102s = '';
                      }
                      if (_h103) {
                        _h103s = 'H303:$_h101d:Periksa#';
                      } else {
                        _h103s = '';
                      }
                      if (textEditingTekanan.text.isNotEmpty) {
                        tekanan =
                            'H304:Tekanan Gauge ${textEditingTekanan.text} bar:Periksa#';
                      } else {
                        tekanan = 'H304:Tekanan Gauge N/A:Periksa#';
                      }

                      String result = _h101s + _h102s + _h103s + tekanan;
                      String problem = textEditingProblem.text;
                      String solution = textEditingSolution.text;
                      print(result);

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
    if (_h101 && _h102 && _h103) {
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
