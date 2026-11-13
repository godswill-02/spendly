import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:spendly/core/utils/money_utils.dart';
import 'package:spendly/core/utils/refresh_expenses.dart';
import 'package:spendly/data/local/category_dao.dart';
import 'package:spendly/data/local/expense_dao.dart';
import 'package:spendly/data/models/expense.dart';
import 'package:spendly/data/models/expense_category.dart';

class ExpenseFormController extends GetxController {
  static const paymentMethods = ['cash', 'mobile_money', 'card', 'bank_transfer'];

  final _expenseDao = ExpenseDao();
  final _categoryDao = CategoryDao();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  final categories = <ExpenseCategory>[].obs;
  final categoryId = Rxn<int>();
  final date = DateTime.now().obs;
  final paymentMethod = 'cash'.obs;
  final isSaving = false.obs;

  Expense? editing;
  bool get isEditing => editing != null;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Expense) {
      editing = arg;
      amountController.text = arg.amount.toString();
      noteController.text = arg.note ?? '';
      categoryId.value = arg.categoryId;
      date.value = arg.date;
      paymentMethod.value = arg.paymentMethod;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    categories.value = await _categoryDao.getCategories();
    if (categoryId.value == null && categories.isNotEmpty) {
      categoryId.value = categories.first.id;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    // Keep the time of day so same-day expenses keep a stable order.
    date.value = DateTime(
      picked.year, picked.month, picked.day,
      date.value.hour, date.value.minute,
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final note = noteController.text.trim();
      final expense = Expense(
        id: editing?.id ?? const Uuid().v4(),
        amount: MoneyUtils.parse(amountController.text)!,
        categoryId: categoryId.value!,
        date: date.value,
        note: note.isEmpty ? null : note,
        paymentMethod: paymentMethod.value,
      );

      if (isEditing) {
        await _expenseDao.updateExpense(expense);
      } else {
        await _expenseDao.insertExpense(expense);
      }

      refreshExpenseLists();
      Get.back(result: true);
    } catch (_) {
      Get.snackbar('error'.tr, 'save_failed'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}