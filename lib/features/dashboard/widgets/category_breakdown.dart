import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/data/models/category_total.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({
    super.key,
    required this.totals,
    required this.total,
  });

  final List<CategoryTotal> totals;
  final double total;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by_category'.tr, style: text.titleMedium),
            const Gap(12),
            if (totals.isEmpty)
              Text('no_expenses_month'.tr, style: text.bodyMedium)
            else
              for (final item in totals) ...[
                _CategoryRow(item: item, ratio: MoneyUtils.ratio(item.total, total)),
                const Gap(12),
              ],
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.item, required this.ratio});

  final CategoryTotal item;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(item.label, style: text.bodyMedium)),
            Text(MoneyUtils.percent(ratio), style: text.bodySmall),
            const Gap(12),
            Text(MoneyUtils.format(item.total), style: text.titleSmall),
          ],
        ),
        const Gap(6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: ratio, minHeight: 8),
        ),
      ],
    );
  }
}