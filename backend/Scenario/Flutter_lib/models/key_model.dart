import 'package:flutter/material.dart';

class KeyModel extends ChangeNotifier {
  int _key = 1000;

  int get key => _key;

  void useKey(int amount) {
    if (_key >= amount) {
      _key -= amount;
      notifyListeners();
    }
  }

  void addKey(int amount) {
    _key += amount;
    notifyListeners();
  }
}
