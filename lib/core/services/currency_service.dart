import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/services/storage_service.dart';

class AppCurrency {
  const AppCurrency(this.code, this.symbol, {this.decimals = 2});
  final String code;
  final String symbol;
  final int decimals;
}

/// Exchange rates + conversion + formatting.
///
/// - Rates come from open.er-api.com (free, no key, updated once a day).
/// - Everything is expressed against EUR internally.
/// - Rates are cached in [StorageService], so the app works offline with the
///   last known rates. XOF <-> EUR is a fixed peg, so it always works.
///
/// Register after StorageService:
///   await Get.putAsync(() => CurrencyService().init(), permanent: true);
class CurrencyService extends GetxService {
  static const _url = 'https://open.er-api.com/v6/latest/EUR';
  static const _maxAge = Duration(hours: 24);

  /// Fixed peg: 1 EUR = 655.957 XOF.
  static const _xofPerEur = 655.957;

  static const currencies = [
    AppCurrency('XOF', 'CFA', decimals: 0),
    AppCurrency('EUR', '€'),
    AppCurrency('USD', '\$'),
    AppCurrency('GBP', '£'),
    AppCurrency('NGN', '₦'),
    AppCurrency('GHS', 'GH₵'),
    AppCurrency('CAD', 'CA\$'),
  ];

  final _storage = Get.find<StorageService>();

  /// Units of each currency for 1 EUR.
  final Map<String, double> _rates = {'EUR': 1, 'XOF': _xofPerEur};

  final lastUpdate = Rxn<DateTime>();
  final isRefreshing = false.obs;

  Future<CurrencyService> init() async {
    _loadCache();
    unawaited(ensureFresh()); // never block app start on the network
    return this;
  }

  AppCurrency currencyOf(String code) => currencies
      .firstWhere((c) => c.code == code, orElse: () => currencies.first);

  /// True if we can convert between these two currencies right now.
  bool canConvert(String from, String to) =>
      from == to || (_rates.containsKey(from) && _rates.containsKey(to));

  /// Converts [amount]; returns null when a rate is unknown
  /// (never fetched and not XOF/EUR).
  double? convert(double amount, String from, String to) {
    if (from == to) return amount;
    final f = _rates[from];
    final t = _rates[to];
    if (f == null || t == null) return null;
    return amount / f * t;
  }

  /// "12 500 CFA" / "19,06 €" depending on the current locale.
  String format(num amount, String code) {
    final c = currencyOf(code);
    return NumberFormat.currency(
      locale: Intl.defaultLocale,
      symbol: c.symbol,
      decimalDigits: c.decimals,
    ).format(amount);
  }

  /// Convert then format. Falls back to the original amount/currency if the
  /// rate is unknown, so the user never sees a wrong number.
  String formatConverted(double amount, {required String from, required String to}) {
    final converted = convert(amount, from, to);
    return converted == null ? format(amount, from) : format(converted, to);
  }

  /// Refresh only if the cache is older than 24h.
  Future<void> ensureFresh() async {
    final last = lastUpdate.value;
    if (last != null && DateTime.now().difference(last) < _maxAge) return;
    await refresh();
  }

  /// Fetch the latest rates. Returns false on any failure (offline, throttled...).
  Future<bool> refresh() async {
    if (isRefreshing.value) return false;
    isRefreshing.value = true;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(Uri.parse(_url));
      final response = await request.close().timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return false;

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      if (json['result'] != 'success') return false;

      final fetched = (json['rates'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble()));
      if (!fetched.containsKey('EUR')) return false;

      _rates
        ..clear()
        ..addAll(fetched)
        ..putIfAbsent('XOF', () => _xofPerEur);

      final now = DateTime.now();
      lastUpdate.value = now;
      await _storage.write(
        StorageService.ratesKey,
        jsonEncode({'at': now.toIso8601String(), 'rates': _rates}),
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      client.close();
      isRefreshing.value = false;
    }
  }

  void _loadCache() {
    final raw = _storage.read<String>(StorageService.ratesKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final cached = (json['rates'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble()));
      _rates
        ..addAll(cached)
        ..putIfAbsent('XOF', () => _xofPerEur);
      lastUpdate.value = DateTime.tryParse(json['at'] as String? ?? '');
    } catch (_) {
      // corrupted cache: ignore, we'll refetch
    }
  }
}