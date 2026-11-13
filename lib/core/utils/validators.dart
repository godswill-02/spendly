import 'package:get/get.dart';
import 'money_utils.dart';

class Validators {
  Validators._();

  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'required_field'.tr;
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'enter_amount'.tr;
    final parsed = MoneyUtils.parse(value);
    if (parsed == null) return 'invalid_amount'.tr;
    if (parsed <= 0) return 'amount_positive'.tr;
    if (parsed > 999999999) return 'amount_too_large'.tr;
    return null;
  }

  static String? maxLength(String? value, int max) {
    if (value != null && value.trim().length > max) {
      return 'max_chars'.trParams({'max': '$max'});
    }
    return null;
  }

  static String? categoryLabel(String? value) {
    final error = required(value, message: 'enter_category_name'.tr);
    if (error != null) return error;
    if (value!.trim().length < 2) {
      return 'min_chars'.trParams({'min': '2'});
    }
    return maxLength(value, 30);
  }

  static String? Function(String?) combine(
      List<String? Function(String?)> validators,
      ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}