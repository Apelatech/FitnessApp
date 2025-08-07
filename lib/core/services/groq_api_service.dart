import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqApiService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _model = 'llama3-8b-8192'; // Using Llama 3 8B model
  
  final String _apiKey;
  
  GroqApiService({required String apiKey}) : _apiKey = apiKey;

  Future<String> generateResponse({
    required String userMessage,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      print('DEBUG: Starting Groq API call...');
      print('DEBUG: API Key: ${_apiKey.substring(0, 10)}...');
      
      final messages = _buildMessages(userMessage, conversationHistory);
      print('DEBUG: Messages prepared: ${messages.length} messages');
      
      final uri = Uri.parse('$_baseUrl/chat/completions');
      print('DEBUG: Making request to: $uri');
      
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 1024,
          'temperature': 0.7,
          'top_p': 1,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 30));

      print('DEBUG: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        print('DEBUG: API response successful');
        return content?.trim() ?? 'Sorry, I couldn\'t generate a response.';
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        return _getFallbackResponse(userMessage);
      }
    } catch (e) {
      print('Error calling Groq API: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  List<Map<String, String>> _buildMessages(
    String userMessage,
    List<Map<String, String>>? conversationHistory,
  ) {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': _getSystemPrompt(),
      }
    ];

    // Add conversation history if provided
    if (conversationHistory != null) {
      messages.addAll(conversationHistory);
    }

    // Add current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });

    return messages;
  }

  String _getSystemPrompt() {
    return '''You are AI FitBot, a professional fitness coach and nutritionist for ApelaTech Fitness app. You provide expert advice on:

🏋️ WORKOUTS: Create personalized exercise plans, explain proper form, suggest modifications
🍎 NUTRITION: Meal planning, macro calculations, healthy eating habits
📊 PROGRESS: Goal setting, tracking methods, motivation
💪 GENERAL FITNESS: Recovery, sleep, hydration, injury prevention

GUIDELINES:
- Keep responses conversational and encouraging
- Use emojis sparingly but effectively
- Provide actionable, specific advice
- Ask follow-up questions to personalize recommendations
- Mention safety and proper form when discussing exercises
- Be supportive and motivational
- Keep responses concise but informative (max 200 words)
- Format lists with bullet points when helpful

TONE: Friendly, professional, motivating, knowledgeable

Remember: You're helping users achieve their fitness goals through the ApelaTech Fitness platform.''';
  }

  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Special network test response
    if (lowerMessage.contains('test') || lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return '''🤖 **AI Coach Connection Status**

⚠️ Network Issue Detected: Unable to reach Groq API servers.

**Possible Solutions:**
1. Check your internet connection
2. Try restarting the app
3. Ensure emulator has network access

**For now, I'm using offline responses.** Once connected, you'll get real AI-powered fitness coaching! 

How can I help with your fitness goals today?''';
    }
    
    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise')) {
      return '''💪 **Offline Workout Recommendation**

Here's a great starter routine:
• Push-ups: 3 sets of 8-12 reps
• Squats: 3 sets of 10-15 reps  
• Plank: 3 sets of 30-60 seconds
• Walking/jogging: 20-30 minutes

What's your current fitness level? I can customize this for you once we're connected to the AI!''';
    } else if (lowerMessage.contains('nutrition') || lowerMessage.contains('diet')) {
      return '''🍎 **Offline Nutrition Basics**

Focus on these fundamentals:
• Eat protein with every meal (0.8g per kg body weight)
• Include colorful vegetables and fruits
• Stay hydrated (8-10 glasses of water daily)
• Choose whole grains over processed foods

What are your nutrition goals? Weight loss, muscle gain, or general health?''';
    } else {
      return '''👋 **Offline Fitness Coach**

I can help you with:
🏋️ Workout plans and exercise form
🍽️ Nutrition advice and meal planning
📈 Progress tracking and goal setting
💪 General fitness and wellness tips

*Note: Currently using offline responses. Real AI coaching will be available once network connection is established.*

What would you like to work on today?''';
    }
  }
}
