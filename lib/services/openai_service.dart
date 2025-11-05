import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _assistantId = 'asst_V3DOuVl8TAtFGFlYLRTej5OY';
  static const String _baseUrl = 'https://api.openai.com/v1';
  static String? _apiKey;
  static bool _isInitialized = false;

  // Initialize the OpenAI service with API key
  static void initialize(String apiKey) {
    _apiKey = apiKey;
    _isInitialized = true;
  }

  // Check if the service is initialized
  static bool get isInitialized => _isInitialized;

  // Get headers for API requests
  static Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
    'OpenAI-Beta': 'assistants=v2',
  };

  // Create a new thread for conversation
  static Future<String> createThread() async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized. Call initialize() first.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/threads'),
        headers: _headers,
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id'];
      } else {
        throw Exception('Failed to create thread: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create thread: $e');
    }
  }

  // Send a message to the assistant and get response
  static Future<String> sendMessage(String threadId, String message) async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized. Call initialize() first.');
    }

    try {
      // Add message to thread
      final messageResponse = await http.post(
        Uri.parse('$_baseUrl/threads/$threadId/messages'),
        headers: _headers,
        body: json.encode({
          'role': 'user',
          'content': message,
        }),
      );

      if (messageResponse.statusCode != 200) {
        throw Exception('Failed to add message: ${messageResponse.statusCode} ${messageResponse.body}');
      }

      // Create and run the assistant
      final runResponse = await http.post(
        Uri.parse('$_baseUrl/threads/$threadId/runs'),
        headers: _headers,
        body: json.encode({
          'assistant_id': _assistantId,
        }),
      );

      if (runResponse.statusCode != 200) {
        throw Exception('Failed to create run: ${runResponse.statusCode} ${runResponse.body}');
      }

      final runData = json.decode(runResponse.body);
      final runId = runData['id'];

      // Wait for completion
      String status = 'queued';
      while (status == 'queued' || status == 'in_progress') {
        await Future.delayed(const Duration(seconds: 1));
        
        final statusResponse = await http.get(
          Uri.parse('$_baseUrl/threads/$threadId/runs/$runId'),
          headers: _headers,
        );

        if (statusResponse.statusCode == 200) {
          final statusData = json.decode(statusResponse.body);
          status = statusData['status'];
        } else {
          throw Exception('Failed to check run status: ${statusResponse.statusCode}');
        }
      }

      if (status == 'completed') {
        // Get the latest messages
        final messagesResponse = await http.get(
          Uri.parse('$_baseUrl/threads/$threadId/messages?limit=1'),
          headers: _headers,
        );

        if (messagesResponse.statusCode == 200) {
          final messagesData = json.decode(messagesResponse.body);
          final messages = messagesData['data'] as List;
          
          if (messages.isNotEmpty) {
            final latestMessage = messages.first;
            final content = latestMessage['content'] as List;
            
            if (content.isNotEmpty && content.first['type'] == 'text') {
              return content.first['text']['value'];
            }
          }
        }
      } else {
        throw Exception('Assistant run failed with status: $status');
      }

      return 'Sorry, I could not process your request.';
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get conversation history
  static Future<List<Map<String, String>>> getConversationHistory(String threadId) async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized. Call initialize() first.');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/threads/$threadId/messages'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final messages = data['data'] as List;
        
        List<Map<String, String>> conversation = [];
        
        for (var message in messages.reversed) {
          final content = message['content'] as List;
          if (content.isNotEmpty && content.first['type'] == 'text') {
            conversation.add({
              'role': message['role'],
              'content': content.first['text']['value'],
            });
          }
        }

        return conversation;
      } else {
        throw Exception('Failed to get messages: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get conversation history: $e');
    }
  }

  // Delete a thread
  static Future<void> deleteThread(String threadId) async {
    if (!_isInitialized) {
      throw Exception('OpenAI service not initialized. Call initialize() first.');
    }

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/threads/$threadId'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete thread: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete thread: $e');
    }
  }
}