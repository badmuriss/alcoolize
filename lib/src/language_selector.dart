import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/questions_manager.dart';
import 'app_wrapper.dart';
import 'localization/generated/app_localizations.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  String currentLanguage = 'pt';
  
  static const Map<String, String> languageNames = {
    'en': 'English',
    'pt': 'Português',
    'es': 'Español',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('selected_language') ?? 'pt';
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
    setState(() {
      currentLanguage = languageCode;
    });
    
    // Clear questions cache to force reload with new language
    QuestionsManager.clearCache();
    
    // Trigger app restart
    if (mounted) {
      final appRestart = AppRestartWidget.of(context);
      if (appRestart != null) {
        // Show loading indicator briefly before restart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.languageChanging(languageNames[languageCode]!) ?? 'Switching to ${languageNames[languageCode]}...'),
            duration: const Duration(milliseconds: 800),
          ),
        );
        
        // Delay restart slightly to show the message
        Future.delayed(const Duration(milliseconds: 900), () {
          appRestart.onRestart();
          
          // Add a fallback warning if restart doesn't work properly
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)?.restartRequired ?? 'Please restart the app to apply language changes'),
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          });
        });
      } else {
        // Fallback: show restart warning if restart mechanism not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.restartRequired ?? 'Please restart the app to apply language changes'),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.language,
        color: Colors.white,
        size: 36,
      ),
      onSelected: _changeLanguage,
      itemBuilder: (BuildContext context) {
        return languageNames.entries.map((entry) {
          final languageCode = entry.key;
          final languageName = entry.value;
          final isSelected = currentLanguage == languageCode;
          
          return PopupMenuItem<String>(
            value: languageCode,
            child: Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Color(0xFF6A0DAD),
                    size: 20,
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 8),
                Text(
                  languageName,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF6A0DAD) : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}