import 'package:intl/intl.dart';

class MoneyUtils {
  MoneyUtils._();

  static const String defaultCurrency = 'FCFA ';

  static NumberFormat get _withCurrency =>
      NumberFormat.currency(symbol: defaultCurrency, decimalDigits: 0);

  static NumberFormat get _plain => NumberFormat.decimalPattern();

  /// 12500 -> "12 500 FCFA"
  static String format(double amount, {bool withCurrency = true}) =>
      withCurrency ? _withCurrency.format(amount) : _plain.format(amount);

  /// "12 500", "12500" or "12,500" -> 12500. Returns null if invalid.
  /// Kept manual on purpose: it accepts any space or separator the user types.
  static double? parse(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'[^0-9-]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  static double sum(Iterable<double> amounts) =>
      amounts.fold(0, (total, value) => total + value);

  static double ratio(double part, double total) =>
      total == 0 ? 0.0 : part / total;

  /// 0.4567 -> "46 %" (French style, with a space)
  static String percent(double ratio) =>
      NumberFormat.percentPattern('fr_FR').format(ratio);
}