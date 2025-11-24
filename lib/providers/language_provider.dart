import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  // Cargar el idioma guardado
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'es';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Cambiar el idioma y guardarlo
  Future<void> setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
      notifyListeners();
    }
  }
}
