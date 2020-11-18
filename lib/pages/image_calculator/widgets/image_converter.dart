import 'package:cg_assignment/pages/image_calculator/widgets/image_container.dart';
import 'package:cg_assignment/utils/image_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as image;

enum ImageFilter { Add, Subtract, Multiply, Divide }

class ImageConverter extends StatefulWidget {
  final image.Image image1;
  final image.Image image2;
  final ImageFilter imageFilter;

  const ImageConverter(
      {Key key, this.image1, this.image2, this.imageFilter = ImageFilter.Add})
      : super(key: key);

  @override
  _ImageConverterState createState() => _ImageConverterState();
}

class _ImageConverterState extends State<ImageConverter> {
  @override
  void initState() {
    super.initState();
    filterImage();
  }

  bool isBusy = false;
  image.Image filteredImage;

  filterImage() {
    setState(() {
      isBusy = true;
    });

    switch (widget.imageFilter) {
      case ImageFilter.Add:
        filteredImage = ImageFilters.add(widget.image1, widget.image2);
        break;
      case ImageFilter.Subtract:
        filteredImage = ImageFilters.subtract(widget.image1, widget.image2);
        break;
      case ImageFilter.Multiply:
        filteredImage = ImageFilters.multiply(widget.image1, widget.image2);
        break;
      case ImageFilter.Divide:
        filteredImage = ImageFilters.divide(widget.image1, widget.image2);
        break;
      default:
    }

    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? CircularProgressIndicator()
        : ImageContainer(image: Image.memory(image.encodeJpg(filteredImage)));
  }
}
