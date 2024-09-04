import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/config/constants.dart';

Future<bool> checkFirstRun(int userNo) async {
  final url = REST_API_URL + '/api/exist/userInfo?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) { //ok
      bool check = json.decode(response.body);
      print("does exist?");
      print(check);
      if(check){
        print("mbti있다.");
        return false; // 있으니까  
      }else {
        print("mbti없다.");
        return true; // 없으니까
      }
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return true; // 기본값 반환
    }
  } catch (e) {
    print('오류 발생: $e');
    return true;
  }
}