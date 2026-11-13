import 'package:get/get.dart';
import 'package:spendly/features/dashboard/controllers/dashboard_controller.dart';
import 'package:spendly/features/expenses/controllers/transactions_controller.dart';
import 'package:spendly/features/settings/controllers/app_setting_controller.dart';
import 'package:spendly/features/settings/controllers/settings_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<TransactionsController>(() => TransactionsController());

    Get.lazyPut<AppSettingsController>(() => AppSettingsController());

    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}