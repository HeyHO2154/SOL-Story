import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/UserProfile/UserDetail/UserInfoModels.dart';
import 'package:untitled1/config/constants.dart';

Future<Map<String, dynamic>> loadUserProfile(int userNo) async {
  Map<String, String> userInfo;
  List<Hobby> hobbies;
  List<Hobby> interests;

  try {
    // 이름, 생년월일, 성별 가져오기
    final userInfoUrl =  REST_API_URL + '/api/userInfo/detail?userNo=$userNo';

    try {
      final userInfoResponse = await http.get(Uri.parse(userInfoUrl));

      // 실패
      if (userInfoResponse.statusCode != 200) {
        print('API 호출 실패: ${userInfoResponse.statusCode}');
        return {};
      }

      // 성공
      final utf8Body = utf8.decode(userInfoResponse.bodyBytes);
      Map<String, dynamic> userInfoJson = json.decode(utf8Body);

      // 객체 변환
      userInfo = {};
      userInfoJson.forEach((key, value){
        userInfo[key] = UserInfoDTO.fromJson(value) as String;
      });
      print(userInfo);

    }catch(e){
      print('사용자 정보 불러오기 오류 발생: $e');
      return {};
    }

    // 취미 가져오기
    final hobbyUrl =  REST_API_URL + '/api/userInfo/hobbies?userNo=$userNo';

    try{
      final hobbiesResponse = await http.get(Uri.parse(hobbyUrl));

      // 실패
      if (hobbiesResponse.statusCode != 200) {
        print('API 호출 실패: ${hobbiesResponse.statusCode}');
        return {};
      }

      // 성공
      final utf8Body = utf8.decode(hobbiesResponse.bodyBytes);
      List<dynamic> hobbiesJson = json.decode(utf8Body);

      // 객체 변환
      hobbies = hobbiesJson
        .map((item) => Hobby.fromJson(item))
        .toList();
      print(hobbies);

    }catch(e){
      print('취미 가져오기 오류 발생: $e');
      return {};
    }

    // 관심사 가져오기
    final interestUrl =  REST_API_URL + '/api/userInfo/interests?userNo=$userNo';

    try{
      final interestsResponse = await http.get(Uri.parse(interestUrl));

      // 실패
      if (interestsResponse.statusCode != 200) {
        print('API 호출 실패: ${interestsResponse.statusCode}');
        return {};
      }

      // 성공
      final utf8Body = utf8.decode(interestsResponse.bodyBytes);
      final interestsJson = json.decode(utf8Body);

      // 객체 변환
      interests = interestsJson
          .map((item) => Hobby.fromJson(item))
          .toList();
      print(interests);

    }catch(e){
      print('관심사 가져오기 오류 발생: $e');
      return {};
    }

    // 계좌 잔액 가져오기
    final balanceResponse = await http.get(
        Uri.parse(REST_API_URL+'/api/financial/total-savings-amount?userNo=$userNo')
    );

    if (balanceResponse.statusCode != 200) {
      throw Exception('Failed to load balance');
    }
    final balance = balanceResponse.body;

    print(balance);

    return {
      'name': userInfo['userName'] ?? 'Unknown',
      'birth': userInfo['birth'] ?? 'Unknown',
      'gender': userInfo['gender'] ?? 'Unknown',
      'mbti': userInfo['mbti'] ?? 'Unknown',
      'hobbies': hobbies,
      'interests': interests,
      'balance': balance,
    };
  } catch (e) {
    print('사용자 프로필 불러오기 실패 $e');
    return {
      'name': 'Unknown',
      'age': 'Unknown',
      'gender': 'Unknown',
      'mbti': 'Unknown',
      'hobbies': [],
      'interests': [],
      'balance': '0',
    };
  }
}