import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financialModels.dart';
import 'package:untitled1/config/constants.dart';


// 최근 한달 지출 상위 카테고리 5개
Future<List<CategorySpendingSummary>> fetchTop5Categories(int userNo) async {
  // API URL 생성
  final url = REST_API_URL + '/api/financial/top5-categories-amount?userNo=$userNo';

  try {
    // HTTP GET 요청
    final response = await http.get(Uri.parse(url));

    // 성공
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);

      // 객체변환
      List<CategorySpendingSummary> summaries = jsonData
          .map((item) => CategorySpendingSummary.fromJson(item))
          .toList();

      //////////////////////////확인용
      for(var summary in summaries){
        print('Category: ${summary.category}, Avg Amount: ${summary.totalAmount}');
      }
      //////////////////////////////////

      return summaries;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('오류 발생: $e');
    return [];
  }
}



// 최근 한달 지출 상위 5개 카테고리의 동일 연령대 평균 지출 금액
Future<Map<String, CategorySpendingAvgDTO>> fetchTop5CategoriesWithAvg(int userNo) async {
  // API URL 생성
  final url = REST_API_URL + '/api/financial/top5-categories-with-avg?userNo=$userNo';

  try {
    // HTTP GET 요청
    final response = await http.get(Uri.parse(url));

    // 응답 상태 코드가 200일 때
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonData = json.decode(utf8Body);

      Map<String, CategorySpendingAvgDTO> categoryData = {};
      jsonData.forEach((key, value) {
        categoryData[key] = CategorySpendingAvgDTO.fromJson(value);
      });

      ////////////// 확인용 ///////////
      // 데이터 출력
      categoryData.forEach((key, value) {
        print('Key: $key');
        print('Category: ${value.category}, Avg Amount: ${value.avgAmount}, Age Group: ${value.ageGroup}');
      });
      ///////////////////////////////

      return categoryData;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('오류 발생: $e');
    return {};
  }
}


// 최근 일주일간 카테고리별 소비 비율 측정을 위한 카테고리별 지출 금액
Future<List<CategorySpendingSummary>> fetchLast7DaysSpending(int userNo) async {
  final url = REST_API_URL + '/api/financial/last7-days-spending?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);

      List<CategorySpendingSummary> summaries = jsonData
          .map((item) => CategorySpendingSummary.fromJson(item))
          .toList();

      ////////////////////////////// 확인용
      for (var summary in summaries) {
        print('Category: ${summary.category}, Total Amount: ${summary.totalAmount}');
      }
      ////////////////////////////////////////////

      return summaries;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('오류 발생: $e');
    return [];
  }
}