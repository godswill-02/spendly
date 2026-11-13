import 'package:get/get.dart';
import 'package:spendly/core/utils/date_utils.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/core/utils/refresh_expenses.dart';
import 'package:spendly/data/local/category_dao.dart';
import 'package:spendly/data/local/expense_dao.dart';
import 'package:spendly/data/models/expense.dart';
import 'package:spendly/data/models/expense_category.dart';

class TransactionsController extends GetxController {
  final _expenseDao = ExpenseDao();
  final _categoryDao = CategoryDao();

  final selectedMonth = AppDateUtils.startOfMonth(DateTime.now()).obs;
  final selectedCategoryId = Rxn<int>();
  final categories = <ExpenseCategory>[].obs;
  final expenses = <Expense>[].obs;

  double get total => MoneyUtils.sum(expenses.map((e) => e.amount));

  bool get canGoNext => selectedMonth.value
      .isBefore(AppDateUtils.startOfMonth(DateTime.now()));

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    categories.value = await _categoryDao.getCategories();
    expenses.value = await _expenseDao.getExpenses(
      from: AppDateUtils.startOfMonth(selectedMonth.value),
      to: AppDateUtils.startOfNextMonth(selectedMonth.value),
      categoryId: selectedCategoryId.value,
    );
  }

  void previousMonth() {
    selectedMonth.value = AppDateUtils.previousMonth(selectedMonth.value);
    load();
  }

  void nextMonth() {
    if (!canGoNext) return;
    selectedMonth.value = AppDateUtils.nextMonth(selectedMonth.value);
    load();
  }

  void selectCategory(int? id) {
    selectedCategoryId.value = id;
    load();
  }

  Future<void> delete(Expense expense) async {
    // Remove from the list first: a dismissed Dismissible must leave the tree.
    expenses.removeWhere((e) => e.id == expense.id);
    await _expenseDao.deleteExpense(expense.id);
    refreshExpenseLists();
  }
}