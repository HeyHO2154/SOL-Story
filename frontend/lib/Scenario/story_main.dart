import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:untitled1/Scenario/models/key_model.dart';
import 'package:untitled1/Scenario/story_kard_own.dart';
import 'package:untitled1/Scenario/story_kard_shop.dart';
import 'package:untitled1/Scenario/story_new.dart';
import 'package:untitled1/config/constants.dart';
import 'story_own.dart';
import 'package:http/http.dart' as http;

class StoryMain extends StatefulWidget {
  @override
  _StoryMainState createState() => _StoryMainState();
}

class _StoryMainState extends State<StoryMain> {
  String _scenarioGenre = '';

  @override
  Widget build(BuildContext context) {
    final keyModel = Provider.of<KeyModel>(context);
    _fetchFinancialScore();
    _fetchChallengeScore();
    // 점수 수정
    int scoreAchievement = 32;
    int scoreAnalysis = 24;
    int storyNewKeys = 100;

    // 총점 계산
    int totalScore = scoreAchievement + scoreAnalysis;

    // 장르 결정
    String genre;
    if (totalScore >= 81) {
      genre = '히어로 장르';
    } else if (totalScore >= 61) {
      genre = '로맨스 장르';
    } else if (totalScore >= 41) {
      genre = '일반 장르';
    } else if (totalScore >= 21) {
      genre = '스릴러 장르';
    } else {
      genre = '호러 장르';
    }

    // 장르 저장
    _scenarioGenre = genre;

    void _checkAndNavigate(int requiredKeys, Widget page) {
      if (keyModel.key >= requiredKeys) {
        keyModel.useKey(requiredKeys);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('열쇠가 부족합니다'),
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지 설정
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/backgroundBBK.svg',
              fit: BoxFit.cover,
            ),
          ),
          // 뒤로가기 버튼 추가
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
          // 상단에 star.svg 이미지 설정
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/star.svg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3, // 화면 상단에 배치
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 상단 중앙에 '이야기 보따리' 텍스트
                SizedBox(height: 100),
                Text(
                  '이야기 보따리',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'RixYeoljeongdo',
                  ),
                ),
                SizedBox(height: 20),
                // 중앙에 열쇠 이미지
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Row의 크기를 자식의 크기에 맞춥니다.
                    children: [
                      Image.asset(
                        'assets/images/key.png', // 열쇠 이미지 경로
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 8), // 이미지와 텍스트 사이의 간격
                      Text(
                        '${keyModel.key}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'RixYeoljeongdo',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                // 4개의 박스 (버튼)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildCardButton(
                        context,
                        icon: Icons.create,
                        text: '시나리오 생성 (열쇠 100개)',
                        onPressed: () =>
                            _checkAndNavigate(storyNewKeys, StoryNew()),
                      ),
                      SizedBox(height: 10),
                      _buildCardButton(
                        context,
                        icon: Icons.book,
                        text: '보유중인 카드',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryKardOwn()),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildCardButton(
                        context,
                        icon: Icons.card_giftcard,
                        text: '카드 상점',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryKardShop()),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildCardButton(
                        context,
                        icon: Icons.save,
                        text: '저장된 이야기',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoryOwn()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 하단의 "오늘의 점수는" 및 부채꼴
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255)!
                      .withOpacity(0.9),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(100.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      '오늘의 점수는?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'RixYeoljeongdo',
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomPaint(
                      size: Size(300, 150),
                      painter: FanChartPainter(totalScore: totalScore),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '목표달성 ${scoreAchievement}점 + 지출동향 ${scoreAnalysis}점 = 총점 ${totalScore}점',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'AppleSDGothicNeo',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '오늘의 장르: $genre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AppleSDGothicNeoB',
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 63, 63, 80),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
                      ),
                    ],
                    fontFamily: 'AppleSDGothicNeoB',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int> _fetchChallengeScore() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? '240825_01@ssafy.com';

  try {
    final response = await http
        .get(Uri.parse(REST_API_URL + '/api/challenge/score?email=$email'));

    if (response.statusCode == 200) {
      final int score = jsonDecode(response.body);
      return score;
    } else {
      throw Exception('사용자 점수를 불러오지 못했습니다');
    }
  } catch (e) {
    print('사용자 점수를 가져오는 중에 오류가 발생했습니다: $e');
    return 0;
  }
}

Future<int> _fetchFinancialScore() async {
  final prefs = await SharedPreferences.getInstance();
  final userNo = prefs.getInt('userNo') ?? 1;

  try {
    final response = await http.get(Uri.parse(
        REST_API_URL + '/api/challenge/financial-score?userNo=$userNo'));

    if (response.statusCode == 200) {
      final int financialScore = jsonDecode(response.body);
      return financialScore;
    } else {
      throw Exception('재무 점수를 불러오지 못했습니다');
    }
  } catch (e) {
    print('재무 점수를 가져오는 중에 오류가 발생했습니다: $e');
    return 0;
  }
}

class FanChartPainter extends CustomPainter {
  final int totalScore;

  FanChartPainter({required this.totalScore});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke // 테두리만 그리도록 설정
      ..strokeWidth = 9.0 // 테두리 두께 설정
      ..shader = LinearGradient(
        colors: [
          Color.fromARGB(255, 239, 82, 71),
          Color.fromARGB(255, 249, 168, 47),
          Color.fromARGB(255, 136, 230, 140),
          Color.fromARGB(255, 92, 181, 255),
          Color.fromARGB(255, 208, 74, 231),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double startAngle = 3.14; // 시작 각도 (180도)
    final double sweepAngle = 3.14; // 끝 각도 (180도)
    final double radius = size.width * 0.35; // 크기를 줄이기 위해 반지름 설정

    final path = Path()
      ..arcTo(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height), radius: radius),
        startAngle,
        sweepAngle,
        false,
      );

    canvas.drawPath(path, paint);

    // 아이콘 표시 위치 계산
    final double iconAngle = (totalScore / 100) * sweepAngle + startAngle;
    final double iconX = size.width / 2 + radius * cos(iconAngle);
    final double iconY = size.height + radius * sin(iconAngle);

    final icon = Icons.arrow_downward_outlined;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 35.0,
          fontFamily: icon.fontFamily,
          color: const Color.fromARGB(255, 255, 88, 88),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.maxFinite);

    textPainter.paint(canvas, Offset(iconX - 15, iconY - 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
