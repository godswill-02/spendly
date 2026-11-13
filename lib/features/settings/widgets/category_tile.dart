
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/data/models/expense_category.dart';
import 'package:spendly/features/settings/controllers/settings_controller.dart';
import 'package:spendly/features/settings/widgets/category_dialog.dart';

class CategoryTile extends GetView<SettingsController> {
  const CategoryTile({super.key, required this.category});
  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(category.id),
      // swipe right -> edit
      background: Container(
        color: scheme.primaryContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit_outlined, color: scheme.onPrimaryContainer),
      ),
      // swipe left -> delete
      secondaryBackground: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete_outline_rounded, color: scheme.onErrorContainer),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final label = await Get.dialog<String>(
            CategoryDialog(initial: category.label),
          );
          if (label != null) await controller.updateCategory(category, label);
          return false; // never dismiss on edit; the list reloads itself
        }
        // Swipe left: hide now, delete after the 5s undo window.
        controller.remove(category);
        return true;
      },
      child: ListTile(title: Text(category.label)),
    );
  }
}