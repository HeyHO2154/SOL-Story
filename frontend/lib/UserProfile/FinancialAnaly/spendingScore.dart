import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financialModels.dart';
import 'package:untitled1/config/constants.dart';


// 사용자 금융 상태 분석 점수
Future<int> fetchFinancialScore(int userNo) async {
  final url = REST_API_URL + '/api/financial/financial-score?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ////////////////////컨펌////////////////////////
      print(response.body);
      ////////////////////컨펌////////////////////////
      return int.parse(response.body);
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return 0; // 기본값 반환
    }
  } catch (e) {
    print('오류 발생: $e');
    return 0; // 오류 발생 시 기본값 반환
  }
}