import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpost_ai/features/settings/settings_screen.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/utils/custom_widgets.dart';
import 'package:smartpost_ai/utils/responsive_utils.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class GenAiScreen extends StatefulWidget {
  final bool showAppBar;
  
  const GenAiScreen({super.key, this.showAppBar = true});

  @override
  State<GenAiScreen> createState() => _GenAiScreenState();
}

class _GenAiScreenState extends State<GenAiScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  String? _generatedText;
  Uint8List? _generatedImageBytes;

  final Map<String, String> _models = {
    'FLUX.1 Schnell': 'https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell',
    'FLUX.1 Dev': 'https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-dev',
    'Stable Diffusion XL': 'https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-xl-base-1.0',
  };

  late String _selectedModelUrl;

  @override
  void initState() {
    super.initState();
    _selectedModelUrl = _models.values.first;
  }

  Future<void> _handleGenerate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedText = null;
      _generatedImageBytes = null;
    });

    try {
      // 1. Generate Caption with Gemini
      final gemini = Gemini.instance;
      final captionPrompt = 'Create an engaging social media caption for: "$prompt". Include emojis and 3-5 hashtags. Keep it short (2-3 sentences). Provide only the caption.';
      
      String text = "No caption generated.";
      try {
        final textResponse = await gemini.text(captionPrompt);
        text = textResponse?.output ?? "No caption generated.";
      } catch (geminiError) {
        Log.e('Gemini API error: $geminiError');
        text = "Caption generation failed. Please check your Gemini API key in Firebase.";
      }

      // 2. Generate Image with Hugging Face
      Uint8List? imageBytes;
      try {
        String apiKey = Pref.getValue('hf_api_key');
        if (apiKey.isEmpty) {
          try {
            final snapshot = await FirebaseFirestore.instance
                .collection('currentHfApiKey')
                .limit(1)
                .get();
            if (snapshot.docs.isNotEmpty) {
              apiKey = snapshot.docs.first.data()['apiKey'] as String? ?? '';
            }
          } catch (e) {
            Log.e('Error fetching current API key: $e');
          }
        }

        if (apiKey.isEmpty) {
          apiKey = Constant.HFApiKey;
        }

        final imageResponse = await http.post(
          Uri.parse(_selectedModelUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'inputs': prompt}),
        );

        if (imageResponse.statusCode == 200) {
          imageBytes = imageResponse.bodyBytes;
        } else {
          Log.e('Image generation failed: ${imageResponse.statusCode} ${imageResponse.body}');
        }
      } catch (e) {
        Log.e('Error generating image: $e');
      }

      setState(() {
        _generatedText = text;
        _generatedImageBytes = imageBytes;
      });
    } catch (e) {
      Log.e('Error during generation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _downloadImage() {
    if (_generatedImageBytes == null) return;
    
    try {
      final blob = html.Blob([_generatedImageBytes!], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'smartpost_ai_${DateTime.now().millisecondsSinceEpoch}.png')
        ..click();
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: app_colors.white),
              SizedBox(width: 12),
              Text('Image downloaded successfully!'),
            ],
          ),
          backgroundColor: app_colors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      Log.e('Error downloading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading image: $e'),
          backgroundColor: app_colors.errorColor,
        ),
      );
    }
  }

  void _showShareDialog() {
    if (_generatedImageBytes == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share to Social Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: app_colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Download the image first, then share it on your favorite platform',
              style: TextStyle(
                fontSize: 13,
                color: app_colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  onTap: () => _shareToSocialMedia('facebook'),
                ),
                _buildShareOption(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  color: const Color(0xFFE4405F),
                  onTap: () => _shareToSocialMedia('instagram'),
                ),
                _buildShareOption(
                  icon: Icons.alternate_email,
                  label: 'Twitter/X',
                  color: const Color(0xFF000000),
                  onTap: () => _shareToSocialMedia('twitter'),
                ),
                _buildShareOption(
                  icon: Icons.link,
                  label: 'LinkedIn',
                  color: const Color(0xFF0A66C2),
                  onTap: () => _shareToSocialMedia('linkedin'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _shareToSocialMedia('whatsapp'),
                ),
                _buildShareOption(
                  icon: Icons.telegram,
                  label: 'Telegram',
                  color: const Color(0xFF0088CC),
                  onTap: () => _shareToSocialMedia('telegram'),
                ),
                _buildShareOption(
                  icon: Icons.pin_drop_rounded,
                  label: 'Pinterest',
                  color: const Color(0xFFBD081C),
                  onTap: () => _shareToSocialMedia('pinterest'),
                ),
                _buildShareOption(
                  icon: Icons.download,
                  label: 'Download',
                  color: app_colors.primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    _downloadImage();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: app_colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareToSocialMedia(String platform) {
    Navigator.pop(context);
    
    // First download the image
    _downloadImage();
    
    // Open the social media platform
    String url = '';
    String message = _generatedText ?? 'Check out this AI-generated image!';
    String encodedMessage = Uri.encodeComponent(message);
    
    switch (platform) {
      case 'facebook':
        url = 'https://www.facebook.com/';
        break;
      case 'instagram':
        url = 'https://www.instagram.com/';
        break;
      case 'twitter':
        url = 'https://twitter.com/intent/tweet?text=$encodedMessage';
        break;
      case 'linkedin':
        url = 'https://www.linkedin.com/feed/';
        break;
      case 'whatsapp':
        url = 'https://web.whatsapp.com/';
        break;
      case 'telegram':
        url = 'https://web.telegram.org/';
        break;
      case 'pinterest':
        url = 'https://www.pinterest.com/';
        break;
    }
    
    if (url.isNotEmpty) {
      html.window.open(url, '_blank');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: app_colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Image downloaded! Upload it to ${platform.capitalize()} to share.'),
              ),
            ],
          ),
          backgroundColor: app_colors.infoColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      backgroundColor: app_colors.bgSecondary,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: app_colors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: app_colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'SmartPost AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          _buildInputSection(),
          const SizedBox(height: 24),
          _buildResultSection(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: MaxWidthContainer(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 32),
            _buildInputSection(),
            const SizedBox(height: 32),
            _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: MaxWidthContainer(
        maxWidth: 1400,
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 48),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildInputSection(),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 7,
                    child: _buildResultSection(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: app_colors.accentGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 32,
              color: app_colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI-Powered Content Creator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: app_colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate engaging text and stunning images with advanced AI',
            style: TextStyle(
              fontSize: 14,
              color: app_colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: app_colors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.brush,
                  color: app_colors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Create Content',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: app_colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Image Model',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: app_colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown<String>(
            value: _selectedModelUrl,
            hint: 'Select Image Model',
            prefixIcon: Icons.image,
            items: _models.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedModelUrl = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Prompt',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: app_colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _promptController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Describe what you want to create...\n\nExample: A futuristic city with flying cars at sunset',
              hintStyle: TextStyle(color: app_colors.textLight, fontSize: 14),
              filled: true,
              fillColor: app_colors.grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: app_colors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: app_colors.primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Generate Content',
            icon: Icons.auto_awesome,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleGenerate,
            height: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    if (!_isLoading && _generatedText == null && _generatedImageBytes == null) {
      return CustomCard(
        padding: const EdgeInsets.all(48),
        child: EmptyStateWidget(
          icon: Icons.auto_awesome_outlined,
          title: 'Ready to Create',
          subtitle: 'Your AI-generated content will appear here.\nEnter a prompt and click generate to start.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_generatedText != null) ...[
          CustomCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: app_colors.infoColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.text_fields,
                        color: app_colors.infoColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Generated Text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: app_colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      color: app_colors.textSecondary,
                      onPressed: () {
                        if (_generatedText != null) {
                          Clipboard.setData(ClipboardData(text: _generatedText!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: app_colors.white),
                                  SizedBox(width: 12),
                                  Text('Text copied to clipboard!'),
                                ],
                              ),
                              backgroundColor: app_colors.successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      tooltip: 'Copy to clipboard',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: app_colors.grey100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: app_colors.grey300),
                  ),
                  child: SelectableText(
                    _generatedText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: app_colors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (_generatedImageBytes != null) ...[
          CustomCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: app_colors.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: app_colors.accentColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Generated Image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: app_colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share, size: 20),
                      color: app_colors.textSecondary,
                      onPressed: _showShareDialog,
                      tooltip: 'Share to social media',
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, size: 20),
                      color: app_colors.textSecondary,
                      onPressed: _downloadImage,
                      tooltip: 'Download image',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _generatedImageBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: app_colors.grey200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48, color: app_colors.errorColor),
                              SizedBox(height: 8),
                              Text(
                                'Error loading image',
                                style: TextStyle(color: app_colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
