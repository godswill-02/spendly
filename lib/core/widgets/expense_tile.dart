import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/theme/app_theme.dart';
import 'package:spendly/core/utils/date_utils.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/data/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, this.onTap});

  final Expense expense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final note = expense.note;

    return ListTile(
      onTap: onTap,
      title: Text(expense.categoryLabel ?? "", style: text.titleMedium,),
      subtitle: Text(
        [
          AppDateUtils.relativeLabel(expense.date),
          'pm_${expense.paymentMethod}'.tr,
          if (note != null && note.isNotEmpty) note,
        ].join(' • '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '-${MoneyUtils.format(expense.amount)}',
        style: text.titleSmall?.copyWith(color: AppTheme.expense),
      ),
    );
  }
}