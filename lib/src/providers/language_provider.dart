import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('pt');
  
  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('pt'), 
    Locale('es'),
  ];
  
  static const Map<String, String> languageNames = {
    'en': 'English',
    'pt': 'Português',
    'es': 'Español',
  };
  
  void setLanguage(String languageCode) {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }
  
  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _currentLocale = locale;
      notifyListeners();
    }
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }
  
  bool isLanguageSupported(String languageCode) {
    return supportedLocales.any((locale) => locale.languageCode == languageCode);
  }
}