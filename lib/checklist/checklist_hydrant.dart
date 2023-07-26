import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CH02 extends StatefulWidget {
  final String kelas;
  CH02({this.kelas});

  @override
  _CH02State createState() => _CH02State();
}

class _CH02State extends State<CH02> {
  bool _h101 = false;
  String _h101s = '';
  String _h101d = 'Tekanan Mesin';

  bool _h102 = false;
  String _h102s = '';
  String _h102d = 'Pompa Sumur';

  bool _h103 = false;
  String _h103s = '';
  String _h103d = 'Ketinggian Air';

  bool _h104 = false;
  String _h104s = '';
  String _h104d = 'Pompa Jockey';

  bool _h105 = false;
  String _h105s = '';
  String _h105d = 'Pompa Hydrant';

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
        setState(() {
          isKeyBShow = true;
        });
      } else {
        setState(() {
          isKeyBShow = false;
        });
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
            'Checklist H02',
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
                          Text('Checklist Kontrol Hydrant'),
                          Text('CL.ME.003/0'),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),

                CheckboxListTile(
                  title: Text(_h101d),
                  subtitle: const Text(
                      'Tekanan mesin masih standby pada posisi 6-8 bar.'),
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
                            hintText: 'Tulis tekanan mesin... (bar)',
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

                ///pompa sumur
                CheckboxListTile(
                  title: Text(_h102d),
                  subtitle: const Text(
                      'Pompa sumur untuk mengisi tangki air bgerfungsi'),
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

                ///ketinggian air
                CheckboxListTile(
                  title: Text(_h103d),
                  subtitle: const Text(
                      'Ketinggian air pada tangki air pada posisi maksimum.'),
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

                ///pompa jockey
                CheckboxListTile(
                  title: Text(_h104d),
                  subtitle: const Text('Pompa jockey masih berfungsi.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h104,
                  value: _h104,
                  onChanged: (bool value) {
                    setState(() {
                      _h104 = value;
                    });
                    checkComplete();
                  },
                ),

                ///pompa hidrant
                CheckboxListTile(
                  title: Text(_h105d),
                  subtitle: const Text('Pompa hidrant masih berfungsi'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h105,
                  value: _h105,
                  onChanged: (bool value) {
                    setState(() {
                      _h105 = value;
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
                    focusTekanan.unfocus();
                    if (isCompleted) {
                      setState(() {
                        isLoading = true;
                      });
                      var provider =
                          Provider.of<AssetProvider>(context, listen: false);
                      if (_h101) {
                        _h101s =
                            'H101:$_h101d (${textEditingTekanan.text}):Periksa#';
                      } else {
                        _h101s = '';
                      }
                      if (_h102) {
                        _h102s = 'H102:$_h102d:Periksa#';
                      } else {
                        _h102s = '';
                      }
                      if (_h103) {
                        _h103s = 'H103:$_h103d:Periksa#';
                      } else {
                        _h103s = '';
                      }
                      if (_h104) {
                        _h104s = 'H104:$_h104d:Periksa#';
                      } else {
                        _h104s = '';
                      }
                      if (_h105) {
                        _h105s = 'H105:$_h105d:Periksa#';
                      } else {
                        _h105s = '';
                      }

                      String result =
                          _h101s + _h102s + _h103s + _h104s + _h105s;
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
    if (_h101 &&
        _h102 &&
        _h103 &&
        _h104 &&
        _h105 &&
        textEditingTekanan.text.isNotEmpty) {
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
