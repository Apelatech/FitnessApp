# Groq API Integration Example

This example shows how the ApelaTech Fitness app integrates with Groq's AI API for real-time fitness coaching.

## API Key Setup

1. Get your free API key from [Groq Console](https://console.groq.com/keys)
2. Configure it in the app via AI Settings or directly in code

## Usage Example

```dart
// Initialize the service
final groqService = GroqApiService(apiKey: 'your_api_key_here');

// Send a fitness-related question
final response = await groqService.generateResponse(
  userMessage: "I want to lose weight. What exercises should I do?",
  conversationHistory: [], // Optional conversation context
);

print(response);
// Output: Personalized workout plan with specific exercises and instructions
```

## Features

- **Real-time AI responses** using Llama 3 8B model
- **Conversation context** maintained across messages  
- **Fitness-specialized prompts** for accurate coaching advice
- **Fallback responses** when API is unavailable
- **Error handling** with user-friendly messages

## API Configuration

The app automatically detects if the API key is configured:

```dart
if (ApiConfig.isApiKeyConfigured && ApiConfig.useRealApi) {
  // Use real Groq API
  final response = await groqService.generateResponse(...);
} else {
  // Use simulated responses for demo
  final response = generateSimulatedResponse(...);
}
```

## Rate Limits & Costs

- **Groq Free Tier**: Generous limits for personal use
- **Fast Responses**: Typically under 1 second response time
- **Model**: Llama 3 8B (optimal balance of speed and quality)

## System Prompt

The AI is specialized for fitness coaching with this system prompt:

```
You are AI FitBot, a professional fitness coach and nutritionist for ApelaTech Fitness app. 
You provide expert advice on:

🏋️ WORKOUTS: Create personalized exercise plans, explain proper form, suggest modifications
🍎 NUTRITION: Meal planning, macro calculations, healthy eating habits  
📊 PROGRESS: Goal setting, tracking methods, motivation
💪 GENERAL FITNESS: Recovery, sleep, hydration, injury prevention

Keep responses conversational, encouraging, and actionable!
```

## Testing

To test the integration:

1. Navigate to AI FitBot in the app
2. Ask fitness-related questions like:
   - "Create a beginner workout plan"
   - "How many calories should I eat to lose weight?"
   - "What's the proper form for squats?"
3. The AI will provide personalized, expert responses

## Error Handling

The app gracefully handles various scenarios:

- **No API key**: Shows configuration notice and uses simulated responses
- **API errors**: Falls back to predefined helpful responses
- **Network issues**: Displays user-friendly error messages
- **Invalid responses**: Provides default fitness advice

This ensures users always have a functional AI coach experience!
