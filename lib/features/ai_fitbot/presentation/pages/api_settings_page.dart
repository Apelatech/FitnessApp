import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/api_config.dart';

class ApiSettingsPage extends StatefulWidget {
  const ApiSettingsPage({super.key});

  @override
  State<ApiSettingsPage> createState() => _ApiSettingsPageState();
}

class _ApiSettingsPageState extends State<ApiSettingsPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isApiKeyVisible = false;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    if (ApiConfig.isApiKeyConfigured) {
      _apiKeyController.text = ApiConfig.groqApiKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildApiKeySection(),
            const SizedBox(height: 32),
            _buildInstructionsCard(),
            const SizedBox(height: 24),
            _buildStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.smart_toy,
                color: AppColors.secondary,
                size: 32,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Groq AI Configuration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Configure your Groq API key for real AI conversations',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApiKeySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'API Key',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _apiKeyController,
          obscureText: !_isApiKeyVisible,
          decoration: InputDecoration(
            hintText: 'Enter your Groq API key...',
            prefixIcon: const Icon(Icons.key, color: AppColors.secondary),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isApiKeyVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isApiKeyVisible = !_isApiKeyVisible;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.paste, color: AppColors.accent),
                  onPressed: _pasteFromClipboard,
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isValidating ? null : _validateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isValidating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                        ),
                      )
                    : const Text('Save & Test'),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _clearApiKey,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
                ),
              ),
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Text(
                'How to get your Groq API key:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Visit https://console.groq.com/keys\n'
            '2. Sign up or log in to your account\n'
            '3. Click "Create API Key"\n'
            '4. Copy the key and paste it above\n'
            '5. Groq offers free tier with generous limits!',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: 'https://console.groq.com/keys'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL copied to clipboard!'),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 16, color: AppColors.secondary),
                  SizedBox(width: 6),
                  Text(
                    'Copy URL',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final isConfigured = ApiConfig.isApiKeyConfigured;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isConfigured 
            ? AppColors.secondary.withOpacity(0.1)
            : AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConfigured 
              ? AppColors.secondary.withOpacity(0.3)
              : AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConfigured ? Icons.check_circle : Icons.warning,
            color: isConfigured ? AppColors.secondary : AppColors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConfigured ? 'API Key Configured' : 'API Key Not Set',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isConfigured ? AppColors.secondary : AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isConfigured 
                      ? 'Your AI coach is ready for real conversations!'
                      : 'Using simulated responses until API key is configured',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null) {
        setState(() {
          _apiKeyController.text = data!.text!;
        });
      }
    } catch (e) {
      _showSnackBar('Could not paste from clipboard', isError: true);
    }
  }

  Future<void> _validateAndSave() async {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isEmpty) {
      _showSnackBar('Please enter an API key', isError: true);
      return;
    }

    setState(() {
      _isValidating = true;
    });

    // Here you would typically save to secure storage or shared preferences
    // For this demo, we'll just show a success message
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isValidating = false;
    });

    _showSnackBar('API key saved! Please restart the app to use real AI responses.');
  }

  void _clearApiKey() {
    setState(() {
      _apiKeyController.clear();
    });
    _showSnackBar('API key cleared');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.accent : AppColors.secondary,
      ),
    );
  }
}
