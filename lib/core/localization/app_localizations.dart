import 'package:flutter/material.dart';
import 'en.dart'; // Importar textos en inglés
import 'es.dart'; // Importar textos en español

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Mapa de idiomas
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': en, // Textos en inglés
    'es': es, // Textos en español
  };

  // Método para traducir
  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
