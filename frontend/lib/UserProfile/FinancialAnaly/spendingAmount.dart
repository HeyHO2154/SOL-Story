import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/config/constants.dart';

// 최근 한달 지출 총액
Future<int> fetchTotalSpendingForMonth(int userNo) async {
  final url = REST_API_URL + '/api/financial/total-spending?userNo=$userNo';

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


// 저축 계좌 잔액
Future<int> fetchTotalSavingsAmount(int userNo) async {
  final url = REST_API_URL + '/api/financial/total-savings-amount?userNo=$userNo';

  try {
    // HTTP GET 요청
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