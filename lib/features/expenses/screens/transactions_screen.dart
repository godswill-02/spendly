import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/core/widgets/expense_tile.dart';
import 'package:spendly/data/models/expense.dart';
import 'package:spendly/features/dashboard/widgets/month_selector.dart';
import 'package:spendly/features/expenses/controllers/transactions_controller.dart';
import 'package:spendly/routes/app_routes.dart';

class TransactionsScreen extends GetView<TransactionsController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('nav_transactions'.tr)),
      body: Column(
        children: [
          Obx(() => MonthSelector(
            month: controller.selectedMonth.value,
            onPrevious: controller.previousMonth,
            onNext: controller.nextMonth,
            canGoNext: controller.canGoNext,
          )),
          Obx(() => SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip(
                  label: 'all'.tr,
                  selected: controller.selectedCategoryId.value == null,
                  onTap: () => controller.selectCategory(null),
                ),
                for (final c in controller.categories)
                  _chip(
                    label: c.label,
                    selected: controller.selectedCategoryId.value == c.id,
                    onTap: () => controller.selectCategory(c.id),
                  ),
              ],
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text('total'.tr, style: text.bodyMedium),
                const Spacer(),
                Text(MoneyUtils.format(controller.total),
                    style: text.titleMedium),
              ],
            ),
          )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.load,
              child: Obx(() {
                final items = controller.expenses;
                if (items.isEmpty) {
                  return ListView(
                    children: [
                      const SizedBox(height: 80),
                      Center(child: Text('no_expenses'.tr)),
                    ],
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _dismissible(items[i]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _dismissible(Expense expense) {
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Get.theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete_rounded,
            color: Get.theme.colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        final ok = await Get.dialog<bool>(
          AlertDialog(
            title: Text('delete_expense_title'.tr),
            content: Text('delete_expense_message'.tr),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('cancel'.tr),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('delete'.tr),
              ),
            ],
          ),
        );
        return ok ?? false;
      },
      onDismissed: (_) => controller.delete(expense),
      child: ExpenseTile(
        expense: expense,
        onTap: () => Get.toNamed(AppRoutes.editExpense, arguments: expense),
      ),
    );
  }
}