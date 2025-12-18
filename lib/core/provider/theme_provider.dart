import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  /// Default = system
  ThemeProvider({ThemeMode initialMode = ThemeMode.system})
    : _themeMode = initialMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  bool get isSystem => _themeMode == ThemeMode.system;

  void setLightMode() {
    if (_themeMode == ThemeMode.light) return;
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkMode() {
    if (_themeMode == ThemeMode.dark) return;
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setSystemMode() {
    if (_themeMode == ThemeMode.system) return;
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  /// 🔄 Toggle behavior:
  /// - If System → Light
  /// - Light → Dark
  /// - Dark → Light
  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
