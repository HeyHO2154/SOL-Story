import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/UserProfile/FinancialAnaly/FinancialAnaly.dart';
import 'package:untitled1/config/constants.dart';
import 'package:untitled1/UserProfile/UserDetail/UserDetailconstants.dart';
import 'package:untitled1/UserProfile/UserDetail/loadUserInfo.dart';
import 'package:untitled1/MainPage/MainPage.dart';

class UserProfile extends StatefulWidget {
  final int userNo;

  UserProfile({required this.userNo});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: loadUserProfile(widget.userNo).timeout(
        const Duration(seconds: 60),
        onTimeout: () => {
          'name': '김싸피',
          'birthDate': '1995.07.06',
          'gender': '남자',
          'hobbies': ['등산', '낚시', '요리', '독서', '캠핑'],
          'interests': ['패션', '음악', 'IT 기술', '건강 관리', '경제/재테크'],
          'mbti': 'ENFP',
          'balance': '0',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Error loading profile'));
        } else {
          final profileData = snapshot.data!;
          final hobbies =
              (profileData['hobbies'] as List<dynamic>).cast<String>();
          final interests =
              (profileData['interests'] as List<dynamic>).cast<String>();

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                  'assets/images/background.svg',
                  fit: BoxFit.cover,
                ),
                // 정적인 SVG 구름 이미지 설정
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/cloud1.svg',
                    width: 1200,
                    height: 800,
                    fit: BoxFit.contain, // 구름 이미지를 화면 전체에 걸쳐 표시
                  ),
                ),

                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 60),
                    _buildProfileCard(profileData),
                    const SizedBox(height: 20),
                    _buildSkillSection(hobbies),
                    const SizedBox(height: 20),
                    _buildInterestSection(interests),
                    const SizedBox(height: 20),
                    _buildMBTISection(profileData['mbti']),
                    const SizedBox(height: 20),
                    _buildBalanceSection(context, profileData['balance']),
                  ],
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainPage(userNo: widget.userNo)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profileData) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(
                'assets/images/${profileData['mbti'] ?? 'default'}.webp'),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileData['name'] ?? '김싸피',
                  style: const TextStyle(
                    fontFamily: 'AppleSDGothicNeo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '생년월일 : ${profileData['birthDate'] ?? '1995.07.06'}',
                  style: const TextStyle(
                    fontFamily: 'AppleSDGothicNeo',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profileData['gender'] ?? '남자',
                  style: const TextStyle(
                    fontFamily: 'AppleSDGothicNeo',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSection(List<String> hobbies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '취미',
          style: TextStyle(
            fontFamily: 'AppleSDGothicNeo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: hobbies.map((hobby) {
            return _buildSkillCard(hobby, const Color(0xFF1F14FA));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestSection(List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '관심사',
          style: TextStyle(
            fontFamily: 'AppleSDGothicNeo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: interests.map((interest) {
            return _buildSkillCard(interest, const Color(0xFF1F14FA));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMBTISection(String? mbti) {
    String mbtiDescription = getMbtiDescription(mbti ?? '알 수 없음');
    Color mbtiColor = getMbtiColor(mbti ?? 'default');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mbtiColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 MBTI ($mbti)',
            style: const TextStyle(
              fontFamily: 'AppleSDGothicNeo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  mbtiDescription,
                  style: const TextStyle(
                    fontFamily: 'AppleSDGothicNeo',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context, String balance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 75, 59, 255).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '나의 통장 잔고',
                style: TextStyle(
                  fontFamily: 'AppleSDGothicNeo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text(
                '$balance 원',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: TextButton.icon(
              icon: const Icon(
                Icons.arrow_forward,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              label: const Text(
                '나의 지출 정보 보러가기',
                style: TextStyle(
                  fontFamily: 'AppleSDGothicNeo',
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinancialAnaly(userNo: widget.userNo),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String skill, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  String getMbtiDescription(String mbti) {
    const descriptions = {
      'ESTP': '향락가: 가능한 많은 재미를 추구합니다. 큰 위험을 무릅쓰고 돈을 씁니다.',
      'ESFP': '감정적인 소비자: 물건을 구매할 때 감정에 이끌립니다.',
      'ISFP': '갬블러: 값비싼 옷과 명품으로 자신을 표현합니다.',
      'ISTP': '사치품 구매자: 사치품에 약하고 경솔한 지출 성향이 있습니다.',
      'ESFJ': '지위 과시자: 부를 과시하고 싶다는 감정에 돈을 낭비합니다.',
      'ESTJ': '검소한 절약가: 지나치게 아끼는 듯한 인상을 줄 수 있습니다.',
      'ISFJ': '세심한 소비자: 소박한 지출에 쉽게 만족합니다.',
      'ISTJ': '최고의 건축가: 낭비하지 않지만 대외적인 이미지에 지출합니다.',
      'ENTJ': '위험 감수자: 돈을 잘 벌지만 저축에 관심이 없습니다.',
      'ENTP': '신중한 살림꾼: 자신의 소득 내에서 신중하게 지출합니다.',
      'INTJ': '스트레스 쇼퍼: 검소하지만 스트레스를 받을 때 충동적으로 소비합니다.',
      'INTP': '경험 탐구자: 검소하지만 새로운 경험에 큰 돈을 씁니다.',
      'ENFJ': '미니멀리스트: 돈이 꼭 필요하지 않은 유형입니다.',
      'ENFP': '낭비벽: 소비 생활에 끝이 없습니다.',
      'INFJ': '소셜 지출가: 친구들에 따라 사치스러운 생활로 유혹받습니다.',
      'INFP': '강박적인 구매자: 자신이 버는 만큼 소비하는 유형입니다.',
    };

    return descriptions[mbti] ?? '알 수 없는 MBTI 유형입니다.';
  }

  Color getMbtiColor(String mbti) {
    const colorMapping = {
      'ESTP': Color(0xFF080C37),
      'ESFP': Color(0xFF080C37),
      'ISFP': Color(0xFF101D60),
      'ISTP': Color(0xFF101D60),
      'ESFJ': Color(0xFF192F89),
      'ESTJ': Color(0xFF192F89),
      'ISFJ': Color(0xFF2341B2),
      'ISTJ': Color(0xFF2341B2),
      'ENTJ': Color(0xFF2E53DB),
      'ENTP': Color(0xFF2E53DB),
      'INTJ': Color(0xFF4068FF),
      'INTP': Color(0xFF4068FF),
      'ENFJ': Color(0xFF5C7FFF),
      'ENFP': Color(0xFF5C7FFF),
      'INFJ': Color(0xFF8AA3FF),
      'INFP': Color(0xFF8AA3FF),
    };

    return colorMapping[mbti] ?? Colors.grey;
  }
}
