import 'package:flutter/material.dart';

class OwnedCardsModel extends ChangeNotifier {
  List<String> _ownedPersonCards = [];
  List<String> _ownedObjectCards = [];
  List<String> _ownedPlaceCards = [];

  List<String> get ownedPersonCards => _ownedPersonCards;
  List<String> get ownedObjectCards => _ownedObjectCards;
  List<String> get ownedPlaceCards => _ownedPlaceCards;

  void addCard(String cardName, String cardType) {
    switch (cardType) {
      case 'person':
        if (!_ownedPersonCards.contains(cardName)) {
          _ownedPersonCards.add(cardName);
        }
        break;
      case 'object':
        if (!_ownedObjectCards.contains(cardName)) {
          _ownedObjectCards.add(cardName);
        }
        break;
      case 'place':
        if (!_ownedPlaceCards.contains(cardName)) {
          _ownedPlaceCards.add(cardName);
        }
        break;
    }
    notifyListeners();
  }

  void removeCard(String cardName, String cardType) {
    switch (cardType) {
      case 'person':
        _ownedPersonCards.remove(cardName);
        break;
      case 'object':
        _ownedObjectCards.remove(cardName);
        break;
      case 'place':
        _ownedPlaceCards.remove(cardName);
        break;
    }
    notifyListeners();
  }
}
