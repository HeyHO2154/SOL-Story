/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // for parsing MBTI file

import 'package:untitled1/UserProfile/FinancialAnaly/FinancialAnaly.dart';
import 'user_info_form_screen.dart'; // UserInfoFormScreen을 임포트합니다.

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'age': prefs.getString('age'),
      'gender': prefs.getString('gender'),
      'location': prefs.getString('location'),
      'mbti': prefs.getString('mbti'),
      'hobbies': prefs.getStringList('hobbies') ?? [],
      'interests': prefs.getStringList('interests') ?? [],
    };
  }

  Future<void> _resetUserInfo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // SharedPreferences 초기화
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UserInfoFormScreen()), // 입력 화면으로 이동
    );
  }

  String _getMbtiDescription(String mbti) {
    Map<String, String> mbtiDescriptions = {
      // 탐험가 유형(ESFP, ESTP, ISFP, ISTP)
      'ESTP': '향락가: 가능한 많은 재미를 추구합니다. 큰 위험을 무릅쓰고 돈을 씁니다.',
      'ESFP': '감정적인 소비자: 물건을 구매할 때 감정에 이끌립니다.',
      'ISFP': '갬블러: 값비싼 옷과 명품으로 자신을 표현합니다.',
      'ISTP': '사치품 구매자: 사치품에 약하고 경솔한 지출 성향이 있습니다.',
      // 감시인 유형(ESFJ, ESTJ, ISFJ, ISTJ)
      'ESFJ': '지위 과시자: 부를 과시하고 싶다는 감정에 돈을 낭비합니다.',
      'ESTJ': '검소한 절약가: 지나치게 아끼는 듯한 인상을 줄 수 있습니다.',
      'ISFJ': '세심한 소비자: 소박한 지출에 쉽게 만족합니다.',
      'ISTJ': '최고의 건축가: 낭비하지 않지만 대외적인 이미지에 지출합니다.',
      // 분석가 유형(ENTJ, ENTP, INTJ, INTP)
      'ENTJ': '위험 감수자: 돈을 잘 벌지만 저축에 관심이 없습니다.',
      'ENTP': '신중한 살림꾼: 자신의 소득 내에서 신중하게 지출합니다.',
      'INTJ': '스트레스 쇼퍼: 검소하지만 스트레스를 받을 때 충동적으로 소비합니다.',
      'INTP': '경험 탐구자: 검소하지만 새로운 경험에 큰 돈을 씁니다.',
      // 외교관 유형(ENFJ, ENFP, INFP, INFJ)
      'ENFJ': '미니멀리스트: 돈이 꼭 필요하지 않은 유형입니다.',
      'ENFP': '낭비벽: 소비 생활에 끝이 없습니다.',
      'INFJ': '소셜 지출가: 친구들에 따라 사치스러운 생활로 유혹받습니다.',
      'INFP': '강박적인 구매자: 자신이 버는 만큼 소비하는 유형입니다.',
    };

    return mbtiDescriptions[mbti] ?? '알 수 없는 MBTI 유형입니다.';
  }

  Color _getMbtiColor(String mbti) {
    Map<String, Color> mbtiColors = {
      // 파스텔 톤의 배경색 지정
      'ESTP': Colors.pink.withOpacity(0.7),
      'ESFP': Colors.orangeAccent.withOpacity(0.7),
      'ISFP': Colors.yellow.withOpacity(0.7),
      'ISTP': Colors.lightGreenAccent.withOpacity(0.7),
      'ESFJ': Colors.cyanAccent.withOpacity(0.7),
      'ESTJ': Colors.teal.withOpacity(0.7),
      'ISFJ': Colors.lightBlueAccent.withOpacity(0.7),
      'ISTJ': Colors.indigoAccent.withOpacity(0.7),
      'ENTJ': Colors.purpleAccent.withOpacity(0.7),
      'ENTP': Colors.redAccent.withOpacity(0.7),
      'INTJ': Colors.amber.withOpacity(0.7),
      'INTP': Colors.greenAccent.withOpacity(0.7),
      'ENFJ': Colors.blueAccent.withOpacity(0.7),
      'ENFP': Colors.pinkAccent.withOpacity(0.7),
      'INFJ': Colors.deepPurpleAccent.withOpacity(0.7),
      'INFP': Colors.purple.withOpacity(0.7),
    };

    return mbtiColors[mbti] ?? Colors.grey.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        } else {
          final profileData = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color(0xFFA7B4D4),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 60),
                    _buildProfileCard(profileData),
                    const SizedBox(height: 20),
                    _buildSkillSection(profileData['hobbies']),
                    const SizedBox(height: 20),
                    _buildInterestSection(profileData['interests']),
                    const SizedBox(height: 20),
                    _buildMBTISection(profileData['mbti']),
                    const SizedBox(height: 20),
                    _buildBalanceSection(context),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _resetUserInfo(context), // 정보 재입력 버튼
                        child: const Text('정보 재입력'),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
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
        color: const Color(0xB3E3E3E3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/profile.webp'),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileData['name'] ?? '사용자',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${profileData['age']}세',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profileData['gender'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profileData['location'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: hobbies.map((hobby) {
            return _buildSkillCard(
                hobby, const Color.fromARGB(255, 11, 64, 164));
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
            return _buildSkillCard(
                interest, const Color.fromARGB(255, 11, 110, 164));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMBTISection(String? mbti) {
    String mbtiDescription = _getMbtiDescription(mbti ?? '알 수 없음');
    Color mbtiColor = _getMbtiColor(mbti ?? 'default');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mbtiColor, // MBTI에 따라 색상 변경
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 MBTI ($mbti)',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mbtiDescription,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
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
            children: const [
              Text(
                '나의 통장 잔고',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '323,300,000 원',
                style: TextStyle(
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
            child: IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinanceDetailsScreen(),
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
}
*/
