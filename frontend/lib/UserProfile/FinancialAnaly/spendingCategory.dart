import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financialModels.dart';
import 'package:untitled1/config/constants.dart';



// 최근 한달, 전월 대비 소비 증가율이 가장 높은 카테고리
Future<String> fetchCategoryWithHighestSpendingGrowth(int userNo) async {
  final url = REST_API_URL + '/api/financial/highest-spending-growth-category?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ////////////////////컨펌////////////////////////
      ////////////////////컨펌////////////////////////
      final utf8Body = utf8.decode(response.bodyBytes);
      return json.decode(utf8Body) as String;

    } else {
      print('API 호출 실패: ${response.statusCode}');
      return ''; // 빈 문자열 반환
    }
  } catch (e) {
    print('오류 발생: $e');
    return ''; // 오류 발생 시 빈 문자열 반환
  }
}


// 최근 한달 지출 상위 3개 카테고리
Future<List<String>> fetchTop3Categories(int userNo) async {
  final url = REST_API_URL + '/api/financial/top3-categories?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);
      List<String> categories = List<String>.from(jsonData);

      ////////////////////컨펌////////////////////////
      for(var category in categories){
        print(category);
      }
      ////////////////////


      return categories;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return []; // 빈 리스트 반환
    }
  } catch (e) {
    print('오류 발생: $e');
    return []; // 오류 발생 시 빈 리스트 반환
  }
}