import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/app_configs.dart';

class AppInitializer {
  static Future<SharedPreferences> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // تهيئة الـ Firebase باستخدام الثوابت من الـ configs
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: AppConfigs.firebaseApiKey,
        authDomain: AppConfigs.firebaseAuthDomain,
        projectId: AppConfigs.firebaseProjectId,
        storageBucket: AppConfigs.firebaseStorageBucket,
        messagingSenderId: AppConfigs.firebaseMessagingSenderId,
        appId: AppConfigs.firebaseAppId,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}