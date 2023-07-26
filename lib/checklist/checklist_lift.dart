import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CF01 extends StatefulWidget {
  @override
  _CF01State createState() => _CF01State();
}

class _CF01State extends State<CF01> {
  bool _f101 = false;
  String _f101s = '';
  String _f101d = 'Periksa kondisi sling. Pastikan tidak kering / korosi.';
  bool _f102 = false;
  String _f102s = '';
  String _f102d = 'Periksa oli gearbox.';
  bool _f103 = false;
  String _f103s = '';
  String _f103d = 'Periksa level tangki pelumasan.';
  bool _f104 = false;
  String _f104s = '';
  String _f104d = 'Tidak ada baut yang kendur / rangka body yang korosi.';
  bool _f105 = false;
  String _f105s = '';
  String _f105d = 'Panel dalam kondisi bersih / lampu indikator berfungsi.';
  bool _f106 = false;
  String _f106s = '';
  String _f106d = 'Periksa fungsi semua limit switch termasuk pengaman pintu.';
  bool _f107 = false;
  String _f107s = '';
  String _f107d = 'Periksa fungsi tombol Start/Stop dan Emergency.';
  bool _f108 = false;
  String _f108s = '';
  String _f108d = 'Tidak ada suara noise ketika kereta naik/turun.';
  bool _f109 = false;
  String _f109s = '';
  String _f109d = 'Posisi lantai tidak miring.';
  bool _f110 = false;
  String _f110s = '';
  String _f110d = 'Periksa kondisi peredam.';

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

  ApiService service = ApiService();
  bool isKeyBShow = false;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      print(visible);
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
            'Checklist F01',
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
                          Text('Checklist Lift Barang'),
                          //Text('CL.ME.002/0'),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),

                CheckboxListTile(
                  title: Text(_f101d),
                  // subtitle: const Text('Periksa kondisi sling. Pastikan tidak kering / korosi.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f101,
                  value: _f101,
                  onChanged: (bool value) {
                    setState(() {
                      _f101 = value;
                    });
                    checkComplete();
                  },
                ),

                ///selang
                CheckboxListTile(
                  title: Text(_f102d),
                  //subtitle: const Text('2.	Selang tidak ada yang cacat/bocor.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f102,
                  value: _f102,
                  onChanged: (bool value) {
                    setState(() {
                      _f102 = value;
                    });
                    checkComplete();
                  },
                ),

                ///Tekanan
                CheckboxListTile(
                  title: Text(_f103d),
                  //subtitle: const Text('Tekanan normal (jarum berada pada tanda hijau).'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f103,
                  value: _f103,
                  onChanged: (bool value) {
                    setState(() {
                      _f103 = value;
                    });
                    checkComplete();
                  },
                ),

                ///segel
                CheckboxListTile(
                  title: Text(_f104d),
                  //subtitle: const Text('Segel masih utuh dan tidak terbuka.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f104,
                  value: _f104,
                  onChanged: (bool value) {
                    setState(() {
                      _f104 = value;
                    });
                    checkComplete();
                  },
                ),

                ///expired
                CheckboxListTile(
                  title: Text(_f105d),
                  //subtitle: const Text('Tidak melewati tanggal expired.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f105,
                  value: _f105,
                  onChanged: (bool value) {
                    setState(() {
                      _f105 = value;
                    });
                    checkComplete();
                  },
                ),

                ///posisi
                CheckboxListTile(
                  title: Text(_f106d),
                  //subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f106,
                  value: _f106,
                  onChanged: (bool value) {
                    setState(() {
                      _f106 = value;
                    });
                    checkComplete();
                  },
                ),

                CheckboxListTile(
                  title: Text(_f107d),
                  //subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f107,
                  value: _f107,
                  onChanged: (bool value) {
                    setState(() {
                      _f107 = value;
                    });
                    checkComplete();
                  },
                ),

                CheckboxListTile(
                  title: Text(_f108d),
                  //subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f108,
                  value: _f108,
                  onChanged: (bool value) {
                    setState(() {
                      _f108 = value;
                    });
                    checkComplete();
                  },
                ),

                CheckboxListTile(
                  title: Text(_f109d),
                  //subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f109,
                  value: _f109,
                  onChanged: (bool value) {
                    setState(() {
                      _f109 = value;
                    });
                    checkComplete();
                  },
                ),

                CheckboxListTile(
                  title: Text(_f110d),
                  //subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f110,
                  value: _f110,
                  onChanged: (bool value) {
                    setState(() {
                      _f110 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 10,
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
                          decoration: InputDecoration(
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
                                  : SizedBox.shrink())),
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
                      if (_f101) {
                        _f101s = 'F101:$_f101d:Periksa#';
                      } else {
                        _f101s = '';
                      }
                      if (_f102) {
                        _f102s = 'F102:$_f102d:Periksa#';
                      } else {
                        _f102s = '';
                      }
                      if (_f103) {
                        _f103s = 'F103:$_f103d:Periksa#';
                      } else {
                        _f103s = '';
                      }
                      if (_f104) {
                        _f104s = 'F104:$_f104d:Periksa#';
                      } else {
                        _f104s = '';
                      }
                      if (_f105) {
                        _f105s = 'F105:$_f105d:Periksa#';
                      } else {
                        _f105s = '';
                      }
                      if (_f106) {
                        _f106s = 'F106:$_f106d:Periksa#';
                      } else {
                        _f106s = '';
                      }
                      if (_f107) {
                        _f107s = 'F107:$_f107d:Periksa#';
                      } else {
                        _f107s = '';
                      }
                      if (_f108) {
                        _f108s = 'F108:$_f108d:Periksa#';
                      } else {
                        _f108s = '';
                      }
                      if (_f109) {
                        _f109s = 'F109:$_f109d:Periksa#';
                      } else {
                        _f109s = '';
                      }
                      if (_f110) {
                        _f110s = 'F110:$_f110d:Periksa#';
                      } else {
                        _f110s = '';
                      }

                      String result = _f101s +
                          _f102s +
                          _f103s +
                          _f104s +
                          _f105s +
                          _f106s +
                          _f107s +
                          _f108s +
                          _f109s +
                          _f110s;

                      String problem = textEditingProblem.text;
                      String solution = textEditingSolution.text;
                      print(result);

/*
                await service.getMaintenanceComplete(provider.selectedCase.id_request, result, problem, solution).then((value) {
                  Navigator.pop(context, 'completed');
                  isLoading = false;
                });



 */
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
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
    if (_f101 &&
        _f102 &&
        _f103 &&
        _f104 &&
        _f105 &&
        _f106 &&
        _f107 &&
        _f108 &&
        _f109 &&
        _f110) {
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
}
