import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/config/constants.dart'; // SVG 파일을 사용하기 위한 import

// 전역 변수 정의
int STORY_COMPLEX = 1; // 시나리오 복잡도 초기값
bool STORY_ME = false; // 내 정보 시나리오 포함 여부 초기값
String SELECTED_LANGUAGE = '한국어'; // 언어 초기값

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

String _getURLByLanguage(String language) {
  switch (language) {
    case '한국어':
      return REST_API_URL_SOLAMA + '/ko';
    case 'English':
      return REST_API_URL_SOLAMA + '/en';
    case '中文':
      return REST_API_URL_SOLAMA + '/zh';
    case 'العربية':
      return REST_API_URL_SOLAMA + '/ar';
  }
  return REST_API_URL_SOLAMA + '/ko';
}

class _SettingPageState extends State<SettingPage> {
  bool _alarmEnabled = true;
  double _complexityLevel = 1.0; // 초기값을 1로 변경
  bool _includePersonalInfo = false;
  String _selectedLanguage = SELECTED_LANGUAGE;

  final List<Map<String, dynamic>> _languages = [
    {'name': '한국어', 'icon': 'assets/images/korea_flag.png'},
    {'name': 'English', 'icon': 'assets/images/uk_flag.png'},
    {'name': '中文', 'icon': 'assets/images/china_flag.png'},
    {'name': 'العربية', 'icon': 'assets/images/arabic_flag.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings(); // 페이지가 처음 로드될 때 설정을 불러옴
  }

  // 저장 메서드
  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alarmEnabled', _alarmEnabled);
    await prefs.setDouble('complexityLevel', _complexityLevel);
    await prefs.setBool('includePersonalInfo', _includePersonalInfo);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  // 불러오기 메서드
  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _alarmEnabled = prefs.getBool('alarmEnabled') ?? true;
      _complexityLevel = prefs.getDouble('complexityLevel') ?? 1.0;
      _includePersonalInfo = prefs.getBool('includePersonalInfo') ?? false;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? '한국어';
    });
  }

  @override
  Widget build(BuildContext context) {
    _getURLByLanguage(SELECTED_LANGUAGE);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SVG 배경 이미지 설정
          SvgPicture.asset(
            'assets/images/background.svg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // 기본 배경을 꽉 채우도록 설정
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50), // 상단에 추가할 여백
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      '사용자 설정',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'AppleSDGothicNeo',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 150),
                Text(
                  '일반',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 228, 228, 228),
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 10),
                _buildSwitchTile(
                  title: '신규 카드 알람',
                  value: _alarmEnabled,
                  onChanged: (value) {
                    setState(() {
                      _alarmEnabled = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildDropdownTile(
                  title: '언어 선택',
                  value: _selectedLanguage,
                  items: _languages,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                      SELECTED_LANGUAGE = _selectedLanguage; // 전역 변수에 저장
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  '시나리오',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 10),
                _buildSliderTile(
                  title: '시나리오 생성 복잡도',
                  value: _complexityLevel,
                  onChanged: (value) {
                    setState(() {
                      _complexityLevel = value;
                      STORY_COMPLEX = value.toInt(); // 전역 변수에 저장
                    });
                  },
                ),
                _buildSwitchTile(
                  title: '내 정보 시나리오에 담기',
                  value: _includePersonalInfo,
                  onChanged: (value) {
                    setState(() {
                      _includePersonalInfo = value;
                      STORY_ME = _includePersonalInfo; // 전역 변수에 저장
                    });
                  },
                ),
                SizedBox(height: 100), // 하단 여백
              ],
            ),
          ),
          // 하단 확인 버튼
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 255, 255, 255), // 버튼 배경색
                    foregroundColor:
                        const Color.fromARGB(255, 82, 82, 82), // 버튼 텍스트 색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22), // 버튼 모서리 둥글게
                    ),
                    elevation: 8, // 버튼 그림자
                    padding: EdgeInsets.symmetric(vertical: 16), // 버튼 패딩
                  ),
                  onPressed: () async {
                    await _saveSettings(); // 설정 저장 처리
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 18, // 버튼 텍스트 크기
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AppleSDGothicNeo',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(64, 104, 255, 1),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromRGBO(64, 104, 255, 1),
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(64, 104, 255, 1),
          ),
        ),
        subtitle: Slider(
          value: value,
          min: 1.0,
          max: 4.0, // 범위를 1~4로 변경
          divisions: 3, // 슬라이더를 정수로만 받도록 설정
          onChanged: onChanged,
          activeColor: const Color.fromRGBO(64, 104, 255, 1),
        ),
        trailing: Text(
          value.toStringAsFixed(0), // 소수점 없이 정수 형태로 표시
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(64, 104, 255, 1),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String value,
    required List<Map<String, dynamic>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(64, 104, 255, 1),
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['name'],
              child: Row(
                children: [
                  Image.asset(
                    item['icon'],
                    width: 24,
                    height: 16,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8),
                  Text(item['name']),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
