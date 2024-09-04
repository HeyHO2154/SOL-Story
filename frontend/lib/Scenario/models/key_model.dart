import 'package:flutter/material.dart';

class KeyModel with ChangeNotifier {
  int _key = 10000;
  String _currentScenario = ''; // 현재 시나리오 상태 저장

  int get key => _key;
  String get currentScenario => _currentScenario;

  void addKey(int value) {
    _key += value;
    notifyListeners();
  }

  void useKey(int value) {
    if (_key >= value) {
      _key -= value;
      notifyListeners();
    }
  }

  void setCurrentScenario(String scenario) {
    _currentScenario = scenario;
    notifyListeners();
  }

  void clearCurrentScenario() {
    _currentScenario = '';
    notifyListeners();
  }
}
