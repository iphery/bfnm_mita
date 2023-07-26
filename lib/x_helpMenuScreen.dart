import 'package:flutter/material.dart';
import 'package:mita/checklist/checklist_box_hydrant.dart';
import 'package:mita/checklist/checklist_hydrant.dart';

class HelpMenuScreen extends StatefulWidget {

  @override
  _HelpMenuScreenState createState() => _HelpMenuScreenState();
}

class _HelpMenuScreenState extends State<HelpMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CH03(kelas: 'a',)));

              },
              child: Text('Checklist Hydrant')
            )
          ],
        ),
      ),
    );
  }
}
