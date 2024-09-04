import 'dart:convert'; // for jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/UserProfile/FinancialAnaly/FinancialAnaly.dart';
import 'package:untitled1/config/constants.dart';
import 'package:untitled1/MainPage/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/UserProfile/user_info_form_screen.dart';
import 'package:untitled1/GoalList/GoalList.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

// 로그인 페이지
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cloudAnimation;

  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _useridFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _cloudAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _useridController.dispose();
    _passwordController.dispose();
    _useridFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // 로그인 처리 메서드
  Future<void> _handleLogin() async {
    final String userid = _useridController.text;
    final String password = _passwordController.text;

    if (userid.isEmpty) {
      _showErrorDialog('아이디를 입력하세요.');
      FocusScope.of(context).requestFocus(_useridFocusNode);
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog('비밀번호를 입력하세요.');
      FocusScope.of(context).requestFocus(_passwordFocusNode);
      return;
    }

    try {
      final uri = Uri.parse(REST_API_URL + '/api/login'); // API URL

      // HTTP POST 요청
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userid,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('로그인 성공');

        final userNo = responseBody['userNo'] as int;
        final userName = responseBody['userName'] as String;
        final email = responseBody['email'] as String;

        print(userName);
        print(userNo);
        print(email);

        // 사용자 데이터를 로컬 저장소에 저장
        _saveUserData(userNo, userName, email);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(userNo: userNo), // MainPage로 데이터 전달
          ),
        );
      } else if (response.statusCode == 401) {
        print('로그인 실패');
        _showErrorDialog('아이디 또는 비밀번호가 잘못되었습니다.');
      } else {
        _showErrorDialog('서버 오류가 발생했습니다.');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('로그인에 실패했습니다. 다시 시도하세요.');
      print(e.toString());
    }
  }

  // 사용자 데이터를 로컬에 저장하는 함수
  void _saveUserData(int userNo, String userName, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userNo', userNo);
    await prefs.setString('userName', userName);
    await prefs.setString('email', email);
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(''),
        content: Container(
          height: 200,
          alignment: Alignment.center,
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // 이 옵션을 true로 설정하면 키보드가 올라올 때 레이아웃이 자동으로 조정됩니다.
      body: SingleChildScrollView(
        // 스크롤 가능하도록 설정
        child: Container(
          height: MediaQuery.of(context).size.height, // 화면 높이를 기반으로 조정
          child: Stack(
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
              // 상단 중앙에 로고 배치
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 200.0, // 로고의 너비 설정
                    height: 200.0, // 로고의 높이 설정
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end, // 아래쪽 정렬
                    children: [
                      // 입력 필드와 로그인 버튼이 포함된 박스
                      Container(
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(50.0), // 박스 둥글게 설정
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 8),
                              blurRadius: 16.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextField(
                              labelText: '',
                              hintText: '아이디를 입력하세요',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              controller: _useridController,
                              focusNode: _useridFocusNode,
                            ),
                            SizedBox(height: 20.0),
                            _buildTextField(
                              labelText: '',
                              hintText: '비밀번호를 입력하세요',
                              icon: Icons.lock,
                              obscureText: _obscurePassword,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              isPasswordField: true,
                            ),
                            SizedBox(height: 30.0),
                            // 로그인 버튼
                            _buildElevatedButton(
                              context,
                              '로그인',
                              _handleLogin,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0), // 박스와 ID/PW 찾기 간격
                      // ID/PW 찾기
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/findPW');
                        },
                        child: Text(
                          'ID/PW 찾기',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0), // ID/PW 찾기와 회원가입 버튼 간격
                      // 회원가입 버튼
                      _buildElevatedButton(
                        context,
                        '회원가입',
                        () => Navigator.pushNamed(context, '/register'),
                      ),
                      SizedBox(height: 50.0), // 전체적인 하단 여백
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscureText = false,
    bool isPasswordField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255), // 입력 칸 배경색
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.blue[800]),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromRGBO(64, 104, 255, 1)!),
            borderRadius: BorderRadius.circular(50.0),
          ),
          suffixIcon: isPasswordField
              ? GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _obscurePassword = false;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _obscurePassword = true;
                    });
                  },
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildElevatedButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(64, 104, 255, 1), // 버튼 색상
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 8,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
