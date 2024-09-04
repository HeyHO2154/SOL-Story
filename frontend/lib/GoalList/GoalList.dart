import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Scenario/models/key_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/GoalList/create_useraccount.dart';
import 'package:untitled1/GoalList/user_challenge_list.dart';
import 'package:untitled1/config/constants.dart';

class GoalListPage extends StatelessWidget {
  final int userNo;

  GoalListPage({required this.userNo});

  Future<String?> _checkUserKey(int userNo) async {
    final prefs = await SharedPreferences.getInstance();
    final email = "solstory@ssafy.com";//prefs.getString('userEmail') ?? 'user@shinhan.ssafy.com'; // 이메일을 가져오거나 기본값 설정

    if (email.isEmpty) {
      return null;
    }

    // window 주소 uri
    final Uri uri = Uri.parse(REST_API_URL + '/api/userkey').replace(
      queryParameters: {
        'email': email,
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body; // userkey 반환
      }
    } catch (e) {
      print('서버와의 연결에 실패했습니다: $e');
    }
    return null; // userkey가 없거나 오류가 발생한 경우 null 반환
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkUserKey(userNo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // userkey가 존재하는 경우 ChallengeListPage로 이동
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeListPage(userNo: userNo),
                ////////////////////////////////////////////////////////
                //MainPage(userNo: userNo), // MainPage로 데이터 전달
              ),
            );
          });
          return SizedBox.shrink(); // 빈 화면 반환
        } else {
          // userkey가 없는 경우 CreateUserAccountPage로 이동
          return CreateUserAccountPage(userNo: userNo);
        }
      },
    );
  }
}
