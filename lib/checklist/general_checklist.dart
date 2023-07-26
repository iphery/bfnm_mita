import 'package:flutter/material.dart';

class GeneralChecklist extends StatefulWidget {

  @override
  _GeneralChecklistState createState() => _GeneralChecklistState();
}

class _GeneralChecklistState extends State<GeneralChecklist> {
  @override
  Widget build(BuildContext context) {
    bool x = false;
    return Scaffold(
      body: Column(
        children: [
          for (var i = 0; i < 10; i++)

            CheckboxListTile(
              title: const Text('Bearing / Bushing'),
              subtitle: const Text('Tidak goyang, as tidak cacat, dilumasi grease.'),
              secondary: const Icon(Icons.code),
              autofocus: false,
              activeColor: Colors.lightBlue,
              checkColor: Colors.white,
              //selected: x,
              value: x,
              onChanged: (bool value) {
                x = value;
              },
            ),

        ],
      )
    );
  }
}
