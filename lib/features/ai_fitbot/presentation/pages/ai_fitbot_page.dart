import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/chat_message.dart';

class AiFitbotPage extends StatefulWidget {
  const AiFitbotPage({super.key});

  @override
  State<AiFitbotPage> createState() => _AiFitbotPageState();
}

class _AiFitbotPageState extends State<AiFitbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
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
                  hintText: 'Ask me anything about fitness...',
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

    // Simulate AI response
    _simulateAIResponse(text);
  }

  void _sendQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  void _simulateAIResponse(String userMessage) {
    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 2), () {
      final aiResponse = _generateAIResponse(userMessage);
      
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      setState(() {
        _isTyping = false;
        _messages.add(aiMessage);
      });

      _scrollToBottom();
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise')) {
      return '''Great question! Based on your profile, I recommend starting with:

💪 **Strength Training (3x/week)**
- Push-ups: 3 sets of 8-12 reps
- Squats: 3 sets of 10-15 reps
- Plank: 3 sets of 30-60 seconds

🏃 **Cardio (2x/week)**
- 20-30 minutes moderate intensity
- Running, cycling, or swimming

Would you like me to create a detailed workout plan for this week?''';
    } else if (lowerMessage.contains('nutrition') || lowerMessage.contains('diet') || lowerMessage.contains('meal')) {
      return '''Excellent! Nutrition is key to your fitness success. Here's what I suggest:

🍎 **Daily Targets:**
- Calories: 2000-2200 (based on your goals)
- Protein: 120-140g
- Carbs: 200-250g
- Fats: 60-80g

🥗 **Meal Ideas:**
- Breakfast: Oatmeal with berries and protein powder
- Lunch: Grilled chicken salad with quinoa
- Dinner: Salmon with sweet potato and vegetables

Need help planning your meals for the week?''';
    } else if (lowerMessage.contains('progress') || lowerMessage.contains('track')) {
      return '''Tracking progress is essential! Here's what I recommend monitoring:

📊 **Key Metrics:**
- Body weight (weekly)
- Body measurements (bi-weekly)
- Strength gains (workout logs)
- Energy levels (daily)

📱 **Tools:**
- Take progress photos
- Log workouts consistently
- Track sleep quality
- Monitor nutrition intake

I can help you set up a tracking system. What's your primary goal?''';
    } else {
      return '''Thanks for your question! I'm here to help with:

🏋️ **Workouts** - Custom plans and form guidance
🍽️ **Nutrition** - Meal planning and macro tracking  
📈 **Progress** - Analytics and goal setting
💪 **Motivation** - Daily tips and encouragement

What specific area would you like to focus on today?''';
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
              leading: const Icon(Icons.settings, color: AppColors.textSecondary),
              title: const Text('AI Settings'),
              onTap: () {
                Navigator.pop(context);
                // Show AI settings
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
