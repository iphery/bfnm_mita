import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CM01 extends StatefulWidget {
  final String kelas;
  CM01({this.kelas});

  @override
  _CM01State createState() => _CM01State();
}

class _CM01State extends State<CM01> {
  bool _c101 = false;
  String _c101s = '';
  bool _c102 = false;
  String _c102s = '';
  bool _c103 = false;
  String _c103s = '';
  bool _c104 = false;
  String _c104s = '';
  bool _c105 = false;
  String _c105s = '';
  bool _c106 = false;
  String _c106s = '';
  bool _c107 = false;
  String _c107s = '';

  bool _c108 = false;
  String _c108s = '';
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
  bool isKeyBShow = false;

  DioService dioService = DioService();
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
            'Checklist M01',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          //physics: AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              children: [
                Container(
                    color: Colors.blue.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Mesin Produksi'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  title: const Text('Bearing / Bushing'),
                  subtitle: const Text(
                      'Tidak goyang, as tidak cacat, dilumasi grease.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c101,
                  value: _c101,
                  onChanged: (bool value) {
                    setState(() {
                      _c101 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Vanbelt/Rantai'),
                  subtitle: const Text(
                      'Kencang, tidak cacat, rantai dilumasi oli/grease.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c102,
                  value: _c102,
                  onChanged: (bool value) {
                    setState(() {
                      _c102 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Gearbox (jika ada)'),
                  subtitle: const Text(
                      'Tangki oli terisi dengan ketinggian yang sesuai.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c103,
                  value: _c103,
                  onChanged: (bool value) {
                    setState(() {
                      _c103 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Pelumasan'),
                  subtitle: const Text(
                      'Bagian mesin yang perlu pelumasan telah dilumasi oli.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c104,
                  value: _c104,
                  onChanged: (bool value) {
                    setState(() {
                      _c104 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Kelistrikan'),
                  subtitle: const Text(
                      'Semua switch, indikator, dan sensor berfungsi dengan baik, kabel-kabel tidak ada yang cacat.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c105,
                  value: _c105,
                  onChanged: (bool value) {
                    setState(() {
                      _c105 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Motor'),
                  subtitle: const Text(
                      'Temperature, suara, getaran normal, arus seimbang dan sesuai nameplate.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c106,
                  value: _c106,
                  onChanged: (bool value) {
                    setState(() {
                      _c106 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Pneumatic (jika ada)'),
                  subtitle: const Text(
                      'Tidak terdapat kebocoran yang besar pada sistem pneumatic.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c107,
                  value: _c107,
                  onChanged: (bool value) {
                    setState(() {
                      _c107 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text('Hydraulic (jika ada)'),
                  subtitle: const Text(
                      'Tidak terdapat kebocoran yang besar pada sistem hidraulic. Tangki oli terisi dengan ketinggian yang sesuai.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.lightBlue,
                  checkColor: Colors.white,
                  selected: _c108,
                  value: _c108,
                  onChanged: (bool value) {
                    setState(() {
                      _c108 = value;
                    });
                    checkComplete();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
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
                      if (_c101) {
                        _c101s = 'C101:Bearing/Bushing:Periksa#';
                      } else {
                        _c101s = '';
                      }
                      if (_c102) {
                        _c102s = 'C102:Vanbelt/Rantai:Periksa#';
                      } else {
                        _c102s = '';
                      }
                      if (_c103) {
                        _c103s = 'C103:Gearbox:Periksa#';
                      } else {
                        _c103s = '';
                      }
                      if (_c104) {
                        _c104s = 'C104:Pelumasan:Lumasi#';
                      } else {
                        _c104s = '';
                      }
                      if (_c105) {
                        _c105s = 'C105:Kelistrikan:Periksa#';
                      } else {
                        _c105s = '';
                      }
                      if (_c106) {
                        _c106s = 'C106:Motor:Periksa#';
                      } else {
                        _c106s = '';
                      }
                      if (_c107) {
                        _c107s = 'C107:Pneumatic:Periksa#';
                      } else {
                        _c107s = '';
                      }
                      if (_c108) {
                        _c108s = 'C108:Hydraulic:Periksa#';
                      } else {
                        _c108s = '';
                      }

                      String result = _c101s +
                          _c102s +
                          _c103s +
                          _c104s +
                          _c105s +
                          _c106s +
                          _c107s +
                          _c108s;
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

                      /*
                ///scan id user
                print(provider.asset.id_asset);
                var useruid = await dioService.checkUserId(provider.asset.id_asset);
                print(useruid['uid']);
                scanQR(useruid['uid'], provider.selectedIdCase, result, problem, solution, provider.asset.kelas);


                */
                    } else {
                      showDialog('Form checklist tidak lengkap !');
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
    if (_c101 && _c102 && _c104 && _c105 && _c106) {
      setState(() {
        isCompleted = true;
      });
    } else {
      setState(() {
        isCompleted = false;
      });
    }
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

  /*
  Future<void> scanQR(uidResult, idCase, result, problem, solution, kelas) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if(barcodeScanRes != '-1'){
      ///cek scan result to  server
        if(barcodeScanRes == uidResult){
          await dioService.getMaintenanceComplete(idCase, result, problem, solution,kelas).then((value) {
            Navigator.pop(context, 'completed');
            isLoading = false;
          });
        } else {
          showDialog('Id user tidak sesuai. Mohon dicek kembali.');
        }


    } else {
      ///jika batal scan

    }




    ///jika sama lanjut ke step berikutnya


  }



   */
}
