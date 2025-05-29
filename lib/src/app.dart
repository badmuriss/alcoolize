import 'package:alcoolize/src/home_screen.dart';
import 'package:flutter/material.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  
  const MyApp({
    super.key,
    required this.settingsController, // Parâmetro obrigatório
  });
 
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alcoolize',
      theme: ThemeData(
        fontFamily: 'Mesmerize', // Definindo fonte padrão
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}
