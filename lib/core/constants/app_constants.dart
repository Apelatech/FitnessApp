class AppConstants {
  // App Information
  static const String appName = 'ApelaTech Fitness';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Fitness Coaching Platform';
  
  // API Configuration
  static const String baseUrl = 'https://api.apelatech.com';
  static const String chatGptApiKey = 'your_chatgpt_api_key_here';
  
  // Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String workoutDataKey = 'workout_data';
  static const String nutritionDataKey = 'nutrition_data';
  static const String progressDataKey = 'progress_data';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  
  // Fitness Goals
  static const List<String> fitnessGoals = [
    'Fat Loss',
    'Muscle Gain',
    'Flexibility',
    'Endurance',
    'Strength',
    'General Fitness',
  ];
  
  // Activity Levels
  static const List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active',
  ];
  
  // Workout Types
  static const List<String> workoutTypes = [
    'Strength Training',
    'Cardio',
    'HIIT',
    'Yoga',
    'Pilates',
    'Stretching',
    'Running',
    'Cycling',
    'Swimming',
    'Sports',
  ];
  
  // Nutrition Categories
  static const List<String> nutritionCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Pre-Workout',
    'Post-Workout',
  ];
  
  // AI FitBot Messages
  static const String welcomeMessage = '''
🏋️‍♀️ Welcome to ApelaTech Fitness AI Coach!

I'm here to help you achieve your fitness goals with personalized:
• Workout plans
• Nutrition guidance  
• Form corrections
• Motivation & tips

How can I assist you today?
  ''';
  
  static const List<String> quickReplies = [
    'Create workout plan',
    'Meal suggestions',
    'Track progress',
    'Form check',
    'Motivation',
  ];
  
  // Sample Data for Demo
  static const Map<String, dynamic> sampleUserProfile = {
    'name': 'John Doe',
    'age': 28,
    'height': 175, // cm
    'weight': 75, // kg
    'goal': 'Muscle Gain',
    'activity_level': 'Moderately Active',
    'experience': 'Intermediate',
  };
  
  // Chart Data Limits
  static const int maxChartDataPoints = 30;
  static const int defaultAnalyticsPeriod = 7; // days
}
