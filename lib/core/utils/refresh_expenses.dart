import 'package:get/get.dart';
import 'package:spendly/features/dashboard/controllers/dashboard_controller.dart';
import 'package:spendly/features/expenses/controllers/transactions_controller.dart';

void refreshExpenseLists() {
  if (Get.isRegistered<DashboardController>()) {
    Get.find<DashboardController>().loadMonth();
  }
  if (Get.isRegistered<TransactionsController>()) {
    Get.find<TransactionsController>().load();
  }
}