import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'firebase_options.dart';

class AppInitializer {
  static PackageInfo? packageInfo;
  static Future<void> initialize() async {
    await getAppVersion();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Pref.initialize();
  }

  static Future<void> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }
}
