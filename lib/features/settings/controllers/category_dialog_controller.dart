import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDialogController extends GetxController {
  CategoryDialogController(String initial)
      : textController = TextEditingController(text: initial);

  final formKey = GlobalKey<FormState>();
  final TextEditingController textController;

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  String get value => textController.text.trim();

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}