import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financialModels.dart';
import 'package:untitled1/config/constants.dart';


// 최근 7일간 가장 지출이 많았던 카테고리 소비 요약 정보 객체
Future<List<StoreSpendingSummary>> fetchHighestSpendingDetails(int userNo) async {
  final url = REST_API_URL + '/api/financial/highest-spending-details?userNo=$userNo';

  try {
    // HTTP GET 요청
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);
      List<StoreSpendingSummary> summaries = jsonData
          .map((item) => StoreSpendingSummary.fromJson(item))
          .toList();

      //////////////////////////////////////////confirm
      for (var summary in summaries) {
        print('Store Name: ${summary.storeName}, Visit Count: ${summary.visitCount}, Total Amount: ${summary.totalAmount}');
      }
      //////////////////////////////////////
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