import 'package:flutter/material.dart';

class ChecklistKendaraan extends StatefulWidget {
  String k01;
  ChecklistKendaraan({this.k01});

  @override
  _ChecklistKendaraanState createState() => _ChecklistKendaraanState();
}

class _ChecklistKendaraanState extends State<ChecklistKendaraan> {

  String k01;

  @override
  void initState() {
    k01 = widget.k01;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(k01)
          ],
        ),
      ),
    );
  }
}
