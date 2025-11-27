import 'package:flutter/material.dart';
import 'package:smartpost_ai/features/gen_ai/gen_ai_screen.dart';
import 'package:smartpost_ai/features/gen_ai/create_with_image_screen.dart';
import 'package:smartpost_ai/features/settings/settings_screen.dart';
import 'package:smartpost_ai/utils/sidebar_menu.dart';
import 'package:smartpost_ai/utils/responsive_utils.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const GenAiScreen(showAppBar: false),
    const CreateWithImageScreen(),
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Close drawer on mobile after selection
    if (Responsive.isMobile(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

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
        leading: isMobile
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
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
      drawer: isMobile
          ? Drawer(
              child: SidebarMenu(
                selectedIndex: _selectedIndex,
                onItemSelected: _onMenuItemSelected,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            SidebarMenu(
              selectedIndex: _selectedIndex,
              onItemSelected: _onMenuItemSelected,
            ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
