import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage? _storage; //= FirebaseStorage.instance;
  Reference? _baseRef; //= _storage.ref();

  //final String _profileImages = "profile_images";

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage!.ref();
  }

  Future<TaskSnapshot?> uploadImage(
      String uid, File image, String location) async {
    try {
      TaskSnapshot? uploadTaskSnapshot =
          await _baseRef?.child(location).child(uid).putFile(image);

      // Aquí puedes verificar si la carga fue exitosa antes de retornar el resultado.
      if (uploadTaskSnapshot != null &&
          uploadTaskSnapshot.state == TaskState.success) {
        return uploadTaskSnapshot;
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return null;
  }
}
