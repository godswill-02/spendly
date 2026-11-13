import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/settings/controllers/settings_controller.dart';
import 'package:spendly/features/settings/widgets/app_setting_widget.dart';
import 'package:spendly/features/settings/widgets/categories_sheet.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        _SectionHeader('app_settings'),
        const AppSettingWidget(),
        const Divider(height: 32),
        _SectionHeader('data'),
        ListTile(
          leading: Icon(
            Icons.category_outlined,
            color: theme.colorScheme.primary,
          ),
          title: Text('categories'.tr),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Get.bottomSheet(
            const CategoriesSheet(),
            isScrollControlled: true,
            backgroundColor: theme.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text.tr,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}