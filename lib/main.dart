import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:spendly/app.dart';
import 'package:spendly/core/services/currency_service.dart';
import 'package:spendly/core/services/locale_service.dart';
import 'package:spendly/core/services/storage_service.dart';
import 'package:spendly/core/services/theme_service.dart';
import 'package:spendly/data/local/app_database.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await AppDatabase.instance.database;
  await initializeDateFormatting();
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => LocaleService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => CurrencyService().init(), permanent: true);

  runApp(const SpendlyApp());
  FlutterNativeSplash.remove();
}