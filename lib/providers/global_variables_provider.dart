import 'dart:io';

import 'package:flutter/material.dart';

class GlobalVariables extends ChangeNotifier {
  static GlobalVariables instance = GlobalVariables();

  File? image;
  bool isChange = false;
  int index = 1;

// Para una imagen temporal
  void setTemporalImage(File? imageTemp) {
    image = imageTemp;
    notifyListeners();
  }

  File? getTemporalImage() {
    return image;
  }

  void disposeTemporalImage() {
    image = null;
    isChange = false;
  }

  //index del BNavigation.
  void changeIndexBN(int n) {
    index = n;
    notifyListeners();
  }
}
