
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/validators.dart';
import 'package:spendly/features/settings/controllers/settings_controller.dart';
class AddCategoryForm extends GetView<SettingsController> {
  const AddCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Form(
        key: controller.formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.textController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'category_name'.tr),
                validator: Validators.categoryLabel,
                onFieldSubmitted: (_) => controller.submitNewCategory(),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Obx(() => FilledButton(
                onPressed: controller.isAdding.value
                    ? null
                    : controller.submitNewCategory,
                child: Text('add'.tr),
              )),
            ),
          ],
        ),
      ),
    );
  }
}