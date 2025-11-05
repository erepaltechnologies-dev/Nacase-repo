class ApiConfig {
  // TODO: Replace with your actual OpenAI API key
  // You can get your API key from: https://platform.openai.com/api-keys
  // IMPORTANT: Never commit your actual API key to version control
  // Consider using environment variables or secure storage in production
  static const String openaiApiKey = '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';
  
  // OpenAI Assistant ID (already configured)
  static const String assistantId = 'asst_V3DOuVl8TAtFGFlYLRTej5OY';
  
  // Validation method
  static bool get isConfigured => openaiApiKey != 'your-openai-api-key-here';
} 




  // // Replace with your actual Gemini API key
  // static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  // // Gemini API base URL
  // static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com';
  
  // // Model configuration
  // static const String geminiModel = 'gemini-pro';
  // // Safety settings
  // static const Map<String, String> safetySettings = {
  //   'HARM_CATEGORY_HARASSMENT': 'BLOCK_MEDIUM_AND_ABOVE',
  //   'HARM_CATEGORY_HATE_SPEECH': 'BLOCK_MEDIUM_AND_ABOVE',
  //   'HARM_CATEGORY_SEXUALLY_EXPLICIT': 'BLOCK_MEDIUM_AND_ABOVE',
  //   'HARM_CATEGORY_DANGEROUS_CONTENT': 'BLOCK_MEDIUM_AND_ABOVE',
  // };
  // // Generation configuration
  // static const Map<String, dynamic> generationConfig = {
  //   'temperature': 0.7,
  //   'topK': 40,
  //   'topP': 0.95,
  //   'maxOutputTokens': 1024,
  // };
