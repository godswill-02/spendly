import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/widgets/app_bottom_nav.dart';
import 'package:spendly/features/dashboard/controllers/dashboard_controller.dart';
import 'package:spendly/features/dashboard/screens/dashboard_home_tab.dart';
import 'package:spendly/features/expenses/screens/transactions_screen.dart';
import 'package:spendly/features/settings/screens/settings_screen.dart';
import 'package:spendly/routes/app_routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          DashboardHomeTab(),
          TransactionsScreen(),
          SettingsScreen(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(AppRoutes.addExpense);
          Get.find<DashboardController>().loadMonth();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Obx(() => AppBottomNav(
        currentIndex: controller.tabIndex.value,
        onTabChange: controller.changeTab,
      )),
    );
  }
}