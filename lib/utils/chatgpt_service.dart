import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
      
final apiKey = dotenv.env['OPENAI_APIKEY'];
var logger = Logger();

// OpenAI ChatGPT API와 상호작용
class ChatGPTService {
  final String apiUrl;

  ChatGPTService({this.apiUrl = "https://api.openai.com/v1/chat/completions"});

  // 주어진 단어를 기반으로 문장 생성
  Future<String> generateSentence(String word) async {
    int retryCount = 0; // 재시도 횟수
    const maxRetries = 5; // 최대 재시도 횟수
    const initialRetryDelay = Duration(seconds: 2); // 초기 재시도 대기 시간
    Duration retryDelay = initialRetryDelay; // 현재 재시도 대기 시간

    // 최대 재시도 횟수동안 HTTP POST 요청
    while (retryCount < maxRetries) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo-16k",
          "messages": [
            {
              "role": "user",
              "content": "Generate a Korean and English sentence using the given word. must be 6 words or less in Korean. In both English and Korean, the sentences must be complete, natural, and have correct grammar. \n\n코끼리: \n귀여운 코끼리가 물을 마시고 있어요.\nA cute elephant is drinking water.\n\n$word:"
            }
          ]
        }),
      );

      // 성공적인 응답 처리
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        logger.i('Parsed response data: $data');
        String sentence = data['choices'][0]['message']['content'].trim();
        logger.i('Generated sentence: $sentence');
        return sentence;
      } 
      // 오류 처리 (Exponential Backoff)
      else {
        var statusCode = response.statusCode;
        var errorData = jsonDecode(utf8.decode(response.bodyBytes));
        var errorMessage = errorData['error']['message'];
        logger.e('status code: $statusCode');
        logger.e('response body: ${utf8.decode(response.bodyBytes)}');
        logger.e('error message: $errorMessage');

        // 대기 시간을 두 배로 증가
        retryCount++;
        logger.w('Rate limit exceeded, retrying in ${retryDelay.inSeconds} seconds...');
        await Future.delayed(retryDelay);
        retryDelay *= 2; 
      }
    }

    throw Exception('Failed to generate sentence after $maxRetries retries');
  }
}
