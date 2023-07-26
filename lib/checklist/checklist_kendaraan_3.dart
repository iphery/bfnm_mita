import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CK03 extends StatefulWidget {
  final String kelas;
  CK03({this.kelas});

  @override
  _CK03State createState() => _CK03State();
}

class _CK03State extends State<CK03> {
  bool _k301 = false;
  String _k301s = '';
  bool _k302 = false;
  String _k302s = '';
  bool _k303 = false;
  String _k303s = '';
  bool _k304 = false;
  String _k304s = '';
  bool _k305 = false;
  String _k305s = '';
  bool _k306 = false;
  String _k306s = '';
  bool _k307 = false;
  String _k307s = '';
  bool _k308 = false;
  String _k308s = '';
  bool _k309 = false;
  String _k309s = '';
  bool _k310 = false;
  String _k310s = '';
  bool _k311 = false;
  String _k311s = '';

  ///not used
  bool _k312 = false;
  String _k312s = '';
  bool _k313 = false;
  String _k313s = '';
  bool _k314 = false;
  String _k314s = '';
  bool _k315 = false;
  String _k315s = '';
  bool _k316 = false;
  String _k316s = '';
  bool _k317 = false;
  String _k317s = '';
  bool _k318 = false;
  String _k318s = '';
  bool _k319 = false;
  String _k319s = '';

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
            'Checklist K03',
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
                    color: Colors.red.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Servis Besar'),
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k301,
                  value: _k301,
                  onChanged: (bool value) {
                    setState(() {
                      _k301 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ganti saringan oli.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k302,
                  value: _k302,
                  onChanged: (bool value) {
                    setState(() {
                      _k302 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ganti saringan udara.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k303,
                  value: _k303,
                  onChanged: (bool value) {
                    setState(() {
                      _k303 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ganti saringan bahan bakar.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k304,
                  value: _k304,
                  onChanged: (bool value) {
                    setState(() {
                      _k304 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ganti air pendingin mesin.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k305,
                  value: _k305,
                  onChanged: (bool value) {
                    setState(() {
                      _k305 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa V-belt'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k306,
                  value: _k306,
                  onChanged: (bool value) {
                    setState(() {
                      _k306 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem pemindah gigi
                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistem Pemindah Gigi'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title: const Text('Ganti oli Gardan dan Transmisi'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k307,
                  value: _k307,
                  onChanged: (bool value) {
                    setState(() {
                      _k307 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem suspensi
                Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistem Suspensi'),
                        ),
                      ],
                    )),
                CheckboxListTile(
                  title: const Text(
                      'Periksa kebocoran oli dan kerusakan Shock Absorber'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k308,
                  value: _k308,
                  onChanged: (bool value) {
                    setState(() {
                      _k308 = value;
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
                      const Text('Periksa tekanan, kerusakan dan keausan ban.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k309,
                  value: _k309,
                  onChanged: (bool value) {
                    setState(() {
                      _k309 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa bunyi-bunyi roda.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k310,
                  value: _k310,
                  onChanged: (bool value) {
                    setState(() {
                      _k310 = value;
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
                      'Periksa keausan, kebocoran dan kerusakan Disc & Pad.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k311,
                  value: _k311,
                  onChanged: (bool value) {
                    setState(() {
                      _k311 = value;
                    });
                    checkComplete();
                  },
                ),

                ///sistem chasis
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
                      'Periksa kekencangan dan kerusakan knalpot & pipa Exhaust.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k312,
                  value: _k312,
                  onChanged: (bool value) {
                    setState(() {
                      _k312 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                      'Periksa kekencangan dan kondisi semua pintu dan tutup mesin.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k313,
                  value: _k313,
                  onChanged: (bool value) {
                    setState(() {
                      _k313 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                      'Periksa kondisi chasis dan body serta beri gemuk.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k314,
                  value: _k314,
                  onChanged: (bool value) {
                    setState(() {
                      _k314 = value;
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
                  title: const Text('Ganti Busi (jika ada).'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k315,
                  value: _k315,
                  onChanged: (bool value) {
                    setState(() {
                      _k315 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title:
                      const Text('Periksa air Accu (tambah jika diperlukan)'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k316,
                  value: _k316,
                  onChanged: (bool value) {
                    setState(() {
                      _k316 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title:
                      const Text('Periksa klem-klem dan kabel-kabel listrik.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k317,
                  value: _k317,
                  onChanged: (bool value) {
                    setState(() {
                      _k317 = value;
                    });
                    checkComplete();
                  },
                ),
                CheckboxListTile(
                  title: const Text('Periksa kerja sistem lampu dan meter.'),
                  //subtitle: const Text('d.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k318,
                  value: _k318,
                  onChanged: (bool value) {
                    setState(() {
                      _k318 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _k319,
                  value: _k319,
                  onChanged: (bool value) {
                    setState(() {
                      _k319 = value;
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
                      if (_k301) {
                        _k301s = 'K301:Oli mesin:Ganti#';
                      } else {
                        _k301s = '';
                      }
                      if (_k302) {
                        _k302s = 'K302:Saringan oli:Ganti#';
                      } else {
                        _k302s = '';
                      }
                      if (_k303) {
                        _k303s = 'K303:Saringan udara:Ganti#';
                      } else {
                        _k303s = '';
                      }
                      if (_k304) {
                        _k304s = 'K304:Saringan bahan bakar:Ganti#';
                      } else {
                        _k304s = '';
                      }
                      if (_k305) {
                        _k305s = 'K305:Air pendingin mesin:Ganti#';
                      } else {
                        _k305s = '';
                      }

                      if (_k306) {
                        _k306s = 'K306:V-belt:Periksa#';
                      } else {
                        _k306s = '';
                      }

                      if (_k307) {
                        _k307s = 'K307:Oli Gardan dan Transmisi:Ganti#';
                      } else {
                        _k307s = '';
                      }

                      if (_k308) {
                        _k308s =
                            'K308:Kebocoran oli dan kerusakan Shock Absorber:Periksa#';
                      } else {
                        _k308s = '';
                      }

                      if (_k309) {
                        _k309s =
                            'K309:Tekanan, kerusakan dan keausan ban:Periksa#';
                      } else {
                        _k309s = '';
                      }
                      if (_k310) {
                        _k310s = 'K310:Bunyi-bunyi roda:Periksa#';
                      } else {
                        _k310s = '';
                      }

                      if (_k311) {
                        _k311s =
                            'K311:Keausan, kebocoran dan kerusakan Disc & Pad:Periksa#';
                      } else {
                        _k311s = '';
                      }
                      if (_k312) {
                        _k312s =
                            'K312:Kekencangan dan kerusakan knalpot & pipa Exhaust:Periksa#';
                      } else {
                        _k312s = '';
                      }
                      if (_k313) {
                        _k313s =
                            'K313:Kekencangan dan kondisi semua pintu dan tutup mesin:Periksa#';
                      } else {
                        _k313s = '';
                      }
                      if (_k314) {
                        _k314s =
                            'K314:kondisi chasis dan body serta beri gemuk:Periksa#';
                      } else {
                        _k314s = '';
                      }

                      if (_k315) {
                        _k315s = 'K315:Busi:Ganti#';
                      } else {
                        _k315s = '';
                      }
                      if (_k316) {
                        _k316s = 'K316:Air Accu:Periksa#';
                      } else {
                        _k316s = '';
                      }
                      if (_k317) {
                        _k317s =
                            'K317:Klem-klem dan kabel-kabel listrik:Periksa#';
                      } else {
                        _k317s = '';
                      }
                      if (_k319) {
                        _k319s = 'K319:Kotak P3K dan Apar:Periksa#';
                      } else {
                        _k319s = '';
                      }

                      String result = _k301s +
                          _k302s +
                          _k303s +
                          _k304s +
                          _k305s +
                          _k306s +
                          _k307s +
                          _k308s +
                          _k309s +
                          _k310s +
                          _k311s +
                          _k312s +
                          _k313s +
                          _k314s +
                          _k315s +
                          _k316s +
                          _k317s +
                          _k318s +
                          _k319s;
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
    if (_k301 &&
        _k302 &&
        _k303 &&
        _k304 &&
        _k305 &&
        _k306 &&
        _k307 &&
        _k308 &&
        _k309 &&
        _k310 &&
        _k311 &&
        _k312 &&
        _k313 &&
        _k314 &&
        _k316 &&
        _k317 &&
        _k318) {
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
