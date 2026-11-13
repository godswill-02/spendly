import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/services/locale_service.dart';
import 'package:spendly/core/services/theme_service.dart';
import 'package:spendly/core/translations/app_translations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';


import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

class SpendlyApp extends StatelessWidget {
  const SpendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spendly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: Get.find<ThemeService>().mode.value,
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,

      locale: Get.find<LocaleService>().current,
      fallbackLocale: LocaleService.fallback,
      supportedLocales: LocaleService.supported,
      translations: AppTranslations(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

    );
  }
}