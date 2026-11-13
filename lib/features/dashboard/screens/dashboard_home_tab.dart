import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/dashboard/controllers/dashboard_controller.dart';
import 'package:spendly/features/dashboard/widgets/category_breakdown.dart';
import 'package:spendly/features/dashboard/widgets/month_selector.dart';
import 'package:spendly/features/dashboard/widgets/recent_transactions.dart';
import 'package:spendly/features/dashboard/widgets/summary_card.dart';
import 'package:spendly/routes/app_routes.dart';

class DashboardHomeTab extends GetView<DashboardController> {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav_home'.tr)),
      body: RefreshIndicator(
        onRefresh: controller.loadMonth,
        child: Obx(
              () => ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              MonthSelector(
                month: controller.selectedMonth.value,
                onPrevious: controller.previousMonth,
                onNext: controller.nextMonth,
                canGoNext: controller.canGoNext,
              ),
              SummaryCard(
                total: controller.monthTotal.value,
                count: controller.expenses.length,
              ),
              CategoryBreakdown(
                totals: controller.categoryTotals.toList(),
                total: controller.monthTotal.value,
              ),
              RecentTransactions(
                expenses: controller.recentExpenses,
                onSeeAll: () => Get.toNamed(AppRoutes.transactions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}