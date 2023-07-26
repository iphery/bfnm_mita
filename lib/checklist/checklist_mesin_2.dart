import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CM02 extends StatefulWidget {
  final String kelas;
  CM02({this.kelas});

  @override
  _CM02State createState() => _CM02State();
}

class _CM02State extends State<CM02> {
  bool _c201 = false;
  String _c201s = '';
  bool _c202 = false;
  String _c202s = '';
  bool _c203 = false;
  String _c203s = '';
  bool _c204 = false;
  String _c204s = '';
  bool _c205 = false;
  String _c205s = '';
  bool _c206 = false;
  String _c206s = '';
  bool _c207 = false;
  String _c207s = '';

  bool _c208 = false;
  String _c208s = '';
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

  ApiService service = ApiService();
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
            'Checklist M02',
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
                    color: Colors.red.withOpacity(0.2),
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c201,
                  value: _c201,
                  onChanged: (bool value) {
                    setState(() {
                      _c201 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c202,
                  value: _c202,
                  onChanged: (bool value) {
                    setState(() {
                      _c202 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c203,
                  value: _c203,
                  onChanged: (bool value) {
                    setState(() {
                      _c203 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c204,
                  value: _c204,
                  onChanged: (bool value) {
                    setState(() {
                      _c204 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c205,
                  value: _c205,
                  onChanged: (bool value) {
                    setState(() {
                      _c205 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c206,
                  value: _c206,
                  onChanged: (bool value) {
                    setState(() {
                      _c206 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c207,
                  value: _c207,
                  onChanged: (bool value) {
                    setState(() {
                      _c207 = value;
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
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected: _c208,
                  value: _c208,
                  onChanged: (bool value) {
                    setState(() {
                      _c208 = value;
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
                      if (_c201) {
                        _c201s = 'C101:Bearing/Bushing:Periksa#';
                      } else {
                        _c201s = '';
                      }
                      if (_c202) {
                        _c202s = 'C102:Vanbelt/Rantai:Periksa#';
                      } else {
                        _c202s = '';
                      }
                      if (_c203) {
                        _c203s = 'C103:Gearbox:Ganti#';
                      } else {
                        _c203s = '';
                      }
                      if (_c204) {
                        _c204s = 'C104:Pelumasan:Lumasi#';
                      } else {
                        _c204s = '';
                      }
                      if (_c205) {
                        _c205s = 'C105:Kelistrikan:Periksa#';
                      } else {
                        _c205s = '';
                      }
                      if (_c206) {
                        _c206s = 'C106:Motor:Periksa#';
                      } else {
                        _c206s = '';
                      }
                      if (_c207) {
                        _c207s = 'C107:Pneumatic:Periksa#';
                      } else {
                        _c207s = '';
                      }
                      if (_c208) {
                        _c208s = 'C108:Hydraulic:Periksa#';
                      } else {
                        _c208s = '';
                      }

                      String result = _c201s +
                          _c202s +
                          _c203s +
                          _c204s +
                          _c205s +
                          _c206s +
                          _c207s +
                          _c208s;
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
    if (_c201 && _c202 && _c204 && _c205 && _c206) {
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
