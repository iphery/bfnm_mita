import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CK02 extends StatefulWidget {
  final String kelas;
  CK02({this.kelas});

  @override
  _CK02State createState() => _CK02State();
}

class _CK02State extends State<CK02> {
  bool _k201 = false;
  String _k201s = '';
  bool _k202 = false;
  String _k202s = '';
  bool _k203 = false;
  String _k203s = '';
  bool _k204 = false;
  String _k204s = '';
  bool _k205 = false;
  String _k205s = '';
  bool _k206 = false;
  String _k206s = '';
  bool _k207 = false;
  String _k207s = '';
  bool _k208 = false;
  String _k208s = '';
  bool _k209 = false;
  String _k209s = '';
  bool _k210 = false;
  String _k210s = '';
  bool _k211 = false;
  String _k211s = '';

  ///not used
  bool _k212 = false;
  String _k212s = '';
  bool _k213 = false;
  String _k213s = '';
  bool _k214 = false;
  String _k214s = '';
  bool _k215 = false;
  String _k215s = '';

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
            'Checklist K02',
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
                    color: Colors.yellow.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Servis Sedang'),
                        ),
                      ],
                    )),

                ///mesin
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
                  title: const Text('Ganti oli mesin.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k201,
                  value: _k201,
                  onChanged: (bool value) {
                    setState(() {
                      _k201 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ganti saringan oli.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k202,
                  value: _k202,
                  onChanged: (bool value) {
                    setState(() {
                      _k202 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa saringan udara.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k203,
                  value: _k203,
                  onChanged: (bool value) {
                    setState(() {
                      _k203 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa air pendingin mesin.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k204,
                  value: _k204,
                  onChanged: (bool value) {
                    setState(() {
                      _k204 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa V-belt'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k205,
                  value: _k205,
                  onChanged: (bool value) {
                    setState(() {
                      _k205 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem roda
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
                      const Text('Periksa tekanan, kerusakan dan keausan ban'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k206,
                  value: _k206,
                  onChanged: (bool value) {
                    setState(() {
                      _k206 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem rem
                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistem Rem'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title: const Text(
                      'Periksa keausan, kebocoran dan kerusakan Disc & Pad'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k207,
                  value: _k207,
                  onChanged: (bool value) {
                    setState(() {
                      _k207 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem kelistrikan
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
                  title:
                      const Text('Periksa air Accu (tambah jika diperlukan)'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k208,
                  value: _k208,
                  onChanged: (bool value) {
                    setState(() {
                      _k208 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title:
                      const Text('Periksa klem-klem dan kabel-kabel listrik'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k209,
                  value: _k209,
                  onChanged: (bool value) {
                    setState(() {
                      _k209 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa kerja sistem lampu dan meter.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k210,
                  value: _k210,
                  onChanged: (bool value) {
                    setState(() {
                      _k210 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem safety
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
                  activeColor: Colors.yellow,
                  checkColor: Colors.white,
                  selected: _k211,
                  value: _k211,
                  onChanged: (bool value) {
                    setState(() {
                      _k211 = value;
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
                            hintText:
                                'Deskripsikan kerusakan mesin (jika ada)...',
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
                      if (_k201) {
                        _k201s = 'K201:Oli mesin:Ganti#';
                      } else {
                        _k201s = '';
                      }
                      if (_k202) {
                        _k202s = 'K202:Saringan oli:Ganti#';
                      } else {
                        _k202s = '';
                      }
                      if (_k203) {
                        _k203s = 'K203:Saringan udara:Periksa#';
                      } else {
                        _k203s = '';
                      }
                      if (_k204) {
                        _k204s = 'K204:Air pendingin mesin:Periksa#';
                      } else {
                        _k204s = '';
                      }
                      if (_k205) {
                        _k205s = 'K205:Vbelt:Periksa#';
                      } else {
                        _k205s = '';
                      }
                      if (_k206) {
                        _k206s =
                            'K206:Tekanan, kerusakan dan keausan ban:Periksa#';
                      } else {
                        _k206s = '';
                      }
                      if (_k207) {
                        _k207s =
                            'K207:Keausan, kebocoran dan kerusakan Disc & Pad:Periksa#';
                      } else {
                        _k207s = '';
                      }

                      if (_k208) {
                        _k208s = 'K208:Air accu:Periksa#';
                      } else {
                        _k208s = '';
                      }
                      if (_k209) {
                        _k209s =
                            'K209:Klem-klem dan kerusakan kabel-kabel listrik:Periksa#';
                      } else {
                        _k209s = '';
                      }
                      if (_k210) {
                        _k210s = 'K210:Kerja sistem lampu dan meter:Periksa#';
                      } else {
                        _k210s = '';
                      }
                      if (_k211) {
                        _k211s = 'K211:Kotak P3K dan Apar:Periksa#';
                      } else {
                        _k211s = '';
                      }

                      String result = _k201s +
                          _k202s +
                          _k203s +
                          _k204s +
                          _k205s +
                          _k206s +
                          _k207s +
                          _k208s +
                          _k209s +
                          _k210s +
                          _k211s;
                      String problem =
                          'Perawatan rutin. ${textEditingProblem.text}.';
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
    if (_k201 &&
        _k202 &&
        _k203 &&
        _k204 &&
        _k205 &&
        _k206 &&
        _k207 &&
        _k208 &&
        _k209 &&
        _k210) {
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
