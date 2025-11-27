import 'package:flutter/material.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;
import 'package:smartpost_ai/utils/responsive_utils.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      width: isMobile ? double.infinity : 280,
      decoration: BoxDecoration(
        color: app_colors.white,
        boxShadow: [
          BoxShadow(
            color: app_colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: app_colors.primaryGradient,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: app_colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
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
                        'SmartPost AI',
                        style: TextStyle(
                          color: app_colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Content Creator',
                        style: TextStyle(
                          color: app_colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.edit_note,
                  title: 'Create with Prompt',
                  subtitle: 'Text & Image from prompt',
                  index: 0,
                  isSelected: selectedIndex == 0,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.add_photo_alternate,
                  title: 'Create with Image',
                  subtitle: 'Generate from image',
                  index: 1,
                  isSelected: selectedIndex == 1,
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: app_colors.grey300),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: app_colors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: app_colors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'AI-Powered\nContent Generation',
                    style: TextStyle(
                      fontSize: 11,
                      color: app_colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: app_colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? app_colors.primaryColor.withOpacity(0.1)
                  : app_colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? app_colors.primaryColor.withOpacity(0.3)
                    : app_colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? app_colors.primaryColor
                        : app_colors.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? app_colors.white : app_colors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? app_colors.primaryColor
                              : app_colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? app_colors.primaryColor.withOpacity(0.7)
                              : app_colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: app_colors.primaryColor,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
