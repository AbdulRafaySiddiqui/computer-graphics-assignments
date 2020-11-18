import 'dart:math';
import 'package:image/image.dart';

class ImageFilters {
  static Image add(Image image1, Image image2) {
    int widht = min(image1.width, image2.width);
    int height = min(image1.height, image2.height);
    Image image = Image(widht, height);

    for (var x = 0; x < widht; x++) {
      for (var y = 0; y < height; y++) {
        var pixel1 = image1.getPixel(x, y);
        var r1 = getBlue(pixel1);
        var g1 = getGreen(pixel1);
        var b1 = getBlue(pixel1);
        var a1 = getAlpha(pixel1);

        var pixel2 = image2.getPixel(x, y);
        var r2 = getBlue(pixel2);
        var g2 = getGreen(pixel2);
        var b2 = getBlue(pixel2);
        var a2 = getAlpha(pixel2);

        image.setPixel(x, y, getColor(r1 + r2, g1 + g2, b1 + b2, a1 + a2));
      }
    }

    return image;
  }

  static Image subtract(Image image1, Image image2) {
    int widht = min(image1.width, image2.width);
    int height = min(image1.height, image2.height);
    Image image = Image(widht, height);

    for (var x = 0; x < widht; x++) {
      for (var y = 0; y < height; y++) {
        var pixel1 = image1.getPixel(x, y);
        var r1 = getBlue(pixel1);
        var g1 = getGreen(pixel1);
        var b1 = getBlue(pixel1);
        var a1 = getAlpha(pixel1);

        var pixel2 = image2.getPixel(x, y);
        var r2 = getBlue(pixel2);
        var g2 = getGreen(pixel2);
        var b2 = getBlue(pixel2);
        var a2 = getAlpha(pixel2);

        image.setPixel(x, y, getColor(r1 - r2, g1 - g2, b1 - b2, a1 - a2));
      }
    }

    return image;
  }

  static Image multiply(Image image1, Image image2) {
    int widht = min(image1.width, image2.width);
    int height = min(image1.height, image2.height);
    Image image = Image(widht, height);

    for (var x = 0; x < widht; x++) {
      for (var y = 0; y < height; y++) {
        var pixel1 = image1.getPixel(x, y);
        var r1 = getBlue(pixel1);
        var g1 = getGreen(pixel1);
        var b1 = getBlue(pixel1);
        var a1 = getAlpha(pixel1);

        var pixel2 = image2.getPixel(x, y);
        var r2 = getBlue(pixel2);
        var g2 = getGreen(pixel2);
        var b2 = getBlue(pixel2);
        var a2 = getAlpha(pixel2);

        image.setPixel(x, y, getColor(r1 * r2, g1 * g2, b1 * b2, a1 * a2));
      }
    }

    return image;
  }

  static Image divide(Image image1, Image image2) {
    int widht = min(image1.width, image2.width);
    int height = min(image1.height, image2.height);
    Image image = Image(widht, height);

    for (var x = 0; x < widht; x++) {
      for (var y = 0; y < height; y++) {
        var pixel1 = image1.getPixel(x, y);
        var r1 = getBlue(pixel1);
        var g1 = getGreen(pixel1);
        var b1 = getBlue(pixel1);
        var a1 = getAlpha(pixel1);

        var pixel2 = image2.getPixel(x, y);
        var r2 = getBlue(pixel2);
        var g2 = getGreen(pixel2);
        var b2 = getBlue(pixel2);
        var a2 = getAlpha(pixel2);

        image.setPixel(
            x,
            y,
            getColor(r2 == 0 ? r1 : r1 ~/ r2, g2 == 0 ? g1 : g1 ~/ g2,
                b2 == 0 ? b1 : b1 ~/ b2, a2 == 0 ? a1 : a1 ~/ a2));
      }
    }

    return image;
  }
}
