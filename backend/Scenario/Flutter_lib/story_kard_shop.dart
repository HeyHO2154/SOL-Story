import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/key_model.dart';
import 'models/owned_cards_model.dart';
import 'models/related_cards.dart'; // 키워드에 따른 카드 데이터

class StoryKardShop extends StatefulWidget {
  @override
  _StoryKardShopState createState() => _StoryKardShopState();
}

class _StoryKardShopState extends State<StoryKardShop> {
  List<Map<String, dynamic>> availableCards = [];
  List<Map<String, dynamic>> additionalCards = [];
  Set<String> purchasedCards = {};
  final String itemNameMaxIncrease = "배달"; // 설정된 키워드
  final int wildCardPrice = 100; // 와일드 카드 가격

  @override
  void initState() {
    super.initState();
    _generateInitialCards();
    _generateAdditionalCards(itemNameMaxIncrease);
  }

  void _generateInitialCards() {
    final Random random = Random();
    List<Map<String, dynamic>> chosenCards = [];

    void _addCardOfType(List<String> cardList, String type) {
      String card;
      int price;
      do {
        card = cardList[random.nextInt(cardList.length)];
        price = type == 'person'
            ? random.nextInt(51) + 50 // 인물 카드 가격: 50~100
            : random.nextInt(50) + 1; // 물건 및 장소 카드 가격: 1~50
      } while (chosenCards.any((c) => c['name'] == card));

      chosenCards.add({
        'name': card,
        'price': price,
        'type': type
      });
    }

    _addCardOfType(
        keywordToPersonCards.values.expand((x) => x).toList(), 'person');
    _addCardOfType(
        keywordToObjectCards.values.expand((x) => x).toList(), 'object');
    _addCardOfType(
        keywordToPlaceCards.values.expand((x) => x).toList(), 'place');

    while (chosenCards.length < 6) {
      String card;
      int price;
      String type;
      List<String> cardList;

      if (random.nextBool()) {
        type = 'person';
        cardList = keywordToPersonCards.values.expand((x) => x).toList();
      } else if (random.nextBool()) {
        type = 'object';
        cardList = keywordToObjectCards.values.expand((x) => x).toList();
      } else {
        type = 'place';
        cardList = keywordToPlaceCards.values.expand((x) => x).toList();
      }

      card = cardList[random.nextInt(cardList.length)];
      price = type == 'person' ? random.nextInt(51) + 50 : random.nextInt(50) + 1;

      if (!chosenCards.any((c) => c['name'] == card)) {
        chosenCards.add({
          'name': card,
          'price': price,
          'type': type
        });
      }
    }

    availableCards = chosenCards;
    setState(() {});
  }

  void _generateAdditionalCards(String itemName) {
    final Random random = Random();
    List<Map<String, dynamic>> keywordCardsList = [];

    // 관련 카드 목록 생성
    List<String> persons = keywordToPersonCards[itemName] ?? [];
    List<String> objects = keywordToObjectCards[itemName] ?? [];
    List<String> places = keywordToPlaceCards[itemName] ?? [];

    // 인물 카드 추가
    if (persons.isNotEmpty) {
      String personCard = persons[random.nextInt(persons.length)];
      keywordCardsList.add({
        'name': personCard,
        'price': random.nextInt(51) + 50,
        'type': 'person',
        'isAvailable': true
      });
    }

    // 물건 카드 추가
    if (objects.isNotEmpty) {
      String objectCard = objects[random.nextInt(objects.length)];
      keywordCardsList.add({
        'name': objectCard,
        'price': random.nextInt(50) + 1,
        'type': 'object',
        'isAvailable': true
      });
    }

    // 장소 카드 추가
    if (places.isNotEmpty) {
      String placeCard = places[random.nextInt(places.length)];
      keywordCardsList.add({
        'name': placeCard,
        'price': random.nextInt(50) + 1,
        'type': 'place',
        'isAvailable': true
      });
    }

    // 부족한 카드 수만큼 추가 카드 생성
    while (keywordCardsList.length < 3) {
      String card;
      int price;
      String type;
      List<String> cardList;

      if (keywordCardsList.where((c) => c['type'] == 'person').length < 1) {
        type = 'person';
        cardList = persons.isNotEmpty ? persons : keywordToPersonCards.values.expand((x) => x).toList();
      } else if (keywordCardsList.where((c) => c['type'] == 'object').length < 1) {
        type = 'object';
        cardList = objects.isNotEmpty ? objects : keywordToObjectCards.values.expand((x) => x).toList();
      } else if (keywordCardsList.where((c) => c['type'] == 'place').length < 1) {
        type = 'place';
        cardList = places.isNotEmpty ? places : keywordToPlaceCards.values.expand((x) => x).toList();
      } else {
        break;
      }

      card = cardList[random.nextInt(cardList.length)];
      price = type == 'person' ? random.nextInt(51) + 50 : random.nextInt(50) + 1;

      if (!keywordCardsList.any((c) => c['name'] == card) &&
          !availableCards.any((c) => c['name'] == card)) {
        keywordCardsList.add({
          'name': card,
          'price': price,
          'type': type,
          'isAvailable': true
        });
      }
    }

    setState(() {
      additionalCards = keywordCardsList;
    });
  }

  void _buyCard(String cardName, int price, String cardType) {
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    final ownedCardsModel = Provider.of<OwnedCardsModel>(context, listen: false);

    if (keyModel.key >= price) {
      setState(() {
        keyModel.useKey(price);
        purchasedCards.add(cardName);
        availableCards.removeWhere((card) => card['name'] == cardName);
        additionalCards.removeWhere((card) => card['name'] == cardName);
        ownedCardsModel.addCard(cardName, cardType);

        // 모든 추가 카드가 구매되었는지 확인
        if (additionalCards.isEmpty) {
          // 관련 카드가 모두 구매된 경우 추가 카드 생성 중지
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$cardName 카드를 구매했습니다!'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('열쇠가 부족합니다'))
      );
    }
  }

  void _buyWildCard() {
    final keyModel = Provider.of<KeyModel>(context, listen: false);

    if (keyModel.key >= wildCardPrice) {
      setState(() {
        keyModel.useKey(wildCardPrice);
        _showWildCardDialog();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('열쇠가 부족합니다'))
      );
    }
  }

  void _showWildCardDialog() {
    final TextEditingController nameController = TextEditingController();
    String selectedType = 'person';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('와일드 카드 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedType,
                items: <String>['person', 'object', 'place'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '카드 이름 입력',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final cardName = nameController.text;
                if (cardName.isNotEmpty) {
                  setState(() {
                    purchasedCards.add(cardName);
                    Provider.of<OwnedCardsModel>(context, listen: false)
                        .addCard(cardName, selectedType);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$cardName 카드를 추가했습니다!'))
                  );
                }
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 페이지가 로드될 때만 카드 목록을 초기화합니다.
    if (additionalCards.isEmpty) {
      _generateAdditionalCards(itemNameMaxIncrease);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('카드 상점'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text('보유 열쇠: ${Provider.of<KeyModel>(context).key}')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기본 6장 카드 표시 (3x2 배열)
            Container(
              constraints: BoxConstraints(
                maxHeight: 600, // 최대 높이를 설정하여 빈 공간 감소
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: availableCards.length,
                itemBuilder: (context, index) {
                  final card = availableCards[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(card['name']),
                        Text('${card['type']} - ${card['price']} 열쇠'),
                        ElevatedButton(
                          onPressed: () => _buyCard(card['name'], card['price'], card['type']),
                          child: Text('구매'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '당신의 금융분석 결과 $itemNameMaxIncrease 항목에 지출이 매우 컸습니다.\n'
                  '따라서 관련 카드를 추가합니다',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Container(
              constraints: BoxConstraints(
                maxHeight: 200, // 최대 높이를 설정하여 빈 공간 감소
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: additionalCards.length,
                itemBuilder: (context, index) {
                  final card = additionalCards[index];
                  return ListTile(
                    title: Text(card['name']),
                    subtitle: Text('${card['type']} - ${card['price']} 열쇠'),
                    trailing: card['isAvailable']
                        ? ElevatedButton(
                      onPressed: () => _buyCard(card['name'], card['price'], card['type']),
                      child: Text('구매'),
                    )
                        : null,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            // 와일드 카드 구매 버튼 추가
            ElevatedButton(
              onPressed: _buyWildCard,
              child: Text('와일드 카드 구매 (${wildCardPrice} 열쇠)'),
            ),
            SizedBox(height: 8.0),
            Text(
              '와일드 카드란?\n사용자가 원하는 대로 내용을 구성할 수 있는 카드입니다',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
