import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mita/dio_service.dart';
import 'package:mita/x_provider.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({Key key}) : super(key: key);

  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  DioService dioService = DioService();
  List pathList = [];
  ApiService service = ApiService();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Carousel Image', style: (TextStyle(color: Colors.black))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () async {
              List<Media> res = await ImagesPicker.pick(
                count: 5,
                pickType: PickType.all,
                language: Language.System,

                // maxSize: 500,
                cropOpt: CropOption(
                  aspectRatio: CropAspectRatio.wh16x9,
                ),
              );

              if (res != null) {
                //print(res.map((e) => e.path).toList());

                for (int i = 0; i < res.length; i++) {
                  //print(res[i].thumbPath);
                  setState(() {
                    pathList.add(res[i].thumbPath);
                  });
                }

                await service
                    .saveCarouselImage(pathList: pathList)
                    .then((value) {
                  EasyLoading.showSuccess('Tersimpan.',
                      duration: Duration(milliseconds: 500));
                  setState(() {});
                });

                /*
                              setState(() {
                                path = res[0].thumbPath;
                              });

                               */
                // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
                // print(status);
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: provider.loadCarouselAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = provider.carouselUrl;

            return ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width / 1.7,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'http://mita.balifoam.com/mobile/flutter/image_carousel/${data[index]['Url']}'))),
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialogHapus(data[index]['Url']);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  data[index]['status'] == '1'
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await dioService
                                      .carouselFavourite(data[index]['Url'],
                                          data[index]['status'])
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  showDialogHapus(url) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text('Hapus foto ini ?'),
            actions: [
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await dioService.carouselDelete(url).then((value) {
                    setState(() {});
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
