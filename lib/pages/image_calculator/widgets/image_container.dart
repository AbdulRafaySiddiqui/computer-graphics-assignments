import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final Image image;

  const ImageContainer({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: image,
      ),
    );
  }
}
