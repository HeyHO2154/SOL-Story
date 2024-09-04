import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart'; // URL 이동을 위해 추가한 패키지

class Product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임의의 금융 상품 목록
    final List<Map<String, String>> products = [
      {
        'title': '정기예금',
        'description': '안정적인 이자를 제공하는 정기예금 상품입니다.',
        'benefits': '높은 이자율, 원금 보장',
        'url': 'https://www.shinhansavings.com/PD_0002',
      },
      {
        'title': '주식 투자',
        'description': '성장 잠재력이 있는 주식에 투자하여 자산을 늘릴 수 있습니다.',
        'benefits': '높은 수익률, 자산 성장',
        'url': 'https://www.shinhan.com/hpe/index.jsp#051100019999',
      },
      {
        'title': '채권 투자',
        'description': '안정적인 수익을 제공하는 정부 또는 기업 채권 상품입니다.',
        'benefits': '안정적인 수익, 원금 보장',
        'url': 'https://www.shinhan.com/hpe/index.jsp#051100019999',
      },
      {
        'title': '펀드 투자',
        'description': '다양한 자산에 분산 투자하여 위험을 줄이고 안정적인 수익을 추구합니다.',
        'benefits': '다양한 투자, 위험 분산',
        'url': 'https://www.shinhan.com/hpe/index.jsp#051100019999',
      },
      {
        'title': '연금 보험',
        'description': '노후를 대비한 연금 보험 상품으로 안정적인 연금 지급을 보장합니다.',
        'benefits': '안정적인 연금, 세제 혜택',
        'url': 'https://www.shinhansec.com/siw/wealth-management/insurance/bancassurance_prod_tab1_tab6/contents.do',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(64, 104, 255, 1),
        title: Text(
          '선물함',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 타이틀
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                '추천 금융 상품',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 33, 33, 33),
                ),
              ),
            ),
            // 상품 목록
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isDiscounted = index < 1; // 상단 1개 상품에만 세일 표시
                  final reward = _generateRandomReward(); // 랜덤 열쇠 보상 생성

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildProductCard(context, product, isDiscounted, reward),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 랜덤 열쇠 보상 생성
  int _generateRandomReward() {
    final random = Random();
    return 300 + random.nextInt(701); // 300부터 1000까지의 랜덤 숫자
  }

  // 상품 카드 위젯
  Widget _buildProductCard(BuildContext context, Map<String, String> product, bool isDiscounted, int reward) {
    return GestureDetector(
      onTap: () async {
        final url = product['url']!; // 해당 상품의 URL 가져오기
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Stack(
        clipBehavior: Clip.none, // 컨테이너 잘리지 않도록 설정
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromRGBO(64, 104, 255, 1)!,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[100]!,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title']!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['description']!,
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 27, 27, 27)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '혜택: ${product['benefits']!}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 39, 39, 39),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '열쇠 보상: $reward',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDiscounted) ...[
            Positioned(
              top: -10,
              right: 10, // 위치 조정하여 카드 위에 배치
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Text(
                  '열쇠보상 +50%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}