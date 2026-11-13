import 'package:get/get.dart';
import 'package:spendly/features/dashboard/binding/dashboard_binding.dart';
import 'package:spendly/features/dashboard/screens/dashboard_screen.dart';
import 'package:spendly/features/expenses/bindings/expense_binding.dart';
import 'package:spendly/features/expenses/screens/expense_form_screen.dart';
import 'package:spendly/features/expenses/screens/transactions_screen.dart';
import 'package:spendly/features/settings/screens/settings_screen.dart';

import 'app_routes.dart';

class AppPages {

  static const initial = AppRoutes.dashboard;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.addExpense,
      page: () => const ExpenseFormScreen(),
      binding: ExpenseBinding(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => const TransactionsScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
