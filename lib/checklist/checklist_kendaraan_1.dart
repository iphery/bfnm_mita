import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CK01 extends StatefulWidget {
  final String kelas;
  CK01({this.kelas});

  @override
  _CK01State createState() => _CK01State();
}

class _CK01State extends State<CK01> {
  bool _k101 = false;
  String _k101s = '';
  bool _k102 = false;
  String _k102s = '';
  bool _k103 = false;
  String _k103s = '';
  bool _k104 = false;
  String _k104s = '';
  bool _k105 = false;
  String _k105s = '';

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
            'Checklist K01',
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
                    color: Colors.green.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Servis Ringan'),
                        ),
                      ],
                    )),
                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Mesin'),
                        ),
                      ],
                    )),

                CheckboxListTile(
                  title: const Text('Ganti oli mesin'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _k101,
                  value: _k101,
                  onChanged: (bool value) {
                    setState(() {
                      _k101 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa saringan oli'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _k102,
                  value: _k102,
                  onChanged: (bool value) {
                    setState(() {
                      _k102 = value;
                    });
                    checkComplete();
                  },
                ),

                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistem Roda'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title:
                      const Text('Periksa tekanan, kerusakan dan keausan ban.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _k103,
                  value: _k103,
                  onChanged: (bool value) {
                    setState(() {
                      _k103 = value;
                    });
                    checkComplete();
                  },
                ),

                ///kelistrikan

                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistem Kelistrikan'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title: const Text(
                      'Periksa Air Accu (tambahkan jika diperlukan.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _k104,
                  value: _k104,
                  onChanged: (bool value) {
                    setState(() {
                      _k104 = value;
                    });
                    checkComplete();
                  },
                ),

                ///safety

                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Kelengkapan Safety'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title: const Text('Periksa kelengkapan kotak P3K & Apar'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _k105,
                  value: _k105,
                  onChanged: (bool value) {
                    setState(() {
                      _k105 = value;
                    });
                    checkComplete();
                  },
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
                    if (isCompleted) {
                      setState(() {
                        isLoading = true;
                      });

                      var provider =
                          Provider.of<AssetProvider>(context, listen: false);
                      if (_k101) {
                        _k101s = 'K011:Oli mesin:Ganti#';
                      } else {
                        _k101s = '';
                      }
                      if (_k102) {
                        _k102s = 'K012:Saringan udara:Periksa#';
                      } else {
                        _k102s = '';
                      }
                      if (_k103) {
                        _k103s =
                            'K013:Tekanan, kerusakan dan keausan ban:Periksa#';
                      } else {
                        _k103s = '';
                      }
                      if (_k104) {
                        _k104s = 'K014:Air accu:Periksa#';
                      } else {
                        _k104s = '';
                      }
                      if (_k105) {
                        _k105s = 'K015:Kotak P3K dan Apar:Periksa#';
                      } else {
                        _k105s = '';
                      }

                      String result =
                          _k101s + _k102s + _k103s + _k104s + _k105s;
                      String problem =
                          'Perawatan rutin. ${textEditingProblem.text}.';
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
    if (_k101 && _k102 && _k103 && _k105) {
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
