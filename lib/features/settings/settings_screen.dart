import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'package:smartpost_ai/utils/custom_widgets.dart';
import 'package:smartpost_ai/utils/responsive_utils.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedApiKey;
  List<Map<String, String>> _apiKeys = []; // List of {name, apiKey}
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
          .map((doc) {
            final data = doc.data();
            final apiKey = data['apiKey'] as String?;
            final name = data['name'] as String? ?? 'Unnamed Key';
            if (apiKey != null && apiKey.isNotEmpty) {
              return {'name': name, 'apiKey': apiKey};
            }
            return null;
          })
          .where((item) => item != null)
          .cast<Map<String, String>>()
          .toList();

      // Get currently saved key
      String savedKey = Pref.getValue('hf_api_key');
      if (savedKey.isEmpty) {
        savedKey = Constant.HFApiKey;
      }

      // Ensure saved key is in the list (or add it if it's the default constant and not in DB)
      final keyExists = keys.any((item) => item['apiKey'] == savedKey);
      if (!keyExists && savedKey.isNotEmpty) {
        keys.add({'name': 'Default Key', 'apiKey': savedKey});
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
        _apiKeys = [{'name': 'Default Key', 'apiKey': savedKey}];
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
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: app_colors.white),
              SizedBox(width: 12),
              Text('API Key updated successfully'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.bgSecondary,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(app_colors.primaryColor),
              ),
            )
          : SingleChildScrollView(
              child: ResponsivePadding(
                child: MaxWidthContainer(
                  maxWidth: 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 24),
                      _buildApiKeySection(),
                      const SizedBox(height: 24),
                      _buildInfoSection(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: app_colors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings,
              color: app_colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: app_colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Configure your SmartPost AI preferences',
                  style: TextStyle(
                    fontSize: 14,
                    color: app_colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeySection() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.key,
                  color: app_colors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hugging Face API Key',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: app_colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: app_colors.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: app_colors.infoColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: app_colors.infoColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Select an API key to use for AI image generation',
                    style: TextStyle(
                      fontSize: 13,
                      color: app_colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Active API Key',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: app_colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown<String>(
            value: _selectedApiKey,
            hint: 'Select API Key',
            prefixIcon: Icons.vpn_key,
            items: _apiKeys.map((Map<String, String> item) {
              final name = item['name'] ?? 'Unnamed';
              final apiKey = item['apiKey'] ?? '';
              final displayText = '$name (${apiKey.length > 15 ? '${apiKey.substring(0, 15)}...' : apiKey})';
              return DropdownMenuItem<String>(
                value: apiKey,
                child: Text(
                  displayText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: _onApiKeyChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: app_colors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info,
                  color: app_colors.secondaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About API Keys',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: app_colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.check_circle_outline,
            'API keys are securely stored in Firestore',
            app_colors.successColor,
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            Icons.shield_outlined,
            'Your keys are encrypted and protected',
            app_colors.infoColor,
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            Icons.swap_horiz,
            'Switch between different keys anytime',
            app_colors.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: app_colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
