import 'package:flutter/material.dart';
import 'questions_editor_screen.dart';
import 'questions_manager.dart';

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
        title: const Text('Editar Perguntas/Palavras', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: QuestionsManager.gameFiles.keys.map((String gameName) {
          IconData gameIcon;
          String subtitle;
          
          // Define ícone e subtítulo com base no tipo de jogo
          if (gameName == 'TIBITAR' || gameName == 'PALAVRA PROIBIDA') {
            gameIcon = Icons.text_fields;
            subtitle = 'Editar palavras';
          } else {
            gameIcon = Icons.question_answer;
            subtitle = 'Editar perguntas';
          }
          
          return Card(
            color: Colors.white.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(gameIcon, color: Colors.white),
              title: Text(gameName, style: const TextStyle(color: Colors.white)),
              subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
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