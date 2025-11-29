import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartpost_ai/features/home/home_screen.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/utils/routes.dart';
import 'package:smartpost_ai/utils/theme_data.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;
import 'package:provider/provider.dart';
import 'app_initializer.dart';
import 'app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize(); // Call your app initialization method

  String apiKey = Constant.geminiApiKey;
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('currentGeminiApiKey')
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      if (data.containsKey('apiKey')) {
        apiKey = data['apiKey'];
      }
    }
  } catch (e) {
    debugPrint('Error fetching Gemini API key: $e');
  }
  Log.e('Using Gemini API Key: $apiKey');
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayColor: Colors.black.withOpacity(0.5),
          overlayWidgetBuilder: (_) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: app_colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(app_colors.primaryColor),
                ),
              ),
            );
          },
          child: Consumer<AppProvider>(builder: (context, provider, child) {
            return Stack(
              children: [
                MaterialApp(
                    title: 'SmartPost AI',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: ThemeMode.light,
                    debugShowCheckedModeBanner: false,
                    home: const HomeScreen(),
                    onGenerateRoute: (settings) {
                      return Routes.generateRoutes(settings);
                    }),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: app_colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'v${AppInitializer.packageInfo?.version ?? ''}+${AppInitializer.packageInfo?.buildNumber ?? ''}',
                      style: const TextStyle(
                        color: app_colors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
