import 'dart:convert';
import 'package:http/http.dart' as http;

class SolamaService {
  // 로컬 Sollama 서버 URL
  final String _apiUrl = 'http://10.0.2.2:11434/v1/chat/completions';

  Future<String> generateScenario(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8', // Ensure charset is UTF-8
        },
        body: json.encode({
          "model": "Sollama",
          "messages": [
            {
              "role": "user",
              "content": prompt,
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        // 응답에서 텍스트 추출 (응답 구조에 따라 수정이 필요할 수 있음)
        return responseBody['choices'][0]['message']['content'] ?? '시나리오 생성 실패';
      } else {
        print('API 요청 실패: ${response.statusCode}');
        print('응답 본문: ${utf8.decode(response.bodyBytes)}');
        throw Exception('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 오류: $e');
      throw Exception('API 호출 오류: $e');
    }
  }
}
