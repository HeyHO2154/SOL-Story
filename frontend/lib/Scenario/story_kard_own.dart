import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'models/owned_cards_model.dart';

class StoryKardOwn extends StatefulWidget {
  @override
  _StoryKardOwnState createState() => _StoryKardOwnState();
}

class _StoryKardOwnState extends State<StoryKardOwn> {
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                // 상단의 "보유 카드" 텍스트
               Center(
  child: Text(
    '보유 카드',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255),
      fontFamily: 'AppleSDGothicNeo',
    ),
  ),
),
                SizedBox(height: 30),
                // 카테고리 선택 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildCategoryButton('Person', selectedCategory),
                    SizedBox(width: 8.0),
                    _buildCategoryButton('Object', selectedCategory),
                    SizedBox(width: 8.0),
                    _buildCategoryButton('Place', selectedCategory),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: cardsToDisplay.isEmpty
                      ? Center(
                          child: Text(
                            '보유 중인 카드가 없습니다.',
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'AppleSDGothicNeo',
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: cardsToDisplay.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    cardsToDisplay[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 82, 82, 82),
                                      fontFamily: 'AppleSDGothicNeo',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String selectedCategory) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          this.selectedCategory = category;
        });
      },
      child: Text(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: this.selectedCategory == category
            ? const Color.fromARGB(255, 63, 63, 80)
            : const Color.fromARGB(255, 63, 63, 80),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
