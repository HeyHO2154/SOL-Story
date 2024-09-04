import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'models/user_challenge_model.dart';
import 'package:untitled1/config/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class ChallengeListPage extends StatefulWidget {
  final int userNo;

  ChallengeListPage({required this.userNo});

  @override
  _ChallengeListPageState createState() => _ChallengeListPageState();
}

class _ChallengeListPageState extends State<ChallengeListPage> {
  Future<List<UserChallenge>> _fetchChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final email =
        prefs.getString('email') ?? '240825_01@ssafy.com'; // 이메일을 가져오거나 기본값 설정
    print(email);

    try {
      final response = await http
          .get(Uri.parse(REST_API_URL + '/api/challenge/list?email=$email'));
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> challengeData = jsonDecode(response.body);
        return challengeData
            .map((data) => UserChallenge.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load challenges');
      }
    } catch (e) {
      return _getDefaultChallenges();
    }
  }

  Future<int> _fetchChallengeKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final email =
        prefs.getString('email') ?? '240825_01@ssafy.com'; // 이메일을 가져오거나 기본값 설정
    print(email);

    try {
      final response = await http
          .get(Uri.parse(REST_API_URL + '/api/challenge/key?email=$email'));
      if (response.statusCode == 200) {
        final int keys = jsonDecode(response.body);
        return keys;
      } else {
        throw Exception('챌린지 열쇠를 불러오지 못했습니다');
      }
    } catch (e) {
      print('챌린지 열쇠를 가져오는 중에 오류가 발생했습니다: $e');
      return 10; // 기본값
    }
  }

  Future<List<UserChallenge>> _getDefaultChallenges() async {
    return Future.delayed(Duration(seconds: 60), () {
      return [
        // 기본 제공 챌린지 2개
        UserChallenge(
          challengeType: 1,
          category: "식비",
          days: 30,
          challengeName: "이번 달 5만원 더 저축하기",
          rewardKeys: 5,
          assignedDate: DateTime.now().subtract(Duration(days: 10)),
          completeDate: DateTime.now().add(Duration(days: 30)),
          top3Category: ["식비", "교통비", "쇼핑"],
        ),
        UserChallenge(
          challengeType: 1,
          category: "식비",
          days: 7,
          challengeName: "이번 주 3만원 더 저축하기",
          rewardKeys: 3,
          assignedDate: DateTime.now().subtract(Duration(days: 3)),
          completeDate: DateTime.now().add(Duration(days: 7)),
          top3Category: ["식비", "교통비", "쇼핑"],
        ),
        // 지출에 따른 챌린지 3개
        UserChallenge(
          challengeType: 2,
          category: "교통비",
          days: 30,
          challengeName: "한 달 동안 전달 대비 주유비 5만원 줄이기",
          rewardKeys: 4,
          assignedDate: DateTime.now().subtract(Duration(days: 5)),
          completeDate: DateTime.now().add(Duration(days: 30)),
          top3Category: ["식비", "교통비", "쇼핑"],
        ),
        UserChallenge(
          challengeType: 2,
          category: "쇼핑",
          days: 30,
          challengeName: "한 달 동안 전달 대비 온라인 쇼핑 지출 5만원 줄이기",
          rewardKeys: 4,
          assignedDate: DateTime.now().subtract(Duration(days: 5)),
          completeDate: DateTime.now().add(Duration(days: 30)),
          top3Category: ["식비", "교통비", "쇼핑"],
        ),
        UserChallenge(
          challengeType: 2,
          category: "생활비",
          days: 30,
          challengeName: "한 달 동안 전달 대비 전기 요금 3만원 줄이기",
          rewardKeys: 6,
          assignedDate: DateTime.now().subtract(Duration(days: 3)),
          completeDate: DateTime.now().add(Duration(days: 30)),
          top3Category: ["식비", "교통비", "쇼핑"],
        ),
      ];
    });
  }

  String _getMostFrequentCategory(List<String> categories) {
    Map<String, int> categoryCount = {};

    for (var category in categories) {
      if (categoryCount.containsKey(category)) {
        categoryCount[category] = categoryCount[category]! + 1;
      } else {
        categoryCount[category] = 1;
      }
    }

    // 가장 많이 나온 항목을 찾기
    String mostFrequentCategory = categories[0];
    int maxCount = categoryCount[mostFrequentCategory]!;

    categoryCount.forEach((category, count) {
      if (count > maxCount) {
        mostFrequentCategory = category;
        maxCount = count;
      }
    });

    return mostFrequentCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SVG 배경 이미지 설정
          SvgPicture.asset(
            'assets/images/backgroundBK.svg',
            fit: BoxFit.cover,
          ),
          // 정적인 SVG 구름 이미지 설정
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/cloudBK.svg',
              width: 1200,
              height: 800,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 15, 27, 71),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      '챌린지 리스트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'RixYeoljeongdo',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<UserChallenge>>(
                    future: _fetchChallenges().timeout(
                      Duration(seconds: 10),
                      onTimeout: () => _getDefaultChallenges(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('챌린지가 없습니다.'));
                      } else {
                        final challenges = snapshot.data!;
                        return Column(
                          children: [
                            FutureBuilder<int>(
                              future: _fetchChallengeKeys(), // 이메일을 사용하여 호출
                              builder: (context, keySnapshot) {
                                if (keySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (keySnapshot.hasError) {
                                  return Center(
                                      child:
                                          Text('Error: ${keySnapshot.error}'));
                                } else {
                                  final keys = keySnapshot.data ?? 0;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(
                                      '현재 보유 열쇠: $keys개',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'AppleSDGothicNeo',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildSectionTitle('기본 제공 챌린지'),
                                  _buildGoalCard(challenges[0]),
                                  _buildGoalCard(challenges[1]),
                                  _buildSectionTitle('지출에 따른 챌린지'),
                                  _buildGPTInfo(challenges[0].top3Category),
                                  _buildGoalCard(challenges[2]),
                                  _buildGoalCard(challenges[3]),
                                  _buildGoalCard(challenges[4]),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.normal,
            fontFamily: 'RixYeoljeongdo',
          ),
        ),
      ),
    );
  }

  Widget _buildGPTInfo(List<String> top3Category) {
    String mostFrequentCategory = _getMostFrequentCategory(top3Category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '가장 많이 지출되는 항목은  ${top3Category.join(", ")} 입니다.\n따라서 해당 지출 분야와 관련된 챌린지가 생성되었습니다!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'AppleSDGothicNeo',
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(UserChallenge challenge) {
    final completionPercentage = challenge.getCompletionPercentage();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 176, 176, 176)!,
              blurRadius: 3,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            challenge.challengeName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'AppleSDGothicNeo', // 폰트 변경
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('카테고리: ${challenge.category}'),
              Text(
                  '기간: ${DateFormat('yy-MM-dd').format(challenge.assignedDate)}~${DateFormat('yy-MM-dd').format(challenge.completeDate)}'),
              SizedBox(height: 10),
              Stack(
                children: [
                  LinearProgressIndicator(
                    value: completionPercentage,
                    backgroundColor: Colors.grey[300],
                    color: const Color.fromRGBO(64, 104, 255, 1),
                    minHeight: 8,
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              // 버튼 기능 정의
            },
            child: Text('보상 열쇠: ${challenge.rewardKeys}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(64, 104, 255, 1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
