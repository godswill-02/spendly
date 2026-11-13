import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spendly/core/utils/refresh_expenses.dart';
import 'package:spendly/data/local/category_dao.dart';
import 'package:spendly/data/models/expense_category.dart';

class SettingsController extends GetxController {
  final _dao = CategoryDao();
  final categories = <ExpenseCategory>[].obs;
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final isAdding = false.obs;

  static const undoDuration = Duration(seconds: 3);

  ExpenseCategory? _pendingDelete;
  Timer? _undoTimer;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    _commitPendingDelete();
    textController.dispose();
    super.onClose();
  }

  Future<void> submitNewCategory() async {
    if (!formKey.currentState!.validate() || isAdding.value) return;
    isAdding.value = true;
    final ok = await add(textController.text.trim());
    isAdding.value = false;
    if (ok) {
      textController.clear();
      formKey.currentState!.reset();
    }
  }

  Future<void> load() async {
    final all = await _dao.getCategories();
    // Keep a category that is waiting to be deleted hidden.
    categories.value = all.where((c) => c.id != _pendingDelete?.id).toList();
  }

  /// Returns true if the category was added.
  Future<bool> add(String label) async {
    try {
      await _dao.insertCategory(ExpenseCategory(label: label.trim()));
      await load();
      return true;
    } on DatabaseException {
      Get.snackbar('error'.tr, 'category_exists'.tr); // UNIQUE constraint
      return false;
    }
  }

  /// Returns true if the category was renamed.
  Future<bool> updateCategory(ExpenseCategory category, String label) async {
    final newLabel = label.trim();
    if (newLabel == category.label) return true;
    try {
      await _dao.updateCategory(ExpenseCategory(id: category.id, label: newLabel));
      await load();
      refreshExpenseLists(); // expenses display the category label
      return true;
    } on DatabaseException {
      Get.snackbar('error'.tr, 'category_exists'.tr); // UNIQUE constraint
      return false;
    }
  }

  /// Hides the category right away and deletes it for real after
  /// [undoDuration], unless the user taps Undo.
  void remove(ExpenseCategory category) {
    // A previous delete still waiting? Commit it now.
    _commitPendingDelete();

    _pendingDelete = category;
    categories.removeWhere((c) => c.id == category.id);
    _undoTimer = Timer(undoDuration, _commitPendingDelete);


    Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      duration: undoDuration,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      messageText: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'category_deleted'.trParams({'name': category.label}),
            style:  GoogleFonts.poppins(color: Colors.white),
          ),
          Gap(8),
          // Countdown "timeline": full -> empty over 5 seconds.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: undoDuration,
            builder: (_, value, __) => LinearProgressIndicator(
              value: value,
              minHeight: 3,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
      mainButton: TextButton(
        onPressed: _undoDelete,
        child: Text('cancel'.tr),
      ),
    ));
  }

  void _undoDelete() {
    _undoTimer?.cancel();
    _pendingDelete = null;
    Get.closeCurrentSnackbar();
    load();
  }

  Future<void> _commitPendingDelete() async {
    final category = _pendingDelete;
    if (category == null) return;
    _undoTimer?.cancel();
    _undoTimer = null;
    _pendingDelete = null;

    try {
      await _dao.deleteCategory(category.id!);
      refreshExpenseLists();
    } on DatabaseException {
      Get.snackbar('error'.tr, 'category_in_use'.tr); // foreign key
      await load(); // bring the row back
    }
  }
}