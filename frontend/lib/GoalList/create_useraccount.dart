import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/user_account_model.dart';
import 'package:untitled1/config/constants.dart';
import 'package:untitled1/MainPage/MainPage.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

class CreateUserAccountPage extends StatefulWidget {
  final int userNo;

  CreateUserAccountPage({required this.userNo});

  @override
  _CreateUserAccountPageState createState() => _CreateUserAccountPageState();
}

class _CreateUserAccountPageState extends State<CreateUserAccountPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _responseMessage;

  Future<void> _createUserAccount() async {
    final String userId = _userIdController.text;
    final String email = _emailController.text;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    final Uri uri = Uri.parse(REST_API_URL + '/api/user/account').replace(
      queryParameters: {
        'userId': userId,
        'email': email,
      },
    );

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userAccount = UserAccount.fromJson(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        setState(() {
          _responseMessage = '계정이 성공적으로 생성되었습니다: ${userAccount.username}';
        });

        // 계정 생성 성공 후, 1원 송금 페이지로 이동
        Navigator.pushReplacementNamed(context, '/transfer/one-won');
      } else {
        setState(() {
          _responseMessage = '계정 생성에 실패했습니다: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = '서버와의 연결에 실패했습니다: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(64, 104, 255, 1),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainPage(userNo: widget.userNo),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 50), // 상단과의 간격을 원하는 대로 조절
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '사용자 계정 생성하기',
                      style: TextStyle(
                        fontFamily: 'RixYeoljeongdo', // RixYeoljeongdo 폰트 적용
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // 제목과 다른 요소들 사이의 간격
                  Text(
                    '챌린지를 진행하기 위해서\n사용자 계정 생성이 필요합니다.',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'AppleSDGothicNeo',
                    ),
                  ),
                  SizedBox(height: 150), // 문구와 입력 필드 사이의 간격
                  Container(
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _userIdController,
                            decoration: InputDecoration(
                              labelText: '사용자 ID',
                              labelStyle: TextStyle(
                                fontFamily: 'AppleSDGothicNeo',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: '이메일',
                              labelStyle: TextStyle(
                                fontFamily: 'AppleSDGothicNeo',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(40.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent, // 버튼 자체의 그림자 제거
                            ),
                            child: Text(
                              '계정 생성하기',
                              style: TextStyle(
                                fontFamily: 'AppleSDGothicNeo',
                              ),
                            ),
                            onPressed: _createUserAccount,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_responseMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _responseMessage!,
                        style: TextStyle(color: Colors.red),
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
}
