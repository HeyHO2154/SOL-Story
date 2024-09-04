import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/../../../config/constants.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

class VerifyOneWonPage extends StatefulWidget {
  @override
  _VerifyOneWonPageState createState() => _VerifyOneWonPageState();
}

class _VerifyOneWonPageState extends State<VerifyOneWonPage> {
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    _accountNoController.text = args?['accountNo'] ?? '0019605725437997';
    _emailController.text = args?['email'] ?? 'user@shinhan.ssafy.com';
  }

  Future<void> _verifyOneWon() async {
    final String accountNo = _accountNoController.text;
    final String authCode = _authCodeController.text;
    final String email = _emailController.text;

    final Uri uri = Uri.parse(REST_API_URL + '/api/verify/one_won').replace(
      queryParameters: {
        'accountNo': accountNo,
        'authCode': authCode,
        'email': email,
      },
    );
    final response = await http.post(uri);
    if (response.statusCode == 200) {
      // 성공적으로 인증
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('1원 인증이 완료되었습니다.'),
      ));
      Navigator.pushReplacementNamed(
        context,
        '/challenges',
        arguments: {
          'accountNo': accountNo,
          'email': email,
        },
      );
    } else {
      // 실패
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('인증에 실패했습니다.'),
      ));
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
                    alignment: Alignment.topLeft,
                    child: Container(
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // 상단과의 간격을 원하는 대로 조절
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '1원 인증하기',
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
                    '계좌 인증을 위해 발송된 인증 코드를 입력하세요.',
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
                            controller: _authCodeController,
                            decoration: InputDecoration(
                              labelText: '인증 코드',
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
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(64, 104, 255, 1),
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
                            child: Center(
                              child: Text(
                                '인증하기',
                                style: TextStyle(
                                  fontFamily: 'AppleSDGothicNeo',
                                ),
                              ),
                            ),
                            onPressed: _verifyOneWon,
                          ),
                        ),
                      ],
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
