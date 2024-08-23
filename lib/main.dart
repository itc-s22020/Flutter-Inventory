import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/page/home.dart';
import 'package:inventory/pref/setting.dart';
import 'package:inventory/sembast/database_service.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  String language = await getLanguage();
  Locale locale = language == 'Japanese' ? const Locale('ja') : const Locale('en');

  runApp(GetMaterialApp(
    title: "Inventory",
    theme: ThemeData(fontFamily: 'NotoSansJP'),
    home: const HomePage(initialIndex: 0),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    initialRoute: "/",
  ));
}
