import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();

  Future<File?> getImageFromLibrary() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? file = xFile != null ? File(xFile.path) : null;
    return file;
  }
}
