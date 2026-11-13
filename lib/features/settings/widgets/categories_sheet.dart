
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/settings/controllers/settings_controller.dart';
import 'package:spendly/features/settings/widgets/add_category_form.dart';
import 'package:spendly/features/settings/widgets/category_tile.dart';

/// Bottom sheet: list of categories (swipe right = edit, swipe left = delete)
/// plus a text field and an add button.
class CategoriesSheet extends GetView<SettingsController> {
  const CategoriesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'categories'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Flexible(
              child: Obx(() {
                final items = controller.categories;
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('no_categories'.tr),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, i) => CategoryTile(category: items[i]),
                );
              }),
            ),
            const Divider(height: 1),
            const AddCategoryForm(),
          ],
        ),
      ),
    );
  }
}
