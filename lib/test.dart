import 'package:flutter/material.dart';

class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  ScrollController _controller;
  bool lihat0 = false;
  bool lihat50 = false;
  bool lihat75 = false;
  bool lihat100 = false;
  double _opacity = 0.0;
  double _scrollPosition = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener(){

    setState(() {
      _scrollPosition = _controller.position.pixels;
    });
    //print(_scrollPosition);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    _opacity = _scrollPosition < screenSize.height * 0.1
      ? _scrollPosition / (screenSize.height * 0.1) : 1;
    print(_opacity);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.purple
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Container(
                        height: 100,
                        color: Colors.red,
                      ),
                    );
                  },
                ),

              ],
            ),
          ),

          Container(
            color: Colors.black.withOpacity(_opacity),
            height: 93.5,
          ),

          _customAppBarChange(),
        ],
      ),
    );
  }

  _appBar(){
    return AppBar();
  }
  _customAppBarChange(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
//border: Border.all(color: Colors.blue),
              color: Colors.green
          ),
          clipBehavior: Clip.hardEdge,
          //color: Colors.green,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,)),
              ),
              Expanded(
                child: Material(
                  elevation: 1,
                  child: GestureDetector(
                    onTap: ()async{

                    },
                    child: Container(

                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(4))
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Icon(Icons.search),
                              ),
                              SizedBox(width: 10,),
                              Text('Search', style: TextStyle(color: _opacity>0.7? Colors.black: Colors.purple),),
                            ],
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
