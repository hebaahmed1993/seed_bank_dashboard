import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/shared_preferences_service.dart';

// تفعيل خدمة التخزين وحقنها عبر Riverpod
final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) {
  throw UnimplementedError('SharedPreferencesService must be initialized in main()');
});
