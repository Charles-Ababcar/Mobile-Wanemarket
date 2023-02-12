import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerWrapper {

  static ImagePicker picker = ImagePicker();

  static Future<File?> getImageFromGallery(ImageSource imageSource) async {

    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      return image;
    }

    return null;

  }

}
