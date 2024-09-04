import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cloudAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _cloudAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드에 의해 화면이 밀리지 않도록 설정
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 그라데이션과 패턴
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/pattern.png'), // 패턴 이미지
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // 애니메이션 구름
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return Positioned(
                top: -100,
                left: _cloudAnimation.value * MediaQuery.of(context).size.width - 300,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/cloud.png',
                    width: 1200,
                    height: 800,
                  ),
                ),
              );
            },
          ),
          // 상단 로고 영역
          Positioned(
            top: 70,
            left: 100,
            child: Image.asset(
              'assets/images/logo.png', // 로고 이미지
              width: 300, // 로고 너비
              height: 200, // 로고 높이
            ),
          ),
          // 로그인 폼
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 아이디 입력란
                  _buildTextField(
                    labelText: '',
                    hintText: '이메일 주소를 입력하세요',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.0),
                  // 비밀번호 입력란
                  _buildTextField(
                    labelText: '',
                    hintText: '비밀번호를 입력하세요',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: 30.0),
                  // 로그인 버튼
                  _buildElevatedButton(
                    context,
                    '로그인',
                        () => Navigator.pushNamed(context, '/main'),
                  ),
                  SizedBox(height: 16.0),
                  // 회원가입 버튼
                  _buildElevatedButton(
                    context,
                    '회원가입',
                        () => Navigator.pushNamed(context, '/register'),
                  ),
                  SizedBox(height: 16.0),
                  // ID/PW 찾기 링크
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/findPW');
                    },
                    child: Text(
                      'ID/PW 찾기',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.white, // 배경색
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // 테두리 제거
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      style: TextStyle(color: Colors.black), // 텍스트 색상
    );
  }

  Widget _buildElevatedButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800], // 버튼 배경색
        foregroundColor: Colors.white, // 버튼 텍스트 색
        minimumSize: Size(double.infinity, 50), // 버튼 크기
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 버튼 모서리 둥글게
        ),
        elevation: 8, // 버튼 그림자
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18, // 버튼 텍스트 크기
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
