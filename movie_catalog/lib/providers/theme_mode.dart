import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeProvider, bool>((ref) {
  return ThemeModeProvider(
    ref,
    ref.read(sharedPreferencesProvider).getBool('theme_mode') ?? true,
  );
});

class ThemeModeProvider extends StateNotifier<bool> {
  final StateNotifierProviderRef ref;

  ThemeModeProvider(this.ref, super.state);

  void toggleTheme() {
    state = !state;

    ref.read(sharedPreferencesProvider).setBool('theme_mode', state);
  }
}