import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartpost_ai/features/gen_ai/gen_ai_screen.dart';
import 'package:smartpost_ai/utils/routes.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:provider/provider.dart';
import 'app_initializer.dart';
import 'app_provider.dart';

Future<void> main() async {
  Gemini.init(apiKey: Constant.geminiApiKey2);
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize(); // Call your app initialization method
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(100),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          },
          child: Consumer<AppProvider>(builder: (context, provider, child) {
            return Stack(
              children: [
                MaterialApp(
                  // scrollBehavior: const MaterialScrollBehavior().copyWith(
                  //   dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
                  // ),
                    theme: ThemeData(
                      fontFamily: 'OpenSans',
                    ),
                    // locale: Locale(provider.appLanguage ?? 'en'),
                    debugShowCheckedModeBanner: false,
                    // initialRoute: Constant.homePage,  // MAIN APP ROUTE
                    home: const GenAiScreen(),
                    color: Colors.black,
                    onGenerateRoute: (settings) {
                      return Routes.generateRoutes(settings);
                    }),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      // 'Version: ${provider.packageInfo?.version ?? ''} + ${provider.packageInfo?.buildNumber ?? ''}',
                      '',
                      style: TextStyle(color: Colors.black, fontSize: 8),
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
