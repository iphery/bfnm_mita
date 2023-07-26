import 'dart:io';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/api_service.dart';
import 'package:path_provider/path_provider.dart';

class IniDummy extends StatefulWidget {
  @override
  _IniDummyState createState() => _IniDummyState();
}

class _IniDummyState extends State<IniDummy> {
  File imageFile;
  ApiService service = ApiService();
  String path;
  String idAsset = 'BFNMA0401';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 450,
              child: path != null ? Image.file(File(path)) : SizedBox(),
            ),
            ElevatedButton(
              child: Text('Shot'),
              onPressed: () async {
                /*
                var pathX = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPage()));
                setState(() {
                  //print(imageFile.path);
                  path = pathX;
                });

                 */

                //await service.saveUserPicture(path: path, idAsset: idAsset).then((value) {
                //EasyLoading.showSuccess('Tersimpan.', duration: Duration(milliseconds: 500));
                //});
              },
            ),
            ElevatedButton(
              child: Text('create'),
              onPressed: () async {
                Directory root = await getExternalStorageDirectory();
                String directoryPath = '${root.path}/Pictures';
                new Directory(directoryPath)
                    .create()
                    // The created directory is returned as a Future.
                    .then((Directory directory) {
                  print(directory.path);
                });
              },
            ),
            ElevatedButton(
              child: Text('pic'),
              onPressed: () async {
                List<Media> res = await ImagesPicker.pick(
                  count: 1,
                  pickType: PickType.all,
                  language: Language.System,

                  // maxSize: 500,
                  cropOpt: CropOption(
                    aspectRatio: CropAspectRatio.wh16x9,
                  ),
                );
                if (res != null) {
                  //print(res.map((e) => e.path).toList());

                  setState(() {
                    path = res[0].thumbPath;
                  });
                  print(path);

                  //await service.saveUserPicture(path: path, idAsset: provider.asset.id_asset).then((value) {
                  //EasyLoading.showSuccess('Tersimpan.', duration: Duration(milliseconds: 500));
                  //});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
