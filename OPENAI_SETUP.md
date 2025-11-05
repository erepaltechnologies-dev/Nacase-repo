# OpenAI Assistant Integration Setup

This guide will help you set up the OpenAI Assistant integration in the Dlaw UI app.

## Prerequisites

1. An OpenAI account with API access
2. An OpenAI Assistant created in your OpenAI dashboard
3. Flutter development environment set up

## Setup Instructions

### 1. Get Your OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign in to your account
3. Click "Create new secret key"
4. Copy the generated API key

### 2. Configure the API Key

1. Open the file `lib/config/api_config.dart`
2. Replace `'your-openai-api-key-here'` with your actual OpenAI API key:

```dart
static const String openaiApiKey = 'sk-your-actual-api-key-here';
```

**⚠️ Security Warning:** Never commit your actual API key to version control. Consider using environment variables or secure storage in production.

### 3. Assistant Configuration

The app is already configured to use the assistant ID: `asst_V3DOuVl8TAtFGFlYLRTej5OY`

If you want to use a different assistant:
1. Create a new assistant in your OpenAI dashboard
2. Copy the assistant ID
3. Update the `assistantId` in `lib/config/api_config.dart`

## Features

### AI Chat Screen

The AI Chat Screen (`lib/screens/home/ai_chat_screen.dart`) includes:

- **Real-time messaging** with OpenAI Assistant
- **Loading indicators** while processing requests
- **Error handling** for network issues and API errors
- **Smart lawyer suggestions** when legal representation is mentioned
- **Thread management** for conversation continuity

### Key Components

1. **OpenAI Service** (`lib/services/openai_service.dart`)
   - Handles all OpenAI API communications
   - Manages conversation threads
   - Implements proper error handling

2. **API Configuration** (`lib/config/api_config.dart`)
   - Centralized configuration for API keys
   - Validation methods for setup verification

## Usage

1. Launch the app
2. Navigate to the AI Chat Screen
3. Start chatting with the AI assistant
4. The assistant will provide legal guidance and suggest lawyers when appropriate

## Troubleshooting

### "OpenAI API key is not configured" Error
- Make sure you've updated the API key in `lib/config/api_config.dart`
- Verify the API key is valid and has sufficient credits

### Network/Connection Errors
- Check your internet connection
- Verify the OpenAI API is accessible from your network
- Ensure your API key has the necessary permissions

### Assistant Not Responding
- Verify the assistant ID is correct
- Check if the assistant is properly configured in your OpenAI dashboard
- Review the OpenAI API usage limits

## API Costs

Be aware that using the OpenAI API incurs costs based on:
- Number of tokens processed
- Model used by your assistant
- Frequency of requests

Monitor your usage in the OpenAI dashboard to avoid unexpected charges.

## Security Best Practices

1. **Never hardcode API keys** in production apps
2. **Use environment variables** or secure storage solutions
3. **Implement rate limiting** to prevent abuse
4. **Monitor API usage** regularly
5. **Rotate API keys** periodically

## Support

For issues related to:
- **OpenAI API**: Check [OpenAI Documentation](https://platform.openai.com/docs)
- **Flutter Development**: Refer to [Flutter Documentation](https://flutter.dev/docs)
- **App-specific issues**: Review the code comments and error messages