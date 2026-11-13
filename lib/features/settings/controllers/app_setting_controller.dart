import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/services/currency_service.dart';
import 'package:spendly/core/services/locale_service.dart';
import 'package:spendly/core/services/storage_service.dart';
import 'package:spendly/core/services/theme_service.dart';

/// UI-facing controller for the app settings.
/// Theme and language are delegated to [ThemeService] / [LocaleService];
/// currency and first day of the week are persisted through [StorageService].
class AppSettingsController extends GetxController {
  static const systemLanguage = 'system';

  /// Native names, so a user can always find their language.
  static const languageNames = {
    'fr': 'Français',
    'en': 'English',
  };

  static const currencies = CurrencyService.currencies;

  /// Days a week can start on (DateTime constants).
  static const weekStarts = [DateTime.monday, DateTime.sunday, DateTime.saturday];

  final _theme = Get.find<ThemeService>();
  final _locale = Get.find<LocaleService>();
  final _storage = Get.find<StorageService>();
  final _fx = Get.find<CurrencyService>();

  // Theme: reactive state lives in ThemeService.
  Rx<ThemeMode> get themeMode => _theme.mode;

  // LocaleService isn't reactive, so we mirror its state here.
  final languageChoice = systemLanguage.obs;

  final currencyCode = 'XOF'.obs;
  final firstDayOfWeek = DateTime.monday.obs;

  AppCurrency get currency =>
      currencies.firstWhere((c) => c.code == currencyCode.value,
          orElse: () => currencies.first);

  /// 'system' first, then every language the app supports.
  List<String> get languageOptions => [
    systemLanguage,
    for (final l in LocaleService.supported) l.languageCode,
  ];

  @override
  void onInit() {
    super.onInit();

    languageChoice.value =
    _locale.followsDevice ? systemLanguage : _locale.current.languageCode;

    final cur = _storage.read<String>(StorageService.currencyKey);
    if (currencies.any((c) => c.code == cur)) currencyCode.value = cur!;

    final week = _storage.read<int>(StorageService.firstDayOfWeekKey);
    if (weekStarts.contains(week)) firstDayOfWeek.value = week!;
  }

  Future<void> setThemeMode(ThemeMode mode) => _theme.setMode(mode);

  Future<void> setLanguage(String code) async {
    languageChoice.value = code;
    if (code == systemLanguage) {
      await _locale.useDeviceLocale();
    } else {
      await _locale.change(Locale(code));
    }
  }

  Future<void> setCurrency(String code) async {
    currencyCode.value = code;
    await _storage.write(StorageService.currencyKey, code);
    _fx.ensureFresh(); // make sure we have rates for the new currency
  }

  Future<void> setFirstDayOfWeek(int day) async {
    firstDayOfWeek.value = day;
    await _storage.write(StorageService.firstDayOfWeekKey, day);
  }
}