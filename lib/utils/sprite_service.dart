import 'package:image/image.dart';

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
}
