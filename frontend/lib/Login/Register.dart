import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Login/Login.dart';
import 'package:untitled1/config/constants.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cloudAnimation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _useridFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _birthDateFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _isUseridAvailable = false;
  bool _isEmailAvailable = false;
  String _selectedGender = "남자";
  String _passwordWarning = '';
  String _passwordSpecialCharWarning = '';
  String _passwordUppercaseWarning = '';
  String _passwordInvalidCharWarning = '';
  String _useridMessage = '';
  String _emailMessage = '';
  String _birthDateWarning = '';

  @override
  void dispose() {
    _nameController.dispose();
    _useridController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _nameFocusNode.dispose();
    _useridFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _birthDateFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkUserid() async {
    final String userid = _useridController.text;

    if (userid.isEmpty) {
      setState(() {
        _useridMessage = '아이디를 입력하세요.';
        _isUseridAvailable = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(REST_API_URL + '/api/check-userid?userid=$userid'),
    );

    if (response.statusCode == 200) {
      final isExist = response.body == 'true';
      setState(() {
        if (isExist) {
          _useridMessage = '아이디가 중복되었습니다.';
          _isUseridAvailable = false;
        } else {
          _useridMessage = '사용가능한 아이디입니다.';
          _isUseridAvailable = true;
        }
      });
    } else {
      setState(() {
        _useridMessage = '서버 오류가 발생했습니다.';
        _isUseridAvailable = false;
      });
    }
  }

  Future<void> _checkEmail() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _emailMessage = '이메일을 입력하세요.';
        _isEmailAvailable = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(REST_API_URL + '/api/check-email?email=$email'),
    );

    if (response.statusCode == 200) {
      final isExist = response.body == 'true';
      setState(() {
        if (isExist) {
          _emailMessage = '이메일이 존재합니다. 다른 이메일을 입력해주세요.';
          _isEmailAvailable = false;
        } else {
          _emailMessage = '사용 가능한 이메일입니다.';
          _isEmailAvailable = true;
        }
      });
    } else {
      setState(() {
        _emailMessage = '서버 오류가 발생했습니다.';
        _isEmailAvailable = false;
      });
    }
  }

  void _handleSignUp() async {
    final String name = _nameController.text;
    final String userid = _useridController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String birthDate = _birthDateController.text;
    final String gender = _selectedGender;

    final bool isPasswordValid = _passwordWarning.isEmpty &&
        _passwordSpecialCharWarning.isEmpty &&
        _passwordUppercaseWarning.isEmpty &&
        _passwordInvalidCharWarning.isEmpty;

    if (name.isEmpty) {
      _showErrorDialog('이름을 입력하세요.');
      FocusScope.of(context).requestFocus(_nameFocusNode);
      return;
    }

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

    if (email.isEmpty) {
      _showErrorDialog('이메일을 입력하세요.');
      FocusScope.of(context).requestFocus(_emailFocusNode);
      return;
    }

    if (birthDate.isEmpty) {
      _showErrorDialog('생년월일을 입력하세요.');
      FocusScope.of(context).requestFocus(_birthDateFocusNode);
      return;
    }

    if (_birthDateWarning.isNotEmpty) {
      _showErrorDialog('생년월일이 형식에 맞지 않습니다.');
      FocusScope.of(context).requestFocus(_birthDateFocusNode);
      return;
    }

    if (!_isUseridAvailable) {
      _showErrorDialog('아이디 중복확인을 완료해주세요.');
      return;
    }

    if (!_isEmailAvailable) {
      _showErrorDialog('이메일 중복확인을 완료해주세요.');
      return;
    }

    if (!isPasswordValid) {
      _showErrorDialog('비밀번호가 조건에 맞지 않습니다.');
      return;
    }

    // 회원가입 처리 및 user_no 조회
    try {
      final response = await http.post(
        Uri.parse(REST_API_URL + '/api/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'userid': userid,
          'password': password,
          'email': email,
          'birthDate': birthDate,
          'gender': gender
        }),
      );

      if (response.statusCode == 200) {
        final int userNo = jsonDecode(response.body)['user_no'];
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        _showErrorDialog('회원가입에 실패했습니다.');
      }
    } catch (error) {
      _showErrorDialog('오류가 발생했습니다: $error');
    }
  }

  void _showErrorDialog(String message) {
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

    _passwordController.addListener(() {
      final String password = _passwordController.text;

      setState(() {
        _passwordWarning = password.length < 8 ? '8자리 이상이어야 합니다.' : '';

        _passwordSpecialCharWarning = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)
            ? ''
            : '특수문자는 최소 1개 이상 포함되어야 합니다.';

        _passwordUppercaseWarning = RegExp(r'[A-Z]').hasMatch(password)
            ? ''
            : '대문자는 최소 1개 이상 포함되어야 합니다.';

        _passwordInvalidCharWarning = RegExp(r'^[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]+$').hasMatch(password)
            ? ''
            : '영어, 특수문자, 숫자만 입력할 수 있습니다.';
      });
    });

    _birthDateController.addListener(() {
      final String birthDate = _birthDateController.text;

      setState(() {
        _birthDateWarning =
        RegExp(r'^\d{4}\d{2}\d{2}$').hasMatch(birthDate) ? '' : '형식에 맞지 않습니다.';
      });
    });

    _useridController.addListener(() {
      setState(() {
        _useridMessage = '';
        _isUseridAvailable = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SVG 배경 이미지 설정
          SvgPicture.asset(
            'assets/images/background.svg',
            width: double.infinity,
            height: double.infinity,
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
              fit: BoxFit.contain,
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
                width: 200.0,
                height: 200.0,
              ),
            ),
          ),
          Positioned(
            top: 350, // 로고 아래에 배치되도록 조정
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildTextField(
                            labelText: '',
                            hintText: '이름을 입력하세요',
                            icon: Icons.person,
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          flex: 4,
                          child: _buildGenderButtons(), // 성별 선택 부분
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    _buildTextField(
                      labelText: '',
                      hintText: '생년월일을 입력하세요',
                      icon: Icons.calendar_today,
                      controller: _birthDateController,
                      focusNode: _birthDateFocusNode,
                      keyboardType: TextInputType.number,
                    ),
                    if (_birthDateWarning.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _birthDateWarning,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    _buildTextField(
                      labelText: '',
                      hintText: '아이디를 입력하세요',
                      icon: Icons.account_circle,
                      controller: _useridController,
                      focusNode: _useridFocusNode,
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _useridMessage,
                        style: TextStyle(
                          color: _isUseridAvailable ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _buildElevatedButton(
                      context,
                      '아이디 중복확인',
                      _checkUserid,
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
                    if (_passwordWarning.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordWarning,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (_passwordSpecialCharWarning.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordSpecialCharWarning,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (_passwordUppercaseWarning.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordUppercaseWarning,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (_passwordInvalidCharWarning.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordInvalidCharWarning,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    _buildTextField(
                      labelText: '',
                      hintText: '이메일을 입력하세요',
                      icon: Icons.email,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailMessage,
                        style: TextStyle(
                          color: _isEmailAvailable ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _buildElevatedButton(
                      context,
                      '이메일 중복확인',
                      _checkEmail,
                    ),
                    SizedBox(height: 30.0),
                    _buildElevatedButton(
                      context,
                      '회원가입',
                      _handleSignUp,
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
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
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

  Widget _buildGenderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderButton("남자"),
        SizedBox(width: 5),
        _buildGenderButton("여자"),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedGender == gender ? Colors.blue[800] : Colors.grey[300],
          foregroundColor: _selectedGender == gender ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Text(gender),
      ),
    );
  }
}
