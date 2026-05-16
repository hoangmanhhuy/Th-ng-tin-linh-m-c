import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'vi';

  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  bool get isEnglish => _languageCode == 'en';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('app_lang') ?? 'vi';
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', code);
    notifyListeners();
  }
}
