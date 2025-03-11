import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ActionButtons {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<void> takeScreenshot(BuildContext context) async {
    final Uint8List? image = await screenshotController.capture();

    if (image != null) {
      // Save the image to the gallery
      final result = await ImageGallerySaver.saveImage(image, quality: 100, name: "screenshot_${DateTime.now().millisecondsSinceEpoch}");

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Screenshot saved to gallery!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save screenshot.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take screenshot.")),
      );
    }

  }
}