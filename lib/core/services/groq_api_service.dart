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
    return '''You are AI FitBot, an intelligent assistant for ApelaTech Fitness app. You are knowledgeable, helpful, and can answer a wide variety of questions.

PRIMARY EXPERTISE:
🏋️ FITNESS: Workouts, exercise form, training plans, strength building
🍎 NUTRITION: Meal planning, calories, macros, healthy eating
📊 WELLNESS: Sleep, recovery, stress management, mental health
💪 GOALS: Weight loss, muscle gain, endurance, general health

GENERAL KNOWLEDGE:
You can also help with general questions about health, science, technology, and lifestyle topics related to overall well-being.

GUIDELINES:
- Answer any question the user asks, whether fitness-related or general
- Keep responses helpful, accurate, and conversational
- Use emojis sparingly but effectively
- Provide actionable advice when possible
- Be encouraging and supportive
- Keep responses concise but informative (max 250 words)
- If you don't know something, be honest about it
- Format information clearly with bullet points when helpful

TONE: Friendly, knowledgeable, helpful, encouraging

You're an intelligent AI assistant that happens to specialize in fitness, but you can help with any question!''';
  }

  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Special network test response
    if (lowerMessage.contains('test') || lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return '''👋 **Hello! I'm AI FitBot**

I'm your intelligent fitness assistant, ready to help with:
🏋️ **Fitness & Workouts** - Exercise plans, form tips, training advice
🍎 **Nutrition & Diet** - Meal planning, healthy eating, macro guidance  
💪 **Health & Wellness** - General health questions, lifestyle tips
🧠 **General Questions** - I can help with various topics beyond fitness too!

⚠️ *Currently using offline mode. For full AI capabilities, please configure your Groq API key.*

What would you like to know about?''';
    }
    
    // Fitness-related responses
    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise') || lowerMessage.contains('fitness')) {
      return '''💪 **Workout Guidance**

Here's a balanced starter routine:
• **Strength**: Push-ups, squats, lunges (3 sets of 8-12 reps)
• **Core**: Plank, mountain climbers (3 sets of 30-60 seconds)
• **Cardio**: Walking, jogging, or cycling (20-30 minutes)
• **Flexibility**: Stretch for 10-15 minutes after workouts

**Progressive Tips:**
- Start with bodyweight exercises
- Increase intensity gradually
- Rest 48 hours between strength sessions
- Listen to your body

What's your current fitness level and goals?''';
    } 
    
    else if (lowerMessage.contains('nutrition') || lowerMessage.contains('diet') || lowerMessage.contains('food') || lowerMessage.contains('eat')) {
      return '''🍎 **Nutrition Fundamentals**

**Daily Essentials:**
• **Protein**: 0.8-1g per kg body weight (chicken, fish, beans, eggs)
• **Carbs**: Choose complex carbs (oats, quinoa, sweet potatoes)
• **Fats**: Healthy sources (avocado, nuts, olive oil)
• **Hydration**: 8-10 glasses of water daily

**Meal Timing:**
- Eat protein with every meal
- Include vegetables in lunch and dinner
- Pre-workout: Light carbs + protein
- Post-workout: Protein + carbs within 30 minutes

What are your nutrition goals? Weight management, muscle gain, or general health?''';
    }
    
    else if (lowerMessage.contains('weight') || lowerMessage.contains('lose') || lowerMessage.contains('gain')) {
      return '''⚖️ **Weight Management**

**For Weight Loss:**
• Create a moderate calorie deficit (300-500 calories/day)
• Combine cardio + strength training
• Focus on whole foods, lean proteins
• Stay consistent with meal timing

**For Weight Gain:**
• Eat in a slight calorie surplus (200-500 calories/day)
• Prioritize strength training
• Include healthy calorie-dense foods
• Eat frequent, balanced meals

**Universal Tips:**
- Track your progress weekly
- Be patient with results (2-4 weeks to see changes)
- Focus on sustainable habits

What's your current goal and timeline?''';
    }
    
    else if (lowerMessage.contains('sleep') || lowerMessage.contains('tired') || lowerMessage.contains('recovery')) {
      return '''😴 **Sleep & Recovery**

**Better Sleep Tips:**
• Aim for 7-9 hours nightly
• Keep a consistent sleep schedule
• Avoid screens 1 hour before bed
• Keep room cool and dark

**Recovery Essentials:**
• Rest days between intense workouts
• Stay hydrated throughout the day
• Manage stress with meditation or deep breathing
• Gentle stretching or yoga

**Signs You Need More Rest:**
- Persistent fatigue
- Decreased workout performance
- Mood changes or irritability

How has your sleep and recovery been lately?''';
    }
    
    else if (lowerMessage.contains('motivation') || lowerMessage.contains('goal') || lowerMessage.contains('help')) {
      return '''� **Motivation & Goal Setting**

**SMART Goals Framework:**
• **Specific**: Clear, defined objectives
• **Measurable**: Track your progress
• **Achievable**: Realistic expectations
• **Relevant**: Personally meaningful
• **Time-bound**: Set deadlines

**Stay Motivated:**
- Celebrate small wins along the way
- Find an accountability partner
- Track progress with photos/measurements
- Focus on how exercise makes you feel
- Remember your "why"

**Common Challenges:**
- Start small and build habits gradually
- Expect setbacks and learn from them
- Adjust goals as needed

What specific goal would you like to work toward?''';
    }
    
    // General questions
    else if (lowerMessage.contains('how') || lowerMessage.contains('what') || lowerMessage.contains('why') || lowerMessage.contains('when')) {
      return '''🤔 **I'm Here to Help!**

I noticed you have a question! While I'm currently in offline mode, I can still provide helpful information about:

**Health & Fitness Topics:**
• Exercise techniques and workout plans
• Nutrition advice and meal planning
• Wellness tips and healthy habits
• Goal setting and motivation

**General Wellness:**
• Sleep and recovery strategies
• Stress management techniques
• Healthy lifestyle tips

*For the most accurate and personalized answers, please configure the Groq API key to enable full AI capabilities.*

Could you rephrase your question or let me know what specific area you'd like help with?''';
    }
    
    else {
      return '''🤖 **AI FitBot - Your Fitness Assistant**

I'm here to help with all your health and fitness questions! I can assist with:

**🏋️ FITNESS**
- Workout routines and exercise form
- Training programs for different goals
- Equipment recommendations

**🍽️ NUTRITION** 
- Meal planning and healthy recipes
- Macronutrient guidance
- Weight management strategies

**💡 WELLNESS**
- Sleep optimization
- Stress management
- Healthy habit formation

**❓ GENERAL QUESTIONS**
- Health-related inquiries
- Lifestyle advice
- Motivation and goal setting

*Note: Currently using offline responses. Configure your Groq API key for full AI-powered assistance.*

What would you like to explore today?''';
    }
  }
}
