import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _currentLocale; 

  Locale? get currentLocale => _currentLocale;


  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners(); 
  }
}
