import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/owned_cards_model.dart';

class StoryKardOwn extends StatefulWidget {
  @override
  _StoryKardOwnState createState() => _StoryKardOwnState();
}

class _StoryKardOwnState extends State<StoryKardOwn> {
  // 선택된 카드 종류
  String selectedCategory = 'Person';

  @override
  Widget build(BuildContext context) {
    final ownedCardsModel = Provider.of<OwnedCardsModel>(context);

    List<String> cardsToDisplay;
    switch (selectedCategory) {
      case 'Person':
        cardsToDisplay = ownedCardsModel.ownedPersonCards;
        break;
      case 'Object':
        cardsToDisplay = ownedCardsModel.ownedObjectCards;
        break;
      case 'Place':
        cardsToDisplay = ownedCardsModel.ownedPlaceCards;
        break;
      default:
        cardsToDisplay = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('보유 카드'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                selectedCategory = result;
              });
            },
            itemBuilder: (BuildContext context) => <String>['Person', 'Object', 'Place']
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cardsToDisplay.isEmpty
            ? Center(child: Text('보유 중인 카드가 없습니다.'))
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: cardsToDisplay.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cardsToDisplay[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
