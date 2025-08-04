import 'package:flutter/material.dart';
import 'questions_editor_screen.dart';
import '../utils/questions_manager.dart';
import '../utils/game_handler.dart';
import '../localization/generated/app_localizations.dart';

class EditQuestionsScreen extends StatelessWidget {
  final Color settingsColor = const Color(0xFF6A0DAD);

  const EditQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: Text(AppLocalizations.of(context)!.editQuestions, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: QuestionsManager.gameFiles.keys.map((String gameName) {
          IconData gameIcon;
          String subtitle;
          
          // Define icon and subtitle based on game type
          if (gameName == 'MYSTERY_VERB' || gameName == 'FORBIDDEN_WORD') {
            gameIcon = Icons.text_fields;
            subtitle = AppLocalizations.of(context)!.editWords;
          } else {
            gameIcon = Icons.question_answer;
            subtitle = AppLocalizations.of(context)!.editQuestionsSubtitle;
          }
          
          return Card(
            color: Colors.white.withValues(alpha: 0.1),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(gameIcon, color: Colors.white),
              title: Text(GameHandler.getGameName(context, gameName), style: const TextStyle(color: Colors.white)),
              subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              trailing: const Icon(Icons.edit, color: Colors.white),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionsEditorScreen(
                      gameName: gameName,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}