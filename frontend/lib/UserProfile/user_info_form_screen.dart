import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 변환을 위해 추가
import 'package:http/http.dart' as http; // HTTP 요청을 위해 추가
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/MainPage/MainPage.dart';
import 'package:untitled1/config/constants.dart';
import 'package:untitled1/UserProfile/UserProfile.dart';

class UserInfoFormScreen extends StatefulWidget {
  final int userNo;

  UserInfoFormScreen({required this.userNo});

  @override
  State<UserInfoFormScreen> createState() => _UserInfoFormScreenState();
}

class _UserInfoFormScreenState extends State<UserInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> hobbies = [
    '등산',
    '낚시',
    '요리',
    '독서',
    '캠핑',
    '자전거 타기',
    '사진 촬영',
    '게임',
    '영화 감상',
    '헬스/피트니스',
    '악기 연주',
    '수영',
    '다이어리 꾸미기',
    '여행',
    '홈카페/커피 만들기',
    '가드닝',
    '보드게임',
    '공예',
    '러닝',
    '드라마/예능 시청',
  ];

  final List<String> interests = [
    '패션',
    '음악',
    'IT 기술',
    '건강 관리',
    '경제/재테크',
    '스포츠',
    '환경 보호',
    '사회 이슈',
    '교육/학습',
    '외국어 배우기',
    '음식 탐방',
    '뷰티',
    '여행지 탐방',
    '자동차',
    '영화/드라마',
    '인테리어 디자인',
    'SNS 트렌드',
    '자원봉사',
    '가족/육아',
    '창업',
  ];

  final List<String> mbtiTypes = [
    'INTJ',
    'INTP',
    'ENTJ',
    'ENTP',
    'INFJ',
    'INFP',
    'ENFJ',
    'ENFP',
    'ISTJ',
    'ISFJ',
    'ESTJ',
    'ESFJ',
    'ISTP',
    'ISFP',
    'ESTP',
    'ESFP',
  ];

  List<String> selectedHobbies = [];
  List<String> selectedInterests = [];
  String selectedMbti = ''; // 선택한 MBTI를 저장

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedMbti.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MBTI를 선택해 주세요')),
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('mbti', selectedMbti);
      await prefs.setStringList('hobbies', selectedHobbies);
      await prefs.setStringList('interests', selectedInterests);
      await prefs.setBool('first_run', false);

      // 사용자의 정보를 서버로 전송하는 함수 호출
      await _sendUserInfoToServer(); // 'await'를 사용하여 비동기 함수 호출

      // 로컬에 isFirstRun 값을 true로 저장
      await prefs.setBool('first_run', false);
      print(prefs.getBool('first_run'));

      // MainPage로 전환
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfile(userNo: widget.userNo)),
        );
      }
    }
  }

  Future<void> _sendUserInfoToServer() async {
    print("send user info :  ${widget.userNo}");
    final url = Uri.parse(
        REST_API_URL + '/api/userInfo/saveInfo'); // 여기에 스프링 부트 서버의 URL을 입력
    final headers = {"Content-Type": "application/json"};

    // 서버로 보낼 데이터 준비
    Map<String, dynamic> userInfo = {
      'userNo': widget.userNo,
      'mbti': selectedMbti,
      'hobbies': selectedHobbies,
      'interests': selectedInterests,
    };

    // POST 요청 보내기
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(userInfo),
      );

      if (response.statusCode == 200) {
        print('사용자 정보 전송 성공');
      } else {
        print('사용자 정보 전송 실패: ${response.statusCode}');
      }
    } catch (error) {
      print('서버 전송 중 오류 발생: $error');
    }
  }

  void _toggleSelection(List<String> list, String item, int maxSelection) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else if (list.length < maxSelection) {
        list.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainPage(userNo: widget.userNo)),
                            );
                          },
                        ),
                        Text(
                          '사용자 정보 등록',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'AppleSDGothicNeo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('나의 MBTI 선택',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppleSDGothicNeo',
                            color: Colors.white)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: mbtiTypes.map((mbti) {
                        final isSelected = selectedMbti == mbti;
                        return ChoiceChip(
                          label: Text(mbti,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedMbti = mbti;
                            });
                          },
                          selectedColor: const Color.fromRGBO(64, 104, 255, 1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('나의 취미 5가지',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppleSDGothicNeo',
                            color: Colors.white)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: hobbies.map((hobby) {
                        final isSelected = selectedHobbies.contains(hobby);
                        return ChoiceChip(
                          label: Text(hobby,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black)),
                          selected: isSelected,
                          onSelected: (selected) {
                            _toggleSelection(selectedHobbies, hobby, 5);
                          },
                          selectedColor: const Color.fromRGBO(64, 104, 255, 1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('나의 관심사 5가지',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppleSDGothicNeo',
                            color: Colors.white)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: interests.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return ChoiceChip(
                          label: Text(interest,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black)),
                          selected: isSelected,
                          onSelected: (selected) {
                            _toggleSelection(selectedInterests, interest, 5);
                          },
                          selectedColor: const Color.fromRGBO(64, 104, 255, 1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('입력 완료!',
                            style: TextStyle(fontFamily: 'AppleSDGothicNeo')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
