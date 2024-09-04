import 'dart:async'; // for async
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

// 계정찾기 페이지
class FindPW extends StatefulWidget {
  @override
  _FindPWState createState() => _FindPWState();
}

class _FindPWState extends State<FindPW> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cloudAnimation;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

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
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 이 옵션을 true로 설정하면 키보드가 올라올 때 레이아웃이 자동으로 조정됩니다.
      body: SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 이메일 입력란
                      _buildTextField(
                        labelText: '',
                        hintText: '이메일을 입력하세요',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                      ),
                      SizedBox(height: 30.0),
                      // 비밀번호 변경 버튼
                      _buildElevatedButton(
                        context,
                        '비밀번호 변경',
                            () {
                          Navigator.pushNamed(context, '/login'); //일단 Login으로 가게
                        },
                      ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildElevatedButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
