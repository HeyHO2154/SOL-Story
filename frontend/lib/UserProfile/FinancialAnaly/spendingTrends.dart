import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financialModels.dart';

// 최근 30일의 이전 30일 대비 지출 증감 (지출 상위 10개 카테고리)
Future<List<FinancialTrendDTO>> fetchSpendingTrends(int userNo) async {
  final url = 'http://10.0.2.2:8090/api/financial/spending-trends?userNo=$userNo';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);

      List<FinancialTrendDTO> trends = jsonData
          .map((item) => FinancialTrendDTO.fromJson(item))
          .toList();


      ///////////////확인용/////////////////////////
      for (var trend in trends) {
        print('Category: ${trend.category}, Total Amount: ${trend.totalAmount}, Total Amount Before: ${trend.totalAmountBefore}, Difference: ${trend.difference}, Percent Change: ${trend.percentChange}');
      }
      ////////////////////////////////////////////

      return trends;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('오류 발생: $e');
    return [];
  }
}