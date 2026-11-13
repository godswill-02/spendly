import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart';

class LocaleService extends GetxService {
  static const supported = [Locale('fr'), Locale('en')];
  static const fallback = Locale('fr');

  final StorageService _storage = Get.find<StorageService>();

  late Locale _current;
  Locale get current => _current;

  /// True when the user never picked a language (follows the device).
  bool get followsDevice => _storage.read<String>(StorageService.languageKey) == null;

  Future<LocaleService> init() async {
    final saved = _storage.read<String>(StorageService.languageKey);
    _current = saved != null ? Locale(saved) : _resolve(Get.deviceLocale);
    Intl.defaultLocale = _current.toString();
    return this;
  }

  Locale _resolve(Locale? device) {
    if (device == null) return fallback;
    return supported.firstWhere(
          (l) => l.languageCode == device.languageCode,
      orElse: () => fallback,
    );
  }

  Future<void> change(Locale locale) async {
    _current = locale;
    Intl.defaultLocale = locale.toString();
    await _storage.write(StorageService.languageKey, locale.languageCode);
    Get.updateLocale(locale);
  }

  /// Forget the choice and follow the device again.
  Future<void> useDeviceLocale() async {
    await _storage.remove(StorageService.languageKey);
    final locale = _resolve(Get.deviceLocale);
    _current = locale;
    Intl.defaultLocale = locale.toString();
    Get.updateLocale(locale);
  }
}