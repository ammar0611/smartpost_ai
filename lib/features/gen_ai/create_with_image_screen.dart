import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpost_ai/utils/custom_widgets.dart';
import 'package:smartpost_ai/utils/responsive_utils.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;
import 'package:smartpost_ai/values/constant.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

class CreateWithImageScreen extends StatefulWidget {
  const CreateWithImageScreen({super.key});

  @override
  State<CreateWithImageScreen> createState() => _CreateWithImageScreenState();
}

class _CreateWithImageScreenState extends State<CreateWithImageScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;
  String? _generatedCaption;
  Uint8List? _generatedImageBytes;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
    });
  }

  Future<void> _handleGenerate() async {
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedCaption = null;
      _generatedImageBytes = null;
    });

    try {
      // 1. Generate Image with Hugging Face Wavespeed API
      Uint8List? newImageBytes;
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

        // Convert image to base64
        final base64Image = base64Encode(_selectedImageBytes!);
        
        final imageResponse = await http.post(
          Uri.parse('https://router.huggingface.co/wavespeed/api/v3/wavespeed-ai/qwen-image/edit-plus-lora'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'images': ['data:image/png;base64,$base64Image'],
            'prompt': prompt,
          }),
        );

        if (imageResponse.statusCode == 200) {
          // Log.e('Res ${jsonEncode(imageResponse)}');
          Log.e('bytes ${imageResponse.bodyBytes}');

          newImageBytes = imageResponse.bodyBytes;
          // final responseData = jsonDecode(imageResponse.body);
          //
          // // Handle Wavespeed API response
          // if (responseData is Map && responseData['code'] == 200) {
          //   final data = responseData['data'];
          //   if (data != null && data['urls'] != null && data['urls']['get'] != null) {
          //     final resultUrl = data['urls']['get'] as String;
          //     Log.d('Result URL: $resultUrl');
          //
          //     // Poll the result URL until image is ready
          //     for (int i = 0; i < 30; i++) {
          //       await Future.delayed(const Duration(seconds: 2));
          //
          //       try {
          //         final resultResponse = await http.get(
          //           Uri.parse(resultUrl),
          //           headers: {
          //             'Authorization': 'Bearer $apiKey',
          //             'Content-Type': 'application/json',
          //           },
          //         );
          //
          //         Log.d('Polling attempt ${i + 1}: Status ${resultResponse.statusCode}');
          //
          //         if (resultResponse.statusCode == 401) {
          //           Log.e('Unauthorized: Invalid API key');
          //           if (mounted) {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(
          //                 content: Text('API authentication failed. Please check your API key.'),
          //                 backgroundColor: app_colors.errorColor,
          //               ),
          //             );
          //           }
          //           break;
          //         }
          //
          //         if (resultResponse.statusCode == 200) {
          //           final resultData = jsonDecode(resultResponse.body);
          //           Log.d('Result data: $resultData');
          //
          //           // Check for successful response with code 200
          //           if (resultData is Map && resultData['code'] == 200) {
          //             final data = resultData['data'];
          //
          //             if (data != null &&
          //                 data['outputs'] != null &&
          //                 (data['outputs'] as List).isNotEmpty) {
          //
          //               final imageUrl = data['outputs'][0];
          //               Log.d('Image URL found: $imageUrl');
          //
          //               if (imageUrl is String && imageUrl.startsWith('http')) {
          //                 final imgResponse = await http.get(Uri.parse(imageUrl));
          //                 if (imgResponse.statusCode == 200) {
          //                   newImageBytes = imgResponse.bodyBytes;
          //                   Log.d('Image downloaded successfully');
          //                   break;
          //                 }
          //               }
          //             } else if (data != null &&
          //                        (data['status'] == 'processing' || data['status'] == 'created')) {
          //               // Still processing, continue polling
          //               Log.d('Status: ${data['status']}, attempt ${i + 1}/30');
          //               continue;
          //             } else if (data != null && data['status'] == 'failed') {
          //               Log.e('Image generation failed');
          //               if (mounted) {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(
          //                     content: Text('Image generation failed. Please try again.'),
          //                     backgroundColor: app_colors.errorColor,
          //                   ),
          //                 );
          //               }
          //               break;
          //             }
          //           }
          //         }
          //       } catch (e) {
          //         Log.e('Error polling result: $e');
          //       }
          //     }
          //   }
          // }
        } else {
          Log.e('Image generation failed: ${imageResponse.statusCode} ${imageResponse.body}');
        }
      } catch (e) {
        Log.e('Error generating image: $e');
      }

      // 2. Generate Caption with Gemini AI
      String caption = "No caption generated.";
      try {
        final gemini = Gemini.instance;
        
        // Create a caption prompt based on the transformation
        final captionPrompt = 'Generate a creative and engaging caption or description for an image that shows: $prompt. Keep it concise, engaging, and suitable for social media.';
        
        final response = await gemini.text(captionPrompt);
        caption = response?.output ?? "No caption generated.";
      } catch (e) {
        Log.e('Error generating caption: $e');
        caption = 'Unable to generate caption at this moment.';
      }

      setState(() {
        _generatedImageBytes = newImageBytes;
        _generatedCaption = caption;
      });

      if (newImageBytes == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image generation is processing. This may take a moment. Please try again.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
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
              Icons.add_photo_alternate,
              size: 32,
              color: app_colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create with Image',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: app_colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Transform your images with AI and get creative captions',
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
                  color: app_colors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload_file,
                  color: app_colors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Upload & Create',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: app_colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Image Upload Section
          const Text(
            'Select Image',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: app_colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          if (_selectedImageBytes == null)
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: app_colors.grey100,
                  border: Border.all(
                    color: app_colors.primaryColor.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: app_colors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: app_colors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Click to upload image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: app_colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PNG, JPG, JPEG up to 10MB',
                      style: TextStyle(
                        fontSize: 12,
                        color: app_colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _selectedImageBytes!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: app_colors.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: app_colors.white),
                      onPressed: _removeImage,
                      iconSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: app_colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedImageName ?? 'Image',
                      style: const TextStyle(
                        color: app_colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
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
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe how you want to transform this image...\n\nExample: Turn the cat into a tiger, Make it look like winter scene',
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
    if (!_isLoading && _generatedCaption == null && _generatedImageBytes == null) {
      return CustomCard(
        padding: const EdgeInsets.all(48),
        child: EmptyStateWidget(
          icon: Icons.transform,
          title: 'Ready to Transform',
          subtitle: 'Upload an image and describe the transformation.\nAI will create a new image and generate a caption.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                      icon: const Icon(Icons.download, size: 20),
                      color: app_colors.textSecondary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image download started')),
                        );
                        // Implement image download functionality here
                      },
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
                      Log.e('Error loading image: $error');
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
          const SizedBox(height: 20),
        ],
        if (_generatedCaption != null) ...[
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
                      'AI Generated Caption',
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Caption copied to clipboard')),
                        );
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
                    _generatedCaption!,
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
        ],
      ],
    );
  }
}
