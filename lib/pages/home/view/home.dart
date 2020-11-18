import 'package:cg_assignment/pages/image_calculator/view/image_calculator.dart';
import 'package:cg_assignment/pages/sprite/view/sprite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Select Assignment",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Image Calculator"),
                      onTap: () => Get.to(ImageCalculator()),
                    ),
                    ListTile(
                      title: Text("Sprite Animation"),
                      onTap: () => Get.to(Sprite()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
