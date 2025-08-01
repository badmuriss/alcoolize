import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'settings/settings_controller.dart';

class AppWrapper extends StatefulWidget {
  final SettingsController settingsController;
  
  const AppWrapper({
    super.key,
    required this.settingsController,
  });

  @override
  AppWrapperState createState() => AppWrapperState();
}

class AppWrapperState extends State<AppWrapper> {
  String _currentLanguage = 'en';
  Key _appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('selected_language') ?? 'pt';
    if (mounted) {
      setState(() {
        _currentLanguage = language;
      });
    }
  }

  void restartApp() {
    _loadLanguage().then((_) {
      setState(() {
        _appKey = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppRestartWidget(
      onRestart: restartApp,
      child: MyApp(
        key: _appKey,
        settingsController: widget.settingsController,
        currentLanguage: _currentLanguage,
      ),
    );
  }
}

class AppRestartWidget extends InheritedWidget {
  final VoidCallback onRestart;

  const AppRestartWidget({
    super.key,
    required this.onRestart,
    required super.child,
  });

  static AppRestartWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppRestartWidget>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}