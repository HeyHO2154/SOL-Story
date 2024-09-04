import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/../../../config/constants.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import
import 'package:untitled1/MainPage/MainPage.dart'; // MainPage를 임포트하세요.

class TransferOneWonPage extends StatefulWidget {
  @override
  _TransferOneWonPageState createState() => _TransferOneWonPageState();
}

class _TransferOneWonPageState extends State<TransferOneWonPage> {
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  Future<void> _transferOneWon() async {
    final String accountNo = _accountNoController.text;
    final String email = _userIdController.text;

    final Uri uri = Uri.parse(REST_API_URL + '/api/transfer/one_won').replace(
      queryParameters: {
        'accountNo': accountNo,
        'email': email,
      },
    );

    final response = await http.post(uri);
    print(response.body);
    if (response.statusCode == 200) {
      // 성공적으로 1원 송금
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('1원 송금이 완료되었습니다.'),
      ));
      Navigator.pushReplacementNamed(
        context,
        '/verify/one-won',
        arguments: {
          'accountNo': accountNo,
          'email': email,
        },
      );
    } else {
      // 실패
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('송금에 실패했습니다.'),
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
                  SizedBox(height: 50), // 상단과의 간격을 원하는 대로 조절
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '1원 송금하기',
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
                    '계좌 인증을 위해 1원을 송금합니다.',
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
                            controller: _accountNoController,
                            decoration: InputDecoration(
                              labelText: '계좌 번호',
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
                            controller: _userIdController,
                            decoration: InputDecoration(
                              labelText: '사용자 email',
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
                              // 버튼 가운데 정렬
                              child: Text(
                                '1원 송금하기',
                                style: TextStyle(
                                  fontFamily: 'AppleSDGothicNeo',
                                ),
                              ),
                            ),
                            onPressed: _transferOneWon,
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
