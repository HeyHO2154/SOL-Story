import 'package:flutter/material.dart';

const REST_API_URL = 'http://10.0.2.2:8090';
const REST_API_URL_SOLAMA = 'http://10.0.2.2:11434';
//지히 - 테스트용
const String email = "240827_02@ssafy.com";

// 임시 로그인한 유저 정보 > shared > 번호 이름 이메일 isFirstRun
class NowUser {
  final int userNo;
  final String userName;

  NowUser({required this.userNo, required this.userName});
}
