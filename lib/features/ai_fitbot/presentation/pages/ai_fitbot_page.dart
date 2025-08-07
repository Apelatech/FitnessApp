import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/services/groq_api_service.dart';
import '../../../../shared/models/chat_message.dart';
import 'api_settings_page.dart';

class AiFitbotPage extends StatefulWidget {
  const AiFitbotPage({super.key});

  @override
  State<AiFitbotPage> createState() => _AiFitbotPageState();
}

class _AiFitbotPageState extends State<AiFitbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late GroqApiService? _groqService;
  
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      content: AppConstants.welcomeMessage,
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isFromUser: false,
      quickReplies: AppConstants.quickReplies,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeGroqService();
  }

  void _initializeGroqService() {
    print('DEBUG: Initializing Groq service...');
    print('DEBUG: API Key configured: ${ApiConfig.isApiKeyConfigured}');
    print('DEBUG: Use real API: ${ApiConfig.useRealApi}');
    print('DEBUG: API Key: ${ApiConfig.groqApiKey.substring(0, 10)}...');
    
    if (ApiConfig.isApiKeyConfigured && ApiConfig.useRealApi) {
      _groqService = GroqApiService(apiKey: ApiConfig.groqApiKey);
      print('DEBUG: Groq service initialized successfully');
    } else {
      _groqService = null;
      print('DEBUG: Using simulated responses');
      // Show a one-time message about API configuration
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showApiConfigMessage();
      });
    }
  }

  void _showApiConfigMessage() {
    if (!mounted) return;
    
    final configMessage = ChatMessage(
      id: 'config_${DateTime.now().millisecondsSinceEpoch}',
      content: '''🔧 **API Configuration Notice**

To enable real AI conversations, please:
1. Get a free API key from: https://console.groq.com/keys
2. Update the API key in: lib/core/config/api_config.dart
3. Restart the app

For now, I'll use simulated responses to demonstrate the interface! 🤖''',
      type: MessageType.text,
      timestamp: DateTime.now(),
      isFromUser: false,
    );

    setState(() {
      _messages.insert(1, configMessage);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI FitBot',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your Personal Fitness Coach',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator();
        }
        
        final message = _messages[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 100),
          child: _buildMessageBubble(message),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isFromUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatarIcon(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser 
                      ? AppColors.accent 
                      : AppColors.surface,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isUser 
                        ? const Radius.circular(16) 
                        : const Radius.circular(4),
                      bottomRight: isUser 
                        ? const Radius.circular(4) 
                        : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isUser 
                        ? AppColors.textWhite 
                        : AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.quickReplies?.isNotEmpty == true)
                  _buildQuickReplies(message.quickReplies!),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.smart_toy,
        color: AppColors.secondary,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person,
        color: AppColors.accent,
        size: 20,
      ),
    );
  }

  Widget _buildQuickReplies(List<String> quickReplies) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: quickReplies.map((reply) => _buildQuickReplyChip(reply)).toList(),
      ),
    );
  }

  Widget _buildQuickReplyChip(String text) {
    return GestureDetector(
      onTap: () => _sendQuickReply(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.3),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildAvatarIcon(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: index * 200),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              color: AppColors.secondary,
              onPressed: _showCameraOptions,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Ask me anything - fitness, health, or general questions...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.send,
                  color: AppColors.textWhite,
                  size: 20,
                ),
              ),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      type: MessageType.text,
      timestamp: DateTime.now(),
      isFromUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    _simulateAIResponse(text);
  }

  void _sendQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  void _simulateAIResponse(String userMessage) async {
    try {
      String aiResponse;
      print('DEBUG: Processing AI response for: $userMessage');
      print('DEBUG: Groq service available: ${_groqService != null}');
      
      if (_groqService != null) {
        print('DEBUG: Using real Groq API');
        // Use real Groq API
        final conversationHistory = _buildConversationHistory();
        print('DEBUG: Conversation history length: ${conversationHistory.length}');
        
        aiResponse = await _groqService!.generateResponse(
          userMessage: userMessage,
          conversationHistory: conversationHistory,
        );
        print('DEBUG: Groq API response received: ${aiResponse.substring(0, 50)}...');
      } else {
        print('DEBUG: Using simulated response');
        // Use fallback simulated response
        await Future.delayed(const Duration(seconds: 1));
        aiResponse = _generateSimulatedResponse(userMessage);
      }
      
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(aiMessage);
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Error generating AI response: $e');
      
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error. Please try again! 🤖',
        type: MessageType.text,
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(errorMessage);
        });
        _scrollToBottom();
      }
    }
  }

  List<Map<String, String>> _buildConversationHistory() {
    // Get last 10 messages (excluding system messages) for context
    final recentMessages = _messages
        .where((msg) => !msg.content.contains('🔧 **API Configuration Notice**'))
        .take(10)
        .toList();
        
    final history = <Map<String, String>>[];
    
    for (final message in recentMessages) {
      history.add({
        'role': message.isFromUser ? 'user' : 'assistant',
        'content': message.content,
      });
    }
    
    return history;
  }

  String _generateSimulatedResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Greetings and general questions
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return '''👋 **Hello! I'm AI FitBot**

I'm your intelligent fitness assistant! I can help you with:

🏋️ **Fitness & Exercise** - Workouts, training plans, form tips
🍎 **Nutrition & Diet** - Meal planning, healthy eating advice
💪 **Health & Wellness** - Sleep, recovery, stress management
🤔 **General Questions** - I can answer various health-related topics!

*Note: I'm currently in offline mode. For full AI capabilities, please configure your Groq API key.*

What would you like to know about today?''';
    }
    
    // Fitness and workout questions
    else if (lowerMessage.contains('workout') || lowerMessage.contains('exercise') || lowerMessage.contains('fitness') || lowerMessage.contains('gym')) {
      return '''💪 **Workout Guidance**

Based on your question, here's a great starter routine:

**🏋️ Strength Training (3x/week):**
- Push-ups: 3 sets of 8-12 reps
- Squats: 3 sets of 10-15 reps
- Plank: 3 sets of 30-60 seconds
- Lunges: 3 sets of 8-12 per leg

**🏃 Cardio (2-3x/week):**
- 20-30 minutes moderate intensity
- Walking, jogging, cycling, or swimming

**💡 Pro Tips:**
- Rest 48 hours between strength sessions
- Start slow and gradually increase intensity
- Focus on proper form over speed

Would you like me to customize this based on your fitness level?''';
    } 
    
    // Nutrition questions
    else if (lowerMessage.contains('nutrition') || lowerMessage.contains('diet') || lowerMessage.contains('meal') || lowerMessage.contains('food') || lowerMessage.contains('eat')) {
      return '''🍎 **Nutrition Guidance**

Excellent question! Here's your nutrition roadmap:

**📊 Daily Targets (adjust based on your goals):**
- Calories: 1800-2200 (varies by person)
- Protein: 1.2-1.6g per kg body weight
- Carbs: 3-5g per kg body weight
- Fats: 20-35% of total calories

**🥗 Meal Structure:**
- **Breakfast:** Protein + complex carbs (oats, eggs, berries)
- **Lunch:** Lean protein + vegetables + healthy fats
- **Dinner:** Similar to lunch, lighter portions
- **Snacks:** Nuts, Greek yogurt, fruits

**💧 Hydration:** 8-10 glasses of water daily

What's your primary nutrition goal? Weight loss, muscle gain, or general health?''';
    } 
    
    // Weight management questions
    else if (lowerMessage.contains('weight') || lowerMessage.contains('lose') || lowerMessage.contains('gain') || lowerMessage.contains('fat') || lowerMessage.contains('muscle')) {
      return '''⚖️ **Weight Management**

Great question! Here's how to approach your goals:

**🔥 For Weight Loss:**
- Create a moderate calorie deficit (300-500 cal/day)
- Combine cardio + strength training
- Focus on whole foods and lean proteins
- Be patient - aim for 1-2 lbs per week

**💪 For Muscle Gain:**
- Slight calorie surplus (200-400 cal/day)
- Prioritize strength training
- Eat 1.6-2.2g protein per kg body weight
- Get adequate sleep (7-9 hours)

**🎯 Universal Tips:**
- Track progress with photos and measurements
- Stay consistent for 4-6 weeks to see results
- Adjust based on your body's response

What's your specific goal and current situation?''';
    }
    
    // Health and wellness questions
    else if (lowerMessage.contains('sleep') || lowerMessage.contains('tired') || lowerMessage.contains('stress') || lowerMessage.contains('recovery') || lowerMessage.contains('health')) {
      return '''🌙 **Health & Wellness**

Taking care of your overall health is crucial! Here's my advice:

**😴 Better Sleep:**
- Aim for 7-9 hours nightly
- Keep a consistent sleep schedule
- Avoid screens 1 hour before bed
- Keep bedroom cool and dark

**🧘 Stress Management:**
- Practice deep breathing or meditation
- Regular exercise (even 10 minutes helps!)
- Take breaks throughout your day
- Connect with friends and family

**🔄 Recovery:**
- Rest days between intense workouts
- Stay hydrated throughout the day
- Gentle stretching or yoga
- Listen to your body's signals

How has your sleep and stress levels been lately?''';
    }
    
    // Motivation and goal-setting
    else if (lowerMessage.contains('motivation') || lowerMessage.contains('goal') || lowerMessage.contains('start') || lowerMessage.contains('begin')) {
      return '''🎯 **Motivation & Goals**

I love that you're ready to take action! Here's how to set yourself up for success:

**📋 SMART Goal Setting:**
- **Specific:** Clear, defined objectives
- **Measurable:** Track your progress
- **Achievable:** Realistic for your lifestyle
- **Relevant:** Personally meaningful to you
- **Time-bound:** Set deadlines

**🚀 Getting Started Tips:**
- Start small (even 10 minutes counts!)
- Build one habit at a time
- Find activities you actually enjoy
- Prepare for setbacks (they're normal!)

**💪 Stay Motivated:**
- Celebrate small wins
- Track your progress visually
- Find an accountability partner
- Remember your "why"

What's one small step you could take today toward your goal?''';
    }
    
    // General questions and how/what/why queries
    else if (lowerMessage.contains('how') || lowerMessage.contains('what') || lowerMessage.contains('why') || lowerMessage.contains('when') || lowerMessage.contains('should')) {
      return '''🤔 **I'm Here to Help!**

I noticed you have a question! While I'm in offline mode, I can still provide guidance on:

**🏃 Fitness Topics:**
- Exercise techniques and workout planning
- Training frequency and intensity
- Form tips and safety guidelines

**🥗 Nutrition Topics:**
- Meal timing and portion control
- Macronutrient balance
- Healthy food choices

**🧠 Wellness Topics:**
- Sleep optimization strategies
- Stress management techniques
- Building healthy habits

**💡 General Health:**
- Recovery and rest day planning
- Injury prevention
- Lifestyle modifications

Could you be more specific about what you'd like to know? I'm here to help with any health and fitness questions!''';
    }
    
    // Progress and tracking
    else if (lowerMessage.contains('progress') || lowerMessage.contains('track') || lowerMessage.contains('measure') || lowerMessage.contains('result')) {
      return '''📊 **Progress Tracking**

Excellent question! Tracking progress keeps you motivated and on track:

**📏 Key Metrics to Monitor:**
- Body weight (weekly, same time of day)
- Body measurements (waist, hips, arms - bi-weekly)
- Progress photos (monthly, same lighting/pose)
- Strength gains (reps, weight, duration)
- Energy levels and mood (daily)

**📱 Tracking Tools:**
- Fitness apps or journals
- Progress photos
- Workout logs
- Sleep and nutrition tracking

**⏰ Timeline Expectations:**
- Energy improvements: 1-2 weeks
- Strength gains: 2-4 weeks
- Visible changes: 4-8 weeks
- Significant transformation: 3-6 months

**🎯 Pro Tip:** Focus on trends over daily fluctuations!

What aspect of your progress are you most curious about tracking?''';
    }
    
    // Default response for any other questions
    else {
      return '''🤖 **AI FitBot - Your Fitness Assistant**

Thanks for your question! I'm designed to help with a wide range of health and fitness topics:

**🏋️ FITNESS & EXERCISE**
- Workout routines and exercise form
- Training programs for different goals
- Equipment recommendations and alternatives

**🍽️ NUTRITION & DIET** 
- Meal planning and healthy recipes
- Macronutrient guidance and calorie needs
- Weight management strategies

**� HEALTH & WELLNESS**
- Sleep optimization and recovery
- Stress management techniques
- Building sustainable healthy habits

**🎯 GOALS & MOTIVATION**
- Setting realistic fitness goals
- Staying motivated and consistent
- Overcoming common challenges

*Note: I'm currently using offline responses. For personalized AI-powered assistance, please configure your Groq API key.*

What specific area would you like to explore? Feel free to ask me anything!''';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share with AI Coach',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.accent),
              title: const Text('Take Photo'),
              subtitle: const Text('Capture form or meal'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.secondary),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select existing photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AI Coach Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.refresh, color: AppColors.secondary),
              title: const Text('New Conversation'),
              onTap: () {
                Navigator.pop(context);
                _startNewConversation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.accent),
              title: const Text('Conversation History'),
              onTap: () {
                Navigator.pop(context);
                // Show conversation history
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings, 
                color: ApiConfig.isApiKeyConfigured 
                    ? AppColors.secondary 
                    : AppColors.accent,
              ),
              title: const Text('AI Settings'),
              subtitle: Text(
                ApiConfig.isApiKeyConfigured 
                    ? 'API configured' 
                    : 'Configure Groq API key',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApiSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startNewConversation() {
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: AppConstants.welcomeMessage,
          type: MessageType.text,
          timestamp: DateTime.now(),
          isFromUser: false,
          quickReplies: AppConstants.quickReplies,
        ),
      );
    });
  }
}
