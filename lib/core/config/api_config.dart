import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Groq API configuration
  // Get your API key from: https://console.groq.com/keys
  static String get groqApiKey {
    return dotenv.env['GROQ_API_KEY'] ?? 'YOUR_GROQ_API_KEY_HERE';
  }
  
  // Development flag to enable/disable real API calls
  static bool get useRealApi {
    return dotenv.env['USE_REAL_API']?.toLowerCase() == 'true';
  }
  
  // Validate if API key is properly configured
  static bool get isApiKeyConfigured {
    return groqApiKey.isNotEmpty && 
           groqApiKey != 'YOUR_GROQ_API_KEY_HERE';
  }
}
