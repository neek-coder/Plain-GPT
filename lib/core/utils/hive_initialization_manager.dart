import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveInitializationManager {
  static bool _initialized = false;

  /// Used to initialize Hive once in the entire app.
  static Future<void> init([String? subDir]) async {
    if (_initialized) return;

    await Hive.initFlutter(subDir);

    _initialized = true;
  }
}
