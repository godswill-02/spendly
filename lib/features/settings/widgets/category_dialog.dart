import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/validators.dart';
import 'package:spendly/features/settings/controllers/category_dialog_controller.dart';

class CategoryDialog extends StatelessWidget {
  const CategoryDialog({super.key, required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CategoryDialogController(initial),
    );

    void submit() {
      if (controller.validate()) {
        Get.back(result: controller.value);
      }
    }

    return AlertDialog(
      title: Text('edit_category'.tr),
      content: Form(
        key: controller.formKey,
        child: TextFormField(
          controller: controller.textController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'category_name'.tr,
          ),
          validator: Validators.categoryLabel,
          onFieldSubmitted: (_) => submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: submit,
          child: Text('save'.tr),
        ),
      ],
    );
  }
}