import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/config/constants.dart';

class SolamaService {
  // 로컬 Sollama 서버 URL
  final String _ollamaApiUrl = REST_API_URL_SOLAMA + '/v1/chat/completions';

  // ChatGPT-4 API URL 및 키
  final String _chatGptApiUrl = '보안조치';
  final String _chatGptApiKey = '보안조치';

  Future<String> generateScenario(String prompt) async {
    try {
      final response = await _callOllamaApi(prompt);
      return _parseResponse(response);
    } catch (e) {
      print('Ollama API 호출 오류: $e');
      print('ChatGPT-4 API로 전환합니다.');

      try {
        final response = await _callChatGptApi(prompt);
        return _parseResponse(response);
      } catch (e) {
        print('ChatGPT-4 API 호출 오류: $e');
        throw Exception('모든 API 호출 오류');
      }
    }
  }

  Future<http.Response> _callOllamaApi(String prompt) async {
    return await http.post(
      Uri.parse(_ollamaApiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
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
  }

  Future<http.Response> _callChatGptApi(String prompt) async {
    return await http.post(
      Uri.parse(_chatGptApiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_chatGptApiKey',
      },
      body: json.encode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content": prompt,
          }
        ]
      }),
    );
  }

  String _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      return responseBody['choices'][0]['message']['content'] ?? '시나리오 생성 실패';
    } else {
      print('API 요청 실패: ${response.statusCode}');
      print('응답 본문: ${utf8.decode(response.bodyBytes)}');
      throw Exception('API 요청 실패: ${response.statusCode}');
    }
  }
}
