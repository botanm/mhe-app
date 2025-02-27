import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/services/local_storage_service.dart';

class i18n with ChangeNotifier {
  /// to call "i18nInit()" method in App start you have to call it in "MyApp" class in "main.dart" OR run it in "loadInitialScreen"

  /// First Way
  //   void main() {
  //   i18n i18nInstance = i18n();
  //   runApp(MyApp(i18nInstance: i18nInstance));
  // }

  // class MyApp extends StatelessWidget {
  //   const MyApp({required this.i18nInstance, Key? key}) : super(key: key);
  //   final i18n i18nInstance;

  //   @override
  //   Widget build(BuildContext context) {
  //     i18nInstance.i18nInit();
  //     return MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => i18nInstance), // in Second Way => i18n()

  /// Second way
  // return Consumer<i18n>(builder: (_, i, __) {
  //     i.i18nInit(); // we didn't use "FutureBuilder" to call it
  //     return Directionality(
  //         textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
  //         child: initialScreen);
  //   });
  String _locale = 'ckb';
  bool _isRtl = true;
  late Map<String, String> _localizedTexts;
  bool isInit = false;

  static const List<Map<String, dynamic>> locales = [
    {
      "id": 1,
      "name": "Kurdish",
      "ckb_name": "کوردی",
      "ar_name": "كردي",
      "language_code": "ckb",
      "is_rtl": true,
      "is_active": true,
    },
    {
      "id": 2,
      "name": "English",
      "ckb_name": "ئینگلیزی",
      "ar_name": "الإنجليزية",
      "language_code": "en",
      "is_rtl": false,
      "is_active": true,
    },
    {
      "id": 3,
      "name": "Arabic",
      "ckb_name": "عەرەبی",
      "ar_name": "عربی",
      "language_code": "ar",
      "is_rtl": true,
      "is_active": true,
    }
  ];
  Map<String, List<String>> msu = {
    'en': ['fullNameEn', 'fullNameKu'],
    'ar': ['fullNameKu', 'fullNameEn'],
    'ckb': ['fullNameKu', 'fullNameEn'],
  };

  Map<String, List<String>> msb = {
    'en': ['name', 'ar_name'],
    'ar': ['ar_name', 'name'],
    'ckb': ['ckb_name', 'ar_name'],
  };

  Map<String, List<String>> msa = {
    'en': ['about', 'ar_name'],
    'ar': ['ar_about', 'about'],
    'ckb': ['ckb_about', 'about'],
  };

  Future<void> i18nInit() async {
    // await fetchLocale();
    await loadCurrentLocale();
  }

  String get locale => _locale;
  List<String> get maSecUserName => msu[locale] ?? ['fullNameKu', 'fullNameEn'];
  List<String> get maSecBasicName => msb[locale] ?? ['ckb_name', 'name'];
  List<String> get maSecAbout => msa[locale] ?? ['ckb_about', 'about'];
  bool get isRtl => _isRtl;
  bool getLocaleIsRtl(value) =>
      locales.firstWhere((e) => e['language_code'] == value)['is_rtl'];

  Future<void> fetchLocale() async {
    final String? l = LocalStorageService.getLocale();
    if (l == null) {
      LocalStorageService.setLocale(_locale);
    }
    _locale = l ?? _locale;
    _isRtl = getLocaleIsRtl(_locale);
  }

  Future<void> storageSetLocale(String locale) async {
    await LocalStorageService.setLocale(locale);
  }

  Future<void> loadCurrentLocale() async {
    // Load the language JSON file from the "assets/locales" folder
    String jsonString =
        await rootBundle.loadString('assets/locales/$_locale.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
///////////////////////////
    // LocalStorageService.setLocalizedTexts(jsonString);
    // jsonString = LocalStorageService.getLocalizedTexts() ?? jsonString;
    // jsonMap = jsonDecode(jsonString);
////////////////////////////
    _localizedTexts = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  Future<void> changeLocale(String newLocale) async {
    await storageSetLocale(newLocale);
    await fetchLocale();
    await loadCurrentLocale();
    notifyListeners();
  }

  String tr(String key) {
    return _localizedTexts[key]!;
  }
}
