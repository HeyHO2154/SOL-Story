import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/key_model.dart';
import 'models/owned_cards_model.dart';
import 'models/related_cards.dart';

class StoryKardShop extends StatefulWidget {
  @override
  _StoryKardShopState createState() => _StoryKardShopState();
}

class _StoryKardShopState extends State<StoryKardShop> {
  List<Map<String, dynamic>> availableCards = [];
  List<Map<String, dynamic>> additionalCards = [];
  Set<String> purchasedCards = {};
  final String itemNameMaxIncrease = "배달";
  final int wildCardPrice = 100;
  bool initialCardsExhausted = false;
  bool additionalCardsExhausted = false;
  Timer? _timer;
  Duration _timeUntilMidnight = Duration.zero;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadState().then((_) {
      _resetCards(); // 초기화 후 카드 생성 -시연용
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _calculateTimeUntilMidnight();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _calculateTimeUntilMidnight();
      });
    });
  }

  void _calculateTimeUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _timeUntilMidnight = midnight.difference(now);
  }

  void _generateInitialCards() {
    if (availableCards.isNotEmpty) return;

    final Random random = Random();
    List<Map<String, dynamic>> chosenCards = [];

    void _addCardOfType(List<String> cardList, String type) {
      String card;
      int price;
      do {
        card = cardList[random.nextInt(cardList.length)];
        price = type == 'person'
            ? random.nextInt(51) + 50
            : random.nextInt(50) + 1;
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
    _saveState();
    setState(() {});

    print('Initial Cards Generated: $availableCards');
  }

  void _resetCards() {
    setState(() {
      availableCards.clear();
      additionalCards.clear();
      purchasedCards.clear();
      initialCardsExhausted = false;
      additionalCardsExhausted = false;
    });
    _generateInitialCards();

    // Ensure itemNameMaxIncrease is a valid category name
    if (keywordToPersonCards.containsKey(itemNameMaxIncrease) ||
        keywordToObjectCards.containsKey(itemNameMaxIncrease) ||
        keywordToPlaceCards.containsKey(itemNameMaxIncrease)) {
      _generateAdditionalCards(itemNameMaxIncrease);
    } else {
      // Handle the case where itemNameMaxIncrease is not a valid category
      print('Invalid itemNameMaxIncrease value: $itemNameMaxIncrease');
      // Optionally, set additionalCards to empty or show a warning to the user
    }
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

        if (availableCards.isEmpty) {
          initialCardsExhausted = true;
        }

        if (additionalCards.isEmpty) {
          additionalCardsExhausted = true;
        }
      });
      _saveState();
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
    final nameController = TextEditingController();
    String selectedType = 'person'; // 기본 선택값

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('와일드 카드 생성'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '카드 이름'),
                  ),
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: <String>['person', 'object', 'place']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final cardName = nameController.text;

                  setState(() {
                    // 보유 카드 목록에 와일드 카드 추가
                    final ownedCardsModel = Provider.of<OwnedCardsModel>(context, listen: false);
                    ownedCardsModel.addCard(cardName, selectedType);

                    // 선택된 카테고리에 맞는 추가 카드 생성
                    _generateAdditionalCards(itemNameMaxIncrease);

                    // 상태를 저장합니다.
                    _saveState();
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _generateAdditionalCards(String itemName) {
    final Random random = Random();
    List<Map<String, dynamic>> keywordCardsList = [];

    // 카테고리별 카드 리스트 가져오기
    List<String> persons = keywordToPersonCards[itemName] ?? [];
    List<String> objects = keywordToObjectCards[itemName] ?? [];
    List<String> places = keywordToPlaceCards[itemName] ?? [];

    // 카드 타입별 카드 생성
    void _addCardIfAvailable(List<String> cardList, String type) {
      if (cardList.isNotEmpty) {
        String card = cardList[random.nextInt(cardList.length)];
        keywordCardsList.add({
          'name': card,
          'price': type == 'person' ? random.nextInt(51) + 50 : random.nextInt(50) + 1,
          'type': type,
          'isAvailable': true
        });
      }
    }

    // 필요한 카드 타입에 따라 카드 추가
    _addCardIfAvailable(persons, 'person');
    _addCardIfAvailable(objects, 'object');
    _addCardIfAvailable(places, 'place');

    // 카드 수가 부족한 경우 추가 카드 생성
    while (keywordCardsList.length < 3) {
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

      String card = cardList[random.nextInt(cardList.length)];
      int price = type == 'person' ? random.nextInt(51) + 50 : random.nextInt(50) + 1;

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

    additionalCards = keywordCardsList;
    _saveState();
    setState(() {});

    print('Additional Cards Generated: $additionalCards');
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final keyModel = Provider.of<KeyModel>(context, listen: false);

    await prefs.setInt('key', keyModel.key);
    await prefs.setStringList('purchasedCards', purchasedCards.toList());

    await prefs.setString('availableCards', jsonEncode(availableCards));
    await prefs.setString('additionalCards', jsonEncode(additionalCards));
    await prefs.setBool('initialCardsExhausted', initialCardsExhausted);
    await prefs.setBool('additionalCardsExhausted', additionalCardsExhausted);
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // 카드 및 기타 상태 로드
      availableCards = (jsonDecode(prefs.getString('availableCards') ?? '[]') as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      additionalCards = (jsonDecode(prefs.getString('additionalCards') ?? '[]') as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      purchasedCards = Set<String>.from(prefs.getStringList('purchasedCards') ?? []);
      initialCardsExhausted = prefs.getBool('initialCardsExhausted') ?? false;
      additionalCardsExhausted = prefs.getBool('additionalCardsExhausted') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyModel = Provider.of<KeyModel>(context);

    print('Available Cards: $availableCards');
    print('Additional Cards: $additionalCards');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지 설정
          SvgPicture.asset(
            'assets/images/backgroundBBK.svg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
           Positioned(
        top: 40, // 상단으로부터의 거리
        left: 1, // 왼쪽으로부터의 거리
        child: RawMaterialButton(
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
          elevation: 2.0,
          fillColor: Colors.white.withOpacity(0.3),
          child: Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
           // 구름 이미지 설정
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/star.svg',
              width: 1200,
              height: 800,
              fit: BoxFit.contain,
            ),
          ),
          // 상단 제목 및 열쇠 정보
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '스토리 카드 상점',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                Text(
                  '열쇠: ${keyModel.key}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
              ],
            ),
          ),
          // 본문 콘텐츠
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                // 오늘의 랜덤 카드
                Text(
                  '오늘의 랜덤 카드!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: initialCardsExhausted
                      ? Center(
                          child: Text(
                            '모든 카드를 구매하셨습니다.\n다음 카드 리필까지 남은 시간: ${_timeUntilMidnight.toString().split('.').first}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'AppleSDGothicNeo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: availableCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            final card = availableCards[index];
                            final isPurchased =
                                purchasedCards.contains(card['name']);

                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  card['name'],
                                  style: TextStyle(
                                    decoration: isPurchased
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle:
                                    Text('가격: ${card['price']} 열쇠'),
                                trailing: ElevatedButton(
                                  onPressed: isPurchased
                                      ? null
                                      : () => _buyCard(
                                          card['name'],
                                          card['price'],
                                          card['type']),
                                  child: Text('구매하기'),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 20),
                // 추가 카드 제목
                Text(
                  '"$itemNameMaxIncrease" 키워드 카드',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: additionalCardsExhausted
                      ? Center(
                          child: Text(
                            '모든 카드를 구매하셨습니다.\n다음 카드 리필까지 남은 시간: ${_timeUntilMidnight.toString().split('.').first}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'AppleSDGothicNeo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: additionalCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            final card = additionalCards[index];
                            final isPurchased =
                                purchasedCards.contains(card['name']);

                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  card['name'],
                                  style: TextStyle(
                                    decoration: isPurchased
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle:
                                    Text('가격: ${card['price']} 열쇠'),
                                trailing: ElevatedButton(
                                  onPressed: isPurchased
                                      ? null
                                      : () => _buyCard(
                                          card['name'],
                                          card['price'],
                                          card['type']),
                                  child: Text('구매하기'),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 20),
                // 와일드 카드 구매 버튼
                ElevatedButton(
                  onPressed: _buyWildCard,
                  child: Text('와일드 카드 구매하기 (열쇠: $wildCardPrice개)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 63, 80), // 버튼 색상
                    foregroundColor: Colors.white, // 버튼 텍스트 색상
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                // 배달 추가 카드 밑에 텍스트
                Text(
                  "지출분석 결과 '배달' 지출 증감이 가장 높았습니다",
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 241, 241, 241),
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
