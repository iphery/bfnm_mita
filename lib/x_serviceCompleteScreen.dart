import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';

class ServiceCompleteScreen extends StatefulWidget {
  final String description;
  final String manufacture;
  final String model;
  final String problem;

  ServiceCompleteScreen(
      {this.description, this.manufacture, this.model, this.problem});

  @override
  _ServiceCompleteScreenState createState() => _ServiceCompleteScreenState();
}

class _ServiceCompleteScreenState extends State<ServiceCompleteScreen> {
  final textEditing = TextEditingController();

  bool showClearIcon = false;

  DioService dioService = DioService();

  bool isError = false;

  bool isLoading = false;

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        title: Text(
          'Complete Job',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '${widget.description}${widget.manufacture}${widget.model}'),
          ),
          Text(provider.selectedIdCase),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: Text('Keluhan :'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.problem,
                  maxLines: 2,
                )),
              ],
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
                  controller: textEditing,
                  focusNode: focus,
                  onChanged: (val) {
                    if (textEditing.text.isNotEmpty) {
                      setState(() {
                        showClearIcon = true;
                      });
                    } else {
                      setState(() {
                        showClearIcon = false;
                      });
                    }
                  },
                  minLines: 1,
                  maxLines: 3,
                  decoration: isError
                      ? InputDecoration(
                          hintText: 'Deskripsikan solusi perbaikan...',
                          border: InputBorder.none,
                          errorText: 'Kolom tidak boleh kosong',
                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink())
                      : InputDecoration(
                          hintText: 'Deskripsikan solusi perbaikan...',
                          border: InputBorder.none,
                          suffixIcon: showClearIcon
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  iconSize: 20,
                                  onPressed: () {
                                    textEditing.clear();
                                    setState(() {
                                      showClearIcon = false;
                                    });
                                  },
                                )
                              : SizedBox.shrink()),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            elevation: 2,
            color: showClearIcon ? Theme.of(context).primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final provider =
                          Provider.of<AssetProvider>(context, listen: false);
                      if (textEditing.text.isEmpty) {
                        setState(() {
                          isError = true;
                        });
                      } else {
                        setState(() {
                          isError = false;
                        });

                        setState(() {
                          isLoading = true;
                        });
                        var res = await dioService.getServiceComplete(
                            provider.selectedIdCase, textEditing.text);
                        if (res == 'OK') {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context, 'completed');
                        } else {
                          setState(() {
                            isLoading = false;
                          });

                          showDialog();
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
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
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialog() {
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
