import 'dart:io';

import 'package:cg_assignment/pages/image_calculator/widgets/image_container.dart';
import 'package:cg_assignment/pages/image_calculator/widgets/image_converter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image/image.dart' as image;

class ImageCalculator extends StatefulWidget {
  @override
  _ImageCalculatorState createState() => _ImageCalculatorState();
}

class _ImageCalculatorState extends State<ImageCalculator> {
  final double size = 50;

  String image1Path = "assets/img_1.jpg";
  String image2Path = "assets/img_2.jpg";

  image.Image image1;
  image.Image image2;
  ImageFilter imageFilter = ImageFilter.Multiply;

  bool isBusy = true;

  pickFile1() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'gif'],
    );

    setState(() => isBusy = true);

    if (result != null) {
      image1Path = result.files.single.path;

      if (image1Path.endsWith(".png"))
        image1 = image.decodePng(await File(image1Path).readAsBytes());
      else if (image1Path.endsWith(".jpg"))
        image1 = image.decodeJpg(await File(image1Path).readAsBytes());
      else if (image1Path.endsWith(".bmp"))
        image1 = image.decodeBmp(await File(image1Path).readAsBytes());
      else if (image1Path.endsWith(".gif"))
        image1 = image.decodeGif(await File(image1Path).readAsBytes());

      setState(() => isBusy = false);
    }
  }

  pickFile2() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'gif'],
    );

    setState(() => isBusy = true);

    if (result != null) {
      image2Path = result.files.single.path;

      if (image1Path.endsWith(".png"))
        image2 = image.decodePng(await File(image2Path).readAsBytes());
      else if (image1Path.endsWith(".jpg"))
        image2 = image.decodeJpg(await File(image2Path).readAsBytes());
      else if (image1Path.endsWith(".bmp"))
        image2 = image.decodeBmp(await File(image2Path).readAsBytes());
      else if (image1Path.endsWith(".gif"))
        image2 = image.decodeGif(await File(image2Path).readAsBytes());

      setState(() => isBusy = false);
    }
  }

  loadImages() async {
    var data1 = await rootBundle.load(image1Path);
    var data2 = await rootBundle.load(image2Path);
    image1 = image.decodeJpg(data1.buffer.asUint8List());
    image2 = image.decodeJpg(data2.buffer.asUint8List());

    setState(() {
      isBusy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Image Calculator"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: ImageContainer(image: Image.asset(image1Path))),
                  Expanded(
                      child: ImageContainer(image: Image.asset(image2Path))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                          child: Text("Open File"),
                          onPressed: () => pickFile1()),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                          child: Text("Open File"),
                          onPressed: () => pickFile2()),
                    ),
                  ),
                ],
              ),
              isBusy
                  ? CircularProgressIndicator()
                  : ImageConverter(
                      key: GlobalKey(),
                      image1: image1,
                      image2: image2,
                      imageFilter: imageFilter,
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: size, height: size),
                      SizedBox(
                        width: size,
                        height: size,
                        child: CircleButton(
                          icon: FontAwesome.times,
                          onTap: () => setState(
                            () => imageFilter = ImageFilter.Multiply,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: size,
                        height: size,
                        child: CircleButton(
                          icon: FontAwesome.plus,
                          onTap: () => setState(
                            () => imageFilter = ImageFilter.Add,
                          ),
                        ),
                      ),
                      SizedBox(width: size, height: size),
                      SizedBox(
                        width: size,
                        height: size,
                        child: CircleButton(
                          icon: FontAwesome.minus,
                          onTap: () => setState(
                            () => imageFilter = ImageFilter.Subtract,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(width: size, height: size),
                      SizedBox(
                        width: size,
                        height: size,
                        child: CircleButton(
                          icon: FontAwesome5Solid.divide,
                          onTap: () => setState(
                            () => imageFilter = ImageFilter.Divide,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  const CircleButton({Key key, this.icon, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onTap,
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
    );
  }
}
