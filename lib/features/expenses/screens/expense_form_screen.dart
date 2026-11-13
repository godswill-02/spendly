import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/date_utils.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/core/utils/validators.dart';
import 'package:spendly/features/expenses/controllers/expense_form_controller.dart';

class ExpenseFormScreen extends GetView<ExpenseFormController> {
  const ExpenseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'edit_expense'.tr : 'add_expense'.tr),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: text.headlineMedium,
              decoration: InputDecoration(
                labelText: 'amount'.tr,
                suffixText: MoneyUtils.defaultCurrency,
              ),
              validator: Validators.amount,
              autofocus: !controller.isEditing,
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<int>(
              value: controller.categoryId.value,
              decoration: InputDecoration(labelText: 'category'.tr),
              items: [
                for (final c in controller.categories)
                  DropdownMenuItem(value: c.id, child: Text(c.label)),
              ],
              onChanged: (v) => controller.categoryId.value = v,
              validator: (v) => v == null ? 'required_field'.tr : null,
            )),
            const SizedBox(height: 16),
            Obx(() => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => controller.pickDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'date'.tr,
                  suffixIcon: const Icon(Icons.calendar_today_rounded),
                ),
                child: Text(AppDateUtils.formatDate(controller.date.value)),
              ),
            )),
            const SizedBox(height: 20),
            Text('payment_method'.tr, style: text.titleSmall),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in ExpenseFormController.paymentMethods)
                  ChoiceChip(
                    label: Text('pm_$m'.tr),
                    selected: controller.paymentMethod.value == m,
                    onSelected: (_) => controller.paymentMethod.value = m,
                  ),
              ],
            )),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.noteController,
              maxLines: 2,
              decoration: InputDecoration(labelText: 'note'.tr),
              validator: (v) => Validators.maxLength(v, 100),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isSaving.value ? null : controller.save,
              child: Text('save'.tr),
            )),
          ],
        ),
      ),
    );
  }
}