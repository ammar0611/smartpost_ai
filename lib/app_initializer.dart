import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/utils/preference.dart';
import 'firebase_options.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Pref.initialize();
  }
}
