import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage_service.dart';

class ThemeService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  Future<ThemeService> init() async {
    final saved = _storage.read<String>(StorageService.themeModeKey);
    mode.value = ThemeMode.values.firstWhere(
          (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
    return this;
  }

  Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;
    Get.changeThemeMode(newMode);
    await _storage.write(StorageService.themeModeKey, newMode.name);
  }
}