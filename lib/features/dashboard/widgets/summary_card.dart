import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/money_utils.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'month_total'.tr,
              style: text.bodyMedium?.copyWith(color: scheme.onPrimaryContainer),
            ),
            const Gap(8),
            Text(
              MoneyUtils.format(total),
              style: text.headlineMedium?.copyWith(
                color: scheme.onPrimaryContainer,
              ),
            ),
            const Gap(8),
            Text(
              'expenses_count'.trParams({'count': '$count'}),
              style: text.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}