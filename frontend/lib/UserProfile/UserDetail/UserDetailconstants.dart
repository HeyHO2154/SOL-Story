import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 2번 코드에서 가져온 MBTI 설명을 반환하는 함수
String getMbtiDescription(String mbti) {
  Map<String, String> mbtiDescriptions = {
    // 탐험가 유형(ESFP, ESTP, ISFP, ISTP)
    'ESTP': '향락가: 가능한 많은 재미를 추구합니다. 큰 위험을 무릅쓰고 돈을 씁니다.',
    'ESFP': '감정적인 소비자: 물건을 구매할 때 감정에 이끌립니다.',
    'ISFP': '갬블러: 값비싼 옷과 명품으로 자신을 표현합니다.',
    'ISTP': '사치품 구매자: 사치품에 약하고 경솔한 지출 성향이 있습니다.',
    // 감시인 유형(ESFJ, ESTJ, ISFJ, ISTJ)
    'ESFJ': '지위 과시자: 부를 과시하고 싶다는 감정에 돈을 낭비합니다.',
    'ESTJ': '검소한 절약가: 지나치게 아끼는 듯한 인상을 줄 수 있습니다.',
    'ISFJ': '세심한 소비자: 소박한 지출에 쉽게 만족합니다.',
    'ISTJ': '최고의 건축가: 낭비하지 않지만 대외적인 이미지에 지출합니다.',
    // 분석가 유형(ENTJ, ENTP, INTJ, INTP)
    'ENTJ': '위험 감수자: 돈을 잘 벌지만 저축에 관심이 없습니다.',
    'ENTP': '신중한 살림꾼: 자신의 소득 내에서 신중하게 지출합니다.',
    'INTJ': '스트레스 쇼퍼: 검소하지만 스트레스를 받을 때 충동적으로 소비합니다.',
    'INTP': '경험 탐구자: 검소하지만 새로운 경험에 큰 돈을 씁니다.',
    // 외교관 유형(ENFJ, ENFP, INFP, INFJ)
    'ENFJ': '미니멀리스트: 돈이 꼭 필요하지 않은 유형입니다.',
    'ENFP': '낭비벽: 소비 생활에 끝이 없습니다.',
    'INFJ': '소셜 지출가: 친구들에 따라 사치스러운 생활로 유혹받습니다.',
    'INFP': '강박적인 구매자: 자신이 버는 만큼 소비하는 유형입니다.',
  };

  // MBTI에 따른 설명을 반환하거나, 알 수 없는 경우 기본 메시지 반환
  return mbtiDescriptions[mbti] ?? '알 수 없는 MBTI 유형입니다.';
}

// 2번 코드에서 가져온 MBTI에 따라 색상을 반환하는 함수
Color getMbtiColor(String mbti) {
  Map<String, Color> mbtiColors = {
    // 파스텔 톤의 배경색 지정
    'ESTP': Colors.pink.withOpacity(0.7),
    'ESFP': Colors.orangeAccent.withOpacity(0.7),
    'ISFP': Colors.yellow.withOpacity(0.7),
    'ISTP': Colors.lightGreenAccent.withOpacity(0.7),
    'ESFJ': Colors.cyanAccent.withOpacity(0.7),
    'ESTJ': Colors.teal.withOpacity(0.7),
    'ISFJ': Colors.lightBlueAccent.withOpacity(0.7),
    'ISTJ': Colors.indigoAccent.withOpacity(0.7),
    'ENTJ': Colors.purpleAccent.withOpacity(0.7),
    'ENTP': Colors.redAccent.withOpacity(0.7),
    'INTJ': Colors.amber.withOpacity(0.7),
    'INTP': Colors.greenAccent.withOpacity(0.7),
    'ENFJ': Colors.blueAccent.withOpacity(0.7),
    'ENFP': Colors.pinkAccent.withOpacity(0.7),
    'INFJ': Colors.deepPurpleAccent.withOpacity(0.7),
    'INFP': Colors.purple.withOpacity(0.7),
  };

  // MBTI에 따른 색상을 반환하거나, 알 수 없는 경우 기본 색상 반환
  return mbtiColors[mbti] ?? Colors.grey.withOpacity(0.7);
}
