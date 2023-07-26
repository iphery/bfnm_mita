import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatelessWidget {
  static const route = '/imagepreviewscreen';

  final String imageUrl;
  ImagePreviewScreen({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Stack(
          children: [
            Container(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }
}
