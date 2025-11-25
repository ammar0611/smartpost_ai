import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpost_ai/features/settings/settings_screen.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class GenAiScreen extends StatefulWidget {
  const GenAiScreen({super.key});

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
      // 1. Generate Text with Gemini
      final gemini = Gemini.instance;
      final textResponse = await gemini.text(prompt);
      final text = textResponse?.output ?? "No text generated.";

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gen AI Creator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > Constant.breakPoint_800) {
            return _buildWebLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputSection(),
          const SizedBox(height: 20),
          _buildResultSection(),
        ],
      ),
    );
  }

  Widget _buildWebLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildInputSection(),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 1,
              child: _buildResultSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedModelUrl,
              isExpanded: true,
              hint: const Text('Select Model'),
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
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter your prompt here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleGenerate,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Generate Content'),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    if (!_isLoading && _generatedText == null && _generatedImageBytes == null) {
      return const Center(
        child: Text(
          'Your generated content will appear here.',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_generatedText != null) ...[
            const Text(
              'Generated Text:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(_generatedText!),
            ),
            const SizedBox(height: 20),
          ],
          if (_generatedImageBytes != null) ...[
            const Text(
              'Generated Image:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _generatedImageBytes!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
