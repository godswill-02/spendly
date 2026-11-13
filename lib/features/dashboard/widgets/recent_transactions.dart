import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/theme/app_theme.dart';
import 'package:spendly/core/utils/date_utils.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/core/widgets/expense_tile.dart';
import 'package:spendly/data/models/expense.dart';
import 'package:spendly/routes/app_routes.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.expenses,
    required this.onSeeAll,
  });

  final List<Expense> expenses;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text('recent_transactions'.tr, style: text.titleMedium),
                  ),
                  TextButton(onPressed: onSeeAll, child: Text('see_all'.tr)),
                ],
              ),
            ),
            if (expenses.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('no_expenses_month'.tr, style: text.bodyMedium),
              )
            else
              for (final expense in expenses)
                ExpenseTile(
                  expense: expense,
                  onTap: () => Get.toNamed(AppRoutes.editExpense, arguments: expense),
                ),          ],
        ),
      ),
    );
  }
}
