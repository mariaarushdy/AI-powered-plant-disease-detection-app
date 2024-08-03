import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiChat {
  final String apiKey;
  final String model;
  List<Map<String, dynamic>> history = [];

  GeminiChat({required this.apiKey, required this.model});

  // Starts a new chat session with an initial message as a snowman
  void startChat() {
    history.add({
      'role': 'system',
      'content': "Pretend you're a snowman and stay in character for each response."
    });
    history.add({
      'role': 'user',
      'content': "Hello! It's cold! Isn't that great?"
    });
  }

  // Sends a message to the chat and gets a response
  Future<String> sendMessage(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chats');

    history.add({
      'role': 'user',
      'content': message
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'model': model,
        'messages': history
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      history.add({
        'role': 'assistant',
        'content': data['choices'][0]['message']['content']
      });
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }
}