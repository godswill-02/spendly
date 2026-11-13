import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/utils/date_utils.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'previous_month'.tr,
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            AppDateUtils.formatMonth(month),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            tooltip: 'next_month'.tr,
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}