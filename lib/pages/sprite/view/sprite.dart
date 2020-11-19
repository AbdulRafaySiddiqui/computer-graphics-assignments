import 'dart:io';
import 'dart:ui' as ui;

import 'package:cg_assignment/utils/sprite_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image/image.dart' as image;

class Sprite extends StatefulWidget {
  @override
  _SpriteState createState() => _SpriteState();
}

class _SpriteState extends State<Sprite> {
  var columnController = TextEditingController();
  var rowController = TextEditingController();
  var delayController = TextEditingController()..text = '200';
  var rowFocusNode = FocusNode();
  var columnFocusNode = FocusNode();
  var isLoading = false;
  int get row => int.parse(rowController?.text);
  int get col => int.parse(columnController?.text);
  var x = 0;
  var y = 0;

  var isPickFile = false;

  var imagePath = 'assets/sprite_sheet_3.png';
  image.Image imageFrame;
  image.Image sprite;
  ui.Image uiSprite;

  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'gif'],
    );

    if (result != null) {
      imagePath = result.files.single.path;
      loadSprite();
    }
  }

  loadSprite() async {
    setState(() => isLoading = true);
    print(imagePath);
    if (imagePath.endsWith(".png"))
      sprite = image.decodePng(await File(imagePath).readAsBytes());
    else if (imagePath.endsWith(".jpg") || imagePath.endsWith(".jpeg"))
      sprite = image.decodeJpg(await File(imagePath).readAsBytes());
    else if (imagePath.endsWith(".bmp"))
      sprite = image.decodeBmp(await File(imagePath).readAsBytes());
    else if (imagePath.endsWith(".gif"))
      sprite = image.decodeGif(await File(imagePath).readAsBytes());

    uiSprite = await SpriteService.getUiImage(sprite);
    setState(() => isLoading = false);
  }

  animateSprite() async {
    // await SpriteService.animateSprite(
    //     sprite: sprite,
    //     rows: int.parse(rowController.text),
    //     columns: int.parse(columnController.text),
    //     delay: int.parse(delayController.text),
    //     onFrameChange: (frame) {
    //       setState(() {
    //         imageFrame = frame;
    //       });
    //     });

    for (var i = 0; i < row; i++) {
      for (var j = 0; j < col; j++) {
        setState(() {
          x = j;
          y = i;
        });
        await Future.delayed(
            Duration(milliseconds: int.parse(delayController.text)));
      }
    }
  }

  changeSprite(value) async {
    imagePath = value;
    var data = await rootBundle.load(imagePath);
    imageFrame = null;

    switch (imagePath) {
      case 'assets/sprite_sheet_1.png':
        rowController.text = '4';
        columnController.text = '4';
        break;
      case 'assets/sprite_sheet_2.jpg':
        rowController.text = '3';
        columnController.text = '6';
        break;
      case 'assets/sprite_sheet_3.png':
        rowController.text = '4';
        columnController.text = '4';
        break;
    }

    if (imagePath.endsWith(".png"))
      sprite = image.decodePng(data.buffer.asUint8List());
    else if (imagePath.endsWith(".jpg"))
      sprite = image.decodeJpg(data.buffer.asUint8List());

    uiSprite = await SpriteService.getUiImage(sprite);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sprite Animation"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  !isPickFile
                      ? DropdownButton(
                          value: imagePath,
                          items: [
                            DropdownMenuItem(
                              child: Text("Sprite Sheet 1"),
                              value: "assets/sprite_sheet_3.png",
                            ),
                            DropdownMenuItem(
                              child: Text("Sprite Sheet 2"),
                              value: "assets/sprite_sheet_2.jpg",
                            ),
                            DropdownMenuItem(
                              child: Text("Sprite Sheet 3"),
                              value: "assets/sprite_sheet_1.png",
                            ),
                          ],
                          onChanged: (value) => changeSprite(value))
                      : RaisedButton(
                          onPressed: () => pickFile(),
                          child: Text("Open File"),
                        ),
                  Spacer(),
                  Text("Pick File"),
                  Switch(
                      value: isPickFile,
                      onChanged: (value) {
                        imagePath = null;
                        setState(() => isPickFile = value);
                      }),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: delayController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () => columnFocusNode.requestFocus(),
                      decoration: InputDecoration(
                        labelText: "Delay(ms)",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: columnController,
                      keyboardType: TextInputType.number,
                      focusNode: columnFocusNode,
                      onEditingComplete: () => rowFocusNode.requestFocus(),
                      decoration: InputDecoration(
                        labelText: "Columns",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: rowFocusNode,
                      controller: rowController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        rowFocusNode.unfocus();
                        animateSprite();
                      },
                      decoration: InputDecoration(
                        labelText: "Rows",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : sprite == null ||
                              sprite.length == 0 ||
                              imagePath == null
                          ? Text("Select sprite...")
                          : isPickFile
                              ? Image.file(File(imagePath))
                              : Image.asset(imagePath)),
            ),
            Expanded(
              child: Center(
                  child: uiSprite == null
                      ? Icon(FontAwesome.pause)
                      : CustomPaint(
                          painter: DrawSprite(uiSprite, row, col, x, y),
                          child: Container())
                  // Image.memory(
                  //     image.encodeJpg(imageFrame),
                  //   ),
                  ),
            ),
            RaisedButton(
              onPressed: () => animateSprite(),
              child: Text("Play animation"),
            )
          ],
        ),
      ),
    );
  }
}
