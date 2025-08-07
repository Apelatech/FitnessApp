# API Setup Instructions

## Quick Setup for AI FitBot

To enable the AI FitBot functionality in your ApelaTech Fitness app:

### Step 1: Get Your Groq API Key
1. Visit [Groq Console](https://console.groq.com/keys)
2. Sign up for a free account
3. Create a new API key
4. Copy the API key (starts with `gsk_...`)

### Step 2: Configure the App
1. Open the file: `lib/core/config/api_config.dart`
2. Find this line:
   ```dart
   static const String groqApiKey = 'YOUR_GROQ_API_KEY_HERE';
   ```
3. Replace `YOUR_GROQ_API_KEY_HERE` with your actual API key:
   ```dart
   static const String groqApiKey = 'gsk_your_actual_api_key_here';
   ```

### Step 3: Test the App
1. Save the file
2. Run the app: `flutter run`
3. Navigate to AI FitBot
4. Start chatting with your AI fitness coach!

## Security Note
⚠️ **Important**: Never commit your actual API key to version control. The `.gitignore` file is configured to protect your API keys.

## Troubleshooting
- If AI responses don't work, check your internet connection
- Ensure your API key is valid and properly formatted
- Check the console for any error messages
- The app includes offline fallback responses for testing

For more detailed setup instructions, see the main [README.md](README.md) file.
