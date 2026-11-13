import 'package:get/get.dart';
import 'package:spendly/features/expenses/controllers/expense_form_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseFormController>(() => ExpenseFormController());
  }
}