import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talking_chatgpt/assets/constants.dart';

class DALLEService {
  Future<String> getResponse(String prompt) async {
    String responseContent = '';
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer $API_KEY',
          },
          body: jsonEncode({
            "prompt": prompt,
            "n": 1,
            "size":"512x512"
          })
      );
      if(res.statusCode == 200){
        String content = jsonDecode(res.body)['data'][0]['url'];
        content = content.trim();
        responseContent = content;
      }
    }
    catch (e) {
      responseContent = e.toString();
    }
    return responseContent;
  }
}
