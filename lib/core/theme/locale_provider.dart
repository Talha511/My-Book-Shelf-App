import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

const List<AppLanguage> supportedLanguages = [
  AppLanguage(code: 'en', name: 'English',  nativeName: 'English',    flag: '🇬🇧'),
  AppLanguage(code: 'ar', name: 'Arabic',   nativeName: 'العربية',    flag: '🇸🇦'),
  AppLanguage(code: 'ur', name: 'Urdu',     nativeName: 'اردو',       flag: '🇵🇰'),
  AppLanguage(code: 'fr', name: 'French',   nativeName: 'Français',   flag: '🇫🇷'),
  AppLanguage(code: 'es', name: 'Spanish',  nativeName: 'Español',    flag: '🇪🇸'),
  AppLanguage(code: 'tr', name: 'Turkish',  nativeName: 'Türkçe',     flag: '🇹🇷'),
];
