import 'package:flutter/rendering.dart';
import 'package:image/image.dart';
import 'dart:ui' as ui;

class SpriteService {
  static animateSprite({
    Image sprite,
    int rows,
    int columns,
    Function(Image) onFrameChange,
    int delay = 100,
  }) async {
    var width = sprite.width ~/ columns;
    var height = sprite.height ~/ rows;

    for (var j = 0; j < rows; j++) {
      for (var i = 0; i < columns; i++) {
        onFrameChange(getFrame(sprite, i, j, width, height));
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  static Image getFrame(
      Image sprite, int columnIndex, int rowIndex, int width, int height) {
    var image = Image(width, height);
    for (var j = 0; j < height; j++) {
      for (var i = 0; i < width; i++) {
        var xSpriteIndex = (columnIndex * width) + i;
        var ySpriteIndex = (rowIndex * height) + j;
        image.setPixel(i, j, sprite.getPixel(xSpriteIndex, ySpriteIndex));
      }
    }
    return image;
  }

  static Future<ui.Image> getUiImage(Image image) async {
    ui.Codec codec = await ui.instantiateImageCodec(encodePng(image));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class DrawSprite extends CustomPainter {
  final ui.Image spriteSheet;
  final int row;
  final int column;
  final int x;
  final int y;

  DrawSprite(
    this.spriteSheet,
    this.row,
    this.column,
    this.x,
    this.y,
  );
  @override
  void paint(Canvas canvas, Size size) {
    double width = spriteSheet.width / column;
    double height = spriteSheet.height / row;
    canvas.drawAtlas(
        spriteSheet,
        [
          RSTransform.fromComponents(
              rotation: 0.0,
              scale: 1.0,
              anchorX: 0.0,
              anchorY: 0.0,
              translateX: 0.0,
              translateY: 0.0)
        ],
        [
          ui.Rect.fromLTWH(
              x.toDouble() * width, y.toDouble() * height, width, height)
        ],
        [/* No need for colors */],
        ui.BlendMode.src,
        null /* No need for cullRect */,
        Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
