import 'package:hive/hive.dart';
import 'package:my_gpt_client/core/utils/hive_initialization_manager.dart';

final class StartCountRepository {
  static const _boxKey = 'start-count-box';
  static const _contentKey = 'is-first-start';

  late final Box _box;

  bool _initialized = false;

  bool get isFirstStart => _box.get(_contentKey) ?? true;

  Future<void> init() async {
    if (_initialized) return;

    await HiveInitializationManager.init();

    _box = await Hive.openBox(_boxKey);

    _initialized = true;
  }

  Future<void> registerTermination() async {
    if (!_initialized) {
      throw Exception('StartCountRepository has not been initialized');
    }

    await _box.put(_contentKey, false);
  }
}
