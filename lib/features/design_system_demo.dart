import 'package:flutter/material.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;

/// Demo screen to showcase the design system components
class DesignSystemDemo extends StatelessWidget {
  const DesignSystemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.bgSecondary,
      appBar: AppBar(
        title: const Text('Design System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Colors', _buildColorPalette()),
            const SizedBox(height: 32),
            _buildSection('Typography', _buildTypography()),
            const SizedBox(height: 32),
            _buildSection('Buttons', _buildButtons()),
            const SizedBox(height: 32),
            _buildSection('Cards', _buildCards()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildColorPalette() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _colorItem('Primary', app_colors.primaryColor),
        _colorItem('Primary Dark', app_colors.primaryDark),
        _colorItem('Primary Light', app_colors.primaryLight),
        _colorItem('Secondary', app_colors.secondaryColor),
        _colorItem('Accent', app_colors.accentColor),
        _colorItem('Success', app_colors.successColor),
        _colorItem('Error', app_colors.errorColor),
        _colorItem('Info', app_colors.infoColor),
        _colorItem('Warning', app_colors.warningColor),
      ],
    );
  }

  Widget _colorItem(String name, Color color) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: app_colors.textPrimary,
            ),
          ),
          Text(
            '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
            style: const TextStyle(
              fontSize: 10,
              color: app_colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Display Large',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Display Medium',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Headline Medium',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Title Large - This is standard title text',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Body Large - This is the standard body text used throughout the application.',
          style: TextStyle(
            fontSize: 16,
            color: app_colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Body Medium - This is secondary body text for less important information.',
          style: TextStyle(
            fontSize: 14,
            color: app_colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Body Small - Caption and helper text',
          style: TextStyle(
            fontSize: 12,
            color: app_colors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: app_colors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: app_colors.primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Gradient Button',
              style: TextStyle(
                color: app_colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: app_colors.primaryColor,
            foregroundColor: app_colors.white,
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Elevated Button'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Outlined Button'),
        ),
      ],
    );
  }

  Widget _buildCards() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: app_colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: app_colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: app_colors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This is a standard card component with shadow and rounded corners.',
                style: TextStyle(
                  fontSize: 14,
                  color: app_colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: app_colors.infoColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: app_colors.infoColor.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: app_colors.infoColor),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Info Card - Used for informational messages',
                  style: TextStyle(
                    fontSize: 14,
                    color: app_colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
