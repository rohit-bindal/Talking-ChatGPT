import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talking_chatgpt/assets/constants.dart';

class GPTService {
  Future<String> getResponse(List<Map<String, String>> prompt) async {
    String responseContent = '';
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer $API_KEY',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": prompt
          })
      );

      if(res.statusCode == 200){
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim(); //sanitization
        responseContent = content;
      }
    }
    catch (e) {
      responseContent='';
    }
    return responseContent;
  }
}
