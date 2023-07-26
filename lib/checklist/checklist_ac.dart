import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

import '../dio_service.dart';

class CA01 extends StatefulWidget {

  final String kelas;
  CA01({this.kelas});

  @override
  _CA01State createState() => _CA01State();
}

class _CA01State extends State<CA01> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpassController = TextEditingController();

  var textPreSuct = TextEditingController();
  FocusNode focustextPreSuct = FocusNode();
  bool showClearIcontextPreSuct = false;
  bool textPreSuctError = false;

  var textPreDisc = TextEditingController();
  FocusNode focustextPreDisc = FocusNode();
  bool showClearIcontextPreDisc = false;
  bool textPreDiscError = false;

  var textPreAmp = TextEditingController();
  FocusNode focustextPreAmp = FocusNode();
  bool showClearIcontextPreAmp = false;
  bool textPreAmpError = false;

  var textPostSuct = TextEditingController();
  FocusNode focustextPostSuct = FocusNode();
  bool showClearIcontextPostSuct = false;
  bool textPostSuctError = false;

  var textPostDisc = TextEditingController();
  FocusNode focustextPostDisc = FocusNode();
  bool showClearIcontextPostDisc = false;
  bool textPostDiscError = false;

  var textPostAmp = TextEditingController();
  FocusNode focustextPostAmp = FocusNode();
  bool showClearIcontextPostAmp = false;
  bool textPostAmpError = false;

  final textEditingProblem = TextEditingController();
  final textEditingSolution = TextEditingController();

  FocusNode focusProblem = FocusNode();
  FocusNode focusSolution = FocusNode();

  bool showClearIconProblem= false;
  bool showClearIconSolution= false;

  bool textProblemError = false;
  bool textSolutionError = false;

  bool isKeyBShow = false;
  bool isCompleted = false;
  bool isLoading = false;

  DioService dioService = DioService();


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
          title: Text('Checklist A01', style: TextStyle(color: Colors.black),),

        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  color: Colors.deepOrange.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Checklist AC'),
                        Text('CL.ME.002/0'),
                      ],
                    ),
                  )
              ),
              SizedBox(height: 10,),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pre-Service', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Suction (Low Pressure)'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPreSuct,
                                focusNode: focustextPreSuct,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPreSuct.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreSuct = true;
                                      textPreSuctError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreSuct = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPreSuct.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreSuct = true;

                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreSuct = false;
                                    });
                                  }

                                },

                                decoration: InputDecoration(
                                    hintText: 'Psi',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,
                                    suffixIcon: showClearIcontextPreSuct && focustextPreSuct.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPreSuct.clear();
                                        setState(() {
                                          showClearIcontextPreSuct = false;
                                          isCompleted = false;
                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPreSuctError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Discharge (High Pressure)'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPreDisc,
                                focusNode: focustextPreDisc,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPreDisc.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreDisc = true;
                                      textPreDiscError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreDisc = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPreDisc.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreDisc = true;

                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreDisc = false;
                                    });
                                  }

                                },
                                decoration: InputDecoration(
                                    hintText: 'Psi',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,


                                    suffixIcon: showClearIcontextPreDisc && focustextPreDisc.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPreDisc.clear();
                                        setState(() {
                                          showClearIcontextPreDisc = false;
                                          isCompleted = false;
                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPreDiscError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Ampere'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPreAmp,
                                focusNode: focustextPreAmp,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPreAmp.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreAmp = true;
                                      textPreAmpError = false;

                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreAmp = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPreAmp.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPreAmp = true;
                                      textPreAmpError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPreAmp = false;
                                    });
                                  }

                                },

                                decoration: InputDecoration(
                                    hintText: 'A',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,


                                    suffixIcon: showClearIcontextPreAmp && focustextPreAmp.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPreAmp.clear();
                                        setState(() {
                                          showClearIcontextPreAmp = false;
                                          isCompleted = false;
                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPreAmpError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Divider(color: Colors.grey[400]),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Post-Service', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Suction (Low Pressure)'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPostSuct,
                                focusNode: focustextPostSuct,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPostSuct.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostSuct = true;
                                      textPostSuctError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostSuct = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPostSuct.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostSuct = true;

                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostSuct = false;
                                    });
                                  }

                                },

                                decoration: InputDecoration(
                                    hintText: 'Psi',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,
                                    suffixIcon: showClearIcontextPostSuct && focustextPostSuct.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPostSuct.clear();
                                        setState(() {
                                          showClearIcontextPostSuct = false;
                                          isCompleted =false;

                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPostSuctError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Discharge (High Pressure)'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPostDisc,
                                focusNode: focustextPostDisc,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPostDisc.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostDisc = true;
                                      textPostDiscError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostDisc = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPostDisc.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostDisc = true;

                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostDisc = false;
                                    });
                                  }

                                },
                                decoration: InputDecoration(
                                    hintText: 'Psi',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,


                                    suffixIcon: showClearIcontextPostDisc && focustextPostDisc.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPostDisc.clear();
                                        setState(() {
                                          showClearIcontextPostDisc = false;
                                          isCompleted = false;

                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPostDiscError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Text('Ampere'),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.grey[300])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextField(
                                controller: textPostAmp,
                                focusNode: focustextPostAmp,
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(textPostAmp.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostAmp = true;
                                      textPostAmpError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostAmp = false;
                                    });
                                  }
                                  checkComplete();
                                },
                                onTap: (){
                                  if(textPostAmp.text.isNotEmpty){
                                    setState(() {
                                      showClearIcontextPostAmp = true;
                                      textPostAmpError = false;
                                    });
                                  } else {
                                    setState(() {
                                      showClearIcontextPostAmp = false;
                                    });
                                  }

                                },

                                decoration: InputDecoration(
                                    hintText: 'A',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: InputBorder.none,


                                    suffixIcon: showClearIcontextPostAmp && focustextPostAmp.hasFocus ? IconButton(
                                      icon: Icon(Icons.clear),
                                      iconSize: 20,
                                      onPressed: (){
                                        textPostAmp.clear();
                                        setState(() {
                                          showClearIcontextPostAmp = false;
                                          isCompleted = false;

                                        });




                                      },

                                    ) : SizedBox.shrink()

                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    textPostAmpError? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Kolom ini tidak boleh kosong', style: TextStyle(color: Colors.red),),
                      ],
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              Divider(color: Colors.grey[400]),


              SizedBox(height: 20,),




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
                      onTap: (){
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


                          suffixIcon: showClearIconProblem && focusProblem.hasFocus? IconButton(
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
                        if(textEditingSolution.text.isNotEmpty){
                          setState(() {
                            showClearIconSolution = true;
                          });
                        } else {
                          setState(() {
                            showClearIconSolution = false;
                          });
                        }
                      },
                      onTap: (){
                        if(textEditingSolution.text.isNotEmpty){
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



                          suffixIcon: showClearIconSolution && focusSolution.hasFocus? IconButton(
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


              SizedBox(height: 80,),




            ],
          ),
        ),
        bottomSheet: isKeyBShow ? SizedBox.shrink() : Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: ()async{
              focustextPreSuct.unfocus();
              focustextPreDisc.unfocus();
              focustextPreAmp.unfocus();
              focustextPostSuct.unfocus();
              focustextPostDisc.unfocus();
              focustextPostAmp.unfocus();
              if(textPreSuct.text.isEmpty){
                setState(() {
                  textPreSuctError = true;
                });
                focustextPreSuct.requestFocus();
              } else if (textPreDisc.text.isEmpty){
                setState(() {
                  textPreDiscError = true;
                });
                focustextPreDisc.requestFocus();
              } else if (textPreAmp.text.isEmpty){
                setState(() {
                  textPreAmpError = true;
                });
                focustextPreAmp.requestFocus();
              } else if (textPostSuct.text.isEmpty){
                setState(() {
                  textPostSuctError = true;
                });
                focustextPostSuct.requestFocus();
              } else if (textPostDisc.text.isEmpty){
                setState(() {
                  textPostDiscError = true;
                });
                focustextPostDisc.requestFocus();
              } else if (textPostAmp.text.isEmpty){
                setState(() {
                  textPostAmpError = true;
                });
                focustextPostAmp.requestFocus();
              }

              if (isCompleted) {
                setState(() {
                  isLoading = true;
                });

                var provider = Provider.of<AssetProvider>(context, listen: false);

                String preSuct = 'A101:Pre Suction ${textPreSuct.text} Psi:#';
                String preDisc = 'A102:Pre Discharge ${textPreDisc.text} Psi:#';
                String preAmp = 'A103:Pre Ampere ${textPreAmp.text} A:#';
                String postSuct = 'A104:Post Suction ${textPostSuct.text} Psi:#';
                String postDisc = 'A105:Post Discharge ${textPostDisc.text} Psi:#';
                String postAmp = 'A106:Post Ampere ${textPostAmp.text} A:#';


                String result = preSuct+preDisc+preAmp+postSuct+postDisc+postAmp;
                String problem = textEditingProblem.text;
                String solution = textEditingSolution.text;

                print(result);
                print(problem);
                print(solution);
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
                //showDialog();
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
    if(textPreSuct.text.length>0 && textPreDisc.text.length>0 && textPreAmp.text.length>0 && textPostSuct.text.length>0 && textPostDisc.text.length>0 && textPostAmp.text.length>0){

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
