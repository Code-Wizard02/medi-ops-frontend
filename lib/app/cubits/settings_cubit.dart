import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs)
    : super(
        const SettingsState(themeMode: ThemeMode.system, locale: Locale('es')),
      ) {
    _loadSettings();
  }

  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  void _loadSettings() {
    final themeString = _prefs.getString(_themeKey);
    final localeString = _prefs.getString(_localeKey);

    ThemeMode themeMode = ThemeMode.system;
    if (themeString != null) {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    }

    Locale locale = const Locale('es');
    if (localeString != null) {
      locale = Locale(localeString);
    }

    emit(SettingsState(themeMode: themeMode, locale: locale));
  }

  Future<void> toggleTheme() async {
    final newTheme = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _prefs.setString(_themeKey, newTheme.toString());
    emit(state.copyWith(themeMode: newTheme));
  }

  Future<void> toggleLocale() async {
    final newLocale = state.locale.languageCode == 'es'
        ? const Locale('en')
        : const Locale('es');
    await _prefs.setString(_localeKey, newLocale.languageCode);
    emit(state.copyWith(locale: newLocale));
  }
}
