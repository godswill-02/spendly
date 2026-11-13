import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateFormat get _date => DateFormat.yMd();
  static DateFormat get _month => DateFormat.yMMMM();
  static DateFormat get _dayMonth => DateFormat.MMMd();
  static DateFormat get _dateTime => DateFormat.yMd().add_Hm();

  /// 2026-11-13 -> "13/11/2026"
  static String formatDate(DateTime date) => _date.format(date);

  /// 2026-11-13 -> "13 nov."
  static String formatDayMonth(DateTime date) => _dayMonth.format(date);

  /// 2026-11-13 14:30 -> "13/11/2026 14:30"
  static String formatDateTime(DateTime date) => _dateTime.format(date);

  /// 2026-11-13 -> "Novembre 2026"
  static String formatMonth(DateTime date) => _capitalize(_month.format(date));

  /// "Aujourd'hui", "Hier", or the formatted date.
  static String relativeLabel(DateTime date, {DateTime? now}) {
    final today = startOfDay(now ?? DateTime.now());
    final diff = today.difference(startOfDay(date)).inDays;
    if (diff == 0) return 'today'.tr;
    if (diff == 1) return 'yesterday'.tr;
    return formatDate(date);
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  /// First day of the NEXT month (use as an exclusive upper bound).
  static DateTime startOfNextMonth(DateTime date) =>
      DateTime(date.year, date.month + 1);

  static DateTime previousMonth(DateTime date) =>
      DateTime(date.year, date.month - 1);

  static DateTime nextMonth(DateTime date) =>
      DateTime(date.year, date.month + 1);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static bool isFuture(DateTime date, {DateTime? now}) =>
      startOfDay(date).isAfter(startOfDay(now ?? DateTime.now()));
}