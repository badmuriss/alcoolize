import 'package:alcoolize/src/screens/home_screen.dart';
import 'package:alcoolize/src/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';
import 'localization/generated/app_localizations.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  
  const MyApp({
    super.key,
    required this.settingsController, // Required parameter
    this.currentLanguage = 'pt',
  });
 
  final SettingsController settingsController;
  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alcoolize',
      theme: AppTheme.lightTheme,
      locale: Locale(currentLanguage),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
        Locale('es'),
      ],
      home: const HomeScreen(),
    );
  }
}
