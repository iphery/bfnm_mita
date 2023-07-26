import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:mita/api_service.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

class CH01 extends StatefulWidget {
  final String kelas;
  CH01({this.kelas});

  @override
  _CH01State createState() => _CH01State();
}

class _CH01State extends State<CH01> {

  bool _h201 = false;
  String _h201s = '';
  bool _h202 = false;
  String _h202s = '';
  bool _h203 = false;
  String _h203s = '';
  bool _h204 = false;
  String _h204s = '';
  bool _h205 = false;
  String _h205s = '';
  bool _h206 = false;
  String _h206s = '';


  bool _value = false;

  bool isLoading = false;
  bool isCompleted = false;

  final textEditingProblem = TextEditingController();
  final textEditingSolution = TextEditingController();
  final textEditingTekanan = TextEditingController();

  FocusNode focusProblem = FocusNode();
  FocusNode focusSolution = FocusNode();
  FocusNode focusTekanan = FocusNode();

  bool showClearIconProblem= false;
  bool showClearIconSolution= false;
  bool showClearIconTekanan= false;
  bool isError = false;

  int count = 0;

  DioService dioService = DioService();
  bool isKeyBShow =false;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {

      if(visible){

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
          leading: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.black,),
          backgroundColor: Colors.white,
          title: Text('Checklist H01', style: TextStyle(color: Colors.black),),

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
                          Text('Checklist Kontrol Apar'),
                          Text('CL.ME.002/0'),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 10,),

///tabung
                CheckboxListTile(
                  title: const Text('Tabung'),
                  subtitle: const Text('Bentuk tabung tidak ada yang cacat / penyok.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h201,
                  value: _h201,
                  onChanged: (bool value) {
                    setState(() {
                      _h201 = value;

                    });
                    checkComplete();
                  },
                ),


                ///selang
                CheckboxListTile(
                  title: const Text('Selang'),
                  subtitle: const Text('2.	Selang tidak ada yang cacat/bocor.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h202,
                  value: _h202,
                  onChanged: (bool value) {
                    setState(() {
                      _h202 = value;

                    });
                    checkComplete();
                  },
                ),

                ///Tekanan
                CheckboxListTile(
                  title: const Text('Tekanan'),
                  subtitle: const Text('Tekanan normal (jarum berada pada tanda hijau).'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h203,
                  value: _h203,
                  onChanged: (bool value) {
                    setState(() {
                      _h203 = value;

                    });
                    checkComplete();
                  },
                ),
                ///segel
                CheckboxListTile(
                  title: const Text('Segel'),
                  subtitle: const Text('Segel masih utuh dan tidak terbuka.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h204,
                  value: _h204,
                  onChanged: (bool value) {
                    setState(() {
                      _h204 = value;

                    });
                    checkComplete();
                  },
                ),

                ///expired
                CheckboxListTile(
                  title: const Text('Expired'),
                  subtitle: const Text('Tidak melewati tanggal expired.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h205,
                  value: _h205,
                  onChanged: (bool value) {
                    setState(() {
                      _h205 = value;

                    });
                    checkComplete();
                  },
                ),
                ///posisi
                CheckboxListTile(
                  title: const Text('Posisi'),
                  subtitle: const Text('Posisi tidak terhalang sesuatu dan mudah di akses.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                  selected: _h206,
                  value: _h206,
                  onChanged: (bool value) {
                    setState(() {
                      _h206 = value;

                    });
                    checkComplete();
                  },
                ),
                SizedBox(height: 10,),





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
                        color: Colors.grey[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingProblem,
                        focusNode: focusProblem,
                        onChanged: (val){
                          if(textEditingProblem.text.isNotEmpty){
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


                            suffixIcon: showClearIconProblem? IconButton(
                              icon: Icon(Icons.clear),
                              iconSize: 20,
                              onPressed: (){
                                textEditingProblem.clear();
                                setState(() {
                                  showClearIconProblem = false;

                                });




                              },

                            ) : SizedBox.shrink()

                        ),

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingSolution,
                        focusNode: focusSolution,
                        onChanged: (val){
                          if(textEditingProblem.text.isNotEmpty){
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
                        decoration: isError? InputDecoration(
                            hintText: 'Tuliskan tindakan perbaikan...',
                            border: InputBorder.none,

                            errorText: 'Kolom tidak boleh kosong',

                            suffixIcon: showClearIconSolution? IconButton(
                              icon: Icon(Icons.clear),
                              iconSize: 20,
                              onPressed: (){
                                textEditingSolution.clear();
                                setState(() {
                                  showClearIconSolution = false;

                                });




                              },

                            ) : SizedBox.shrink()

                        )
                            : InputDecoration(
                            hintText: 'Tuliskan tindakan perbaikan...',
                            border: InputBorder.none,



                            suffixIcon: showClearIconSolution? IconButton(
                              icon: Icon(Icons.clear),
                              iconSize: 20,
                              onPressed: (){
                                textEditingSolution.clear();
                                setState(() {
                                  showClearIconSolution = false;

                                });




                              },

                            ) : SizedBox.shrink()

                        ),

                      ),
                    ),
                  ),
                ),


                //Chec
              ],
            ),
          ),
        ),
        bottomSheet: isKeyBShow ? SizedBox.shrink():Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: ()async{
              focusProblem.unfocus();
              focusSolution.unfocus();
              focusTekanan.unfocus();
              if (isCompleted){
                setState(() {
                  isLoading = true;
                });
                var provider = Provider.of<AssetProvider>(context, listen: false);
                if(_h201) {_h201s = 'H201:Tabung:Periksa#';} else{_h201s ='';}
                if(_h202) {_h202s = 'H202:Selang:Periksa#';} else {_h202s='';}
                if(_h203) {_h203s = 'H203:Tekanan:Periksa#';} else {_h203s='';}
                if(_h204) {_h204s = 'H204:Segel:Periksa#';} else {_h204s='';}
                if(_h205) {_h205s = 'H205:Expired:Periksa#';} else {_h205s='';}
                if(_h206) {_h206s = 'H206:Posisi:Periksa#';} else {_h206s='';}


                String result = _h201s+_h202s+_h203s+_h204s+_h205s+_h206s;

                String problem = 'Perawatan rutin. ${textEditingProblem.text}.';
                String solution = textEditingSolution.text;

                var res = await dioService.getMaintenanceComplete(provider.selectedIdCase, result, problem, solution, widget.kelas);
                if(res == 'OK'){
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




              }else{
                showDialog();
              }





            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Material(
                elevation: 2,

                color: isCompleted? Theme.of(context).primaryColor: Colors.grey,
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: isLoading? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: CupertinoActivityIndicator(radius: 11,)),
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
                  ) :Text(
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

  void checkComplete(){
    if(_h201 && _h202 && _h203 && _h204 && _h205 && _h206 ){
      setState(() {
        isCompleted =true;
      });
    } else {
      setState(() {
        isCompleted =false;
      });
    }
  }

  showDialog(){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Form checklist tidak lengkap !'),
            actions: [
              TextButton(
                child: Text('OK', style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                ),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  showDialogError(){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Update gagal. Cobalah beberapa saat lagi.'),
            actions: [
              TextButton(
                child: Text('OK', style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                ),),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);


                },
              )
            ],
          );
        }
    );
  }




}
