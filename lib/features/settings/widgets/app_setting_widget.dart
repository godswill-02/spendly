import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/settings/controllers/app_setting_controller.dart';

class AppSettingWidget extends GetView<AppSettingsController> {
  const AppSettingWidget({super.key});

  String _themeLabel(ThemeMode m) => switch (m) {
    ThemeMode.system => 'theme_system'.tr,
    ThemeMode.light => 'theme_light'.tr,
    ThemeMode.dark => 'theme_dark'.tr,
  };

  String _languageLabel(String code) =>
      AppSettingsController.languageNames[code] ?? 'system_default'.tr;

  String _weekDayLabel(int day) => switch (day) {
    DateTime.sunday => 'sunday'.tr,
    DateTime.saturday => 'saturday'.tr,
    _ => 'monday'.tr,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => ListTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title: Text('theme'.tr),
          subtitle: Text(_themeLabel(controller.themeMode.value)),
          onTap: () => _showPicker<ThemeMode>(
            title: 'theme'.tr,
            options: ThemeMode.values,
            selected: controller.themeMode.value,
            labelOf: _themeLabel,
            onSelected: controller.setThemeMode,
          ),
        )),
        Obx(() => ListTile(
          leading: const Icon(Icons.language_rounded),
          title: Text('language'.tr),
          subtitle: Text(_languageLabel(controller.languageChoice.value)),
          onTap: () => _showPicker<String>(
            title: 'language'.tr,
            options: controller.languageOptions,
            selected: controller.languageChoice.value,
            labelOf: _languageLabel,
            onSelected: controller.setLanguage,
          ),
        )),
        Obx(() => ListTile(
          leading: const Icon(Icons.payments_outlined),
          title: Text('currency'.tr),
          subtitle: Text(
              '${controller.currency.code} (${controller.currency.symbol})'),
          onTap: () => _showPicker<String>(
            title: 'currency'.tr,
            options: [
              for (final c in AppSettingsController.currencies) c.code
            ],
            selected: controller.currencyCode.value,
            labelOf: (code) {
              final c = AppSettingsController.currencies
                  .firstWhere((c) => c.code == code);
              return '${c.code} (${c.symbol})';
            },
            onSelected: controller.setCurrency,
          ),
        )),
        Obx(() => ListTile(
          leading: const Icon(Icons.calendar_view_week_rounded),
          title: Text('first_day_of_week'.tr),
          subtitle: Text(_weekDayLabel(controller.firstDayOfWeek.value)),
          onTap: () => _showPicker<int>(
            title: 'first_day_of_week'.tr,
            options: AppSettingsController.weekStarts,
            selected: controller.firstDayOfWeek.value,
            labelOf: _weekDayLabel,
            onSelected: controller.setFirstDayOfWeek,
          ),
        )),
      ],
    );
  }

  /// Simple single-choice dialog: a check mark shows the current value.
  Future<void> _showPicker<T>({
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T) labelOf,
    required ValueChanged<T> onSelected,
  }) {
    return Get.dialog(
      SimpleDialog(
        title: Text(title),
        children: [
          for (final option in options)
            ListTile(
              title: Text(labelOf(option)),
              trailing: option == selected ? const Icon(Icons.check_rounded) : null,
              onTap: () {
                Get.back();
                onSelected(option);
              },
            ),
        ],
      ),
    );
  }
}