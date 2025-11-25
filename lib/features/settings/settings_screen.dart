import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'package:smartpost_ai/values/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedApiKey;
  List<String> _apiKeys = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApiKeys();
  }

  Future<void> _loadApiKeys() async {
    try {
      // Fetch from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('huggingFaceApiKeys')
          .get();

      final keys = snapshot.docs
          .map((doc) => doc.data()['apiKey'] as String?)
          .where((key) => key != null && key.isNotEmpty)
          .cast<String>()
          .toList();

      // Get currently saved key
      String savedKey = Pref.getValue('hf_api_key');
      if (savedKey.isEmpty) {
        savedKey = Constant.HFApiKey;
      }

      // Ensure saved key is in the list (or add it if it's the default constant and not in DB)
      if (!keys.contains(savedKey) && savedKey.isNotEmpty) {
        keys.add(savedKey);
      }

      setState(() {
        _apiKeys = keys;
        _selectedApiKey = savedKey;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading API keys: $e');
      setState(() {
        _isLoading = false;
        // Fallback to current saved or default
        String savedKey = Pref.getValue('hf_api_key');
        if (savedKey.isEmpty) savedKey = Constant.HFApiKey;
        _apiKeys = [savedKey];
        _selectedApiKey = savedKey;
      });
    }
  }

  Future<void> _onApiKeyChanged(String? newValue) async {
    if (newValue != null) {
      setState(() {
        _selectedApiKey = newValue;
      });
      Pref.setValue('hf_api_key', newValue);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API Key updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hugging Face API Key',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select an API key to use for image generation.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedApiKey,
                        isExpanded: true,
                        hint: const Text('Select API Key'),
                        items: _apiKeys.map((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _onApiKeyChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
