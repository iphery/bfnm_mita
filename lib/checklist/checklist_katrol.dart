import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CF02 extends StatefulWidget {
  @override
  _CF02State createState() => _CF02State();
}

class _CF02State extends State<CF02> {
  bool _f201 = false;
  String _f201s = '';
  String _f201d =
      'Periksa kondisi sling. Pastikan tidak ada tanda-tanda putus / korosi.';
  bool _f202 = false;
  String _f202s = '';
  String _f202d = 'Periksa fungsi tombol Start/Stop dan Emergency.';
  bool _f203 = false;
  String _f203s = '';
  String _f203d = 'Tidak ada suara noise pada mesin Katrol.';
  bool _f204 = false;
  String _f204s = '';
  String _f204d = 'Tidak ada baut yang kendur / rangka body yang korosi.';

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
                  title: Text(_f201d),
                  // subtitle: const Text('Periksa kondisi sling. Pastikan tidak kering / korosi.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f201,
                  value: _f201,
                  onChanged: (bool value) {
                    setState(() {
                      _f201 = value;
                    });
                    checkComplete();
                  },
                ),

                ///selang
                CheckboxListTile(
                  title: Text(_f202d),
                  //subtitle: const Text('2.	Selang tidak ada yang cacat/bocor.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f202,
                  value: _f202,
                  onChanged: (bool value) {
                    setState(() {
                      _f202 = value;
                    });
                    checkComplete();
                  },
                ),

                ///Tekanan
                CheckboxListTile(
                  title: Text(_f203d),
                  //subtitle: const Text('Tekanan normal (jarum berada pada tanda hijau).'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f203,
                  value: _f203,
                  onChanged: (bool value) {
                    setState(() {
                      _f203 = value;
                    });
                    checkComplete();
                  },
                ),

                ///segel
                CheckboxListTile(
                  title: Text(_f204d),
                  //subtitle: const Text('Segel masih utuh dan tidak terbuka.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _f204,
                  value: _f204,
                  onChanged: (bool value) {
                    setState(() {
                      _f204 = value;
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
                      if (_f201) {
                        _f201s = 'F201:$_f201d:Periksa#';
                      } else {
                        _f201s = '';
                      }
                      if (_f202) {
                        _f202s = 'F202:$_f202d:Periksa#';
                      } else {
                        _f202s = '';
                      }
                      if (_f203) {
                        _f203s = 'F203:$_f203d:Periksa#';
                      } else {
                        _f203s = '';
                      }
                      if (_f204) {
                        _f204s = 'F204:$_f204d:Periksa#';
                      } else {
                        _f204s = '';
                      }

                      String result = _f201s + _f202s + _f203s + _f204s;

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
    if (_f201 && _f202 && _f203 && _f204) {
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
