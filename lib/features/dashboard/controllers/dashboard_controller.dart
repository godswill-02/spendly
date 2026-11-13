import 'package:get/get.dart';
import 'package:spendly/core/utils/date_utils.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/data/local/expense_dao.dart';
import 'package:spendly/data/models/category_total.dart';
import 'package:spendly/data/models/expense.dart';

class DashboardController extends GetxController {
  final ExpenseDao _expenseDao = ExpenseDao();

  final tabIndex = 0.obs;
  final selectedMonth = AppDateUtils.startOfMonth(DateTime.now()).obs;
  final isLoading = false.obs;

  final expenses = <Expense>[].obs; // all expenses of the selected month
  final categoryTotals = <CategoryTotal>[].obs;
  final RxDouble monthTotal = 0.0.obs;

  List<Expense> get recentExpenses => expenses.take(5).toList();

  bool get canGoNext => selectedMonth.value.isBefore(AppDateUtils.startOfMonth(DateTime.now()));

  @override
  void onInit() {
    super.onInit();
    loadMonth();
  }

  void changeTab(int index) => tabIndex.value = index;

  void previousMonth() {
    selectedMonth.value = AppDateUtils.previousMonth(selectedMonth.value);
    loadMonth();
  }

  void nextMonth() {
    if (!canGoNext) return;
    selectedMonth.value = AppDateUtils.nextMonth(selectedMonth.value);
    loadMonth();
  }

  Future<void> loadMonth() async {
    isLoading.value = true;
    try {
      final from = AppDateUtils.startOfMonth(selectedMonth.value);
      final to = AppDateUtils.startOfNextMonth(selectedMonth.value);

      expenses.value = await _expenseDao.getExpenses(from: from, to: to);
      categoryTotals.value = await _expenseDao.totalsByCategory(from, to);
      monthTotal.value = MoneyUtils.sum(expenses.map((e) => e.amount));
    } finally {
      isLoading.value = false;
    }
  }
}