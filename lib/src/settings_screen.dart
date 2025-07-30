import 'package:alcoolize/src/edit_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_handler.dart';
import 'game_weights_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  Map<String, bool> gamesEnabled = {}; // Inicializa como um Map vazio
  bool isLoading = true; // Estado para controle de carregamento
  bool canRepeat = false; // Valor inicial para canRepeat

  @override
  void initState() {
    super.initState();
    _initializeGamesEnabled();
  }

  Future<void> _initializeGamesEnabled() async {
    // Defina os valores padrão aqui
    gamesEnabled = {
      'TIBITAR': true,
      'EU NUNCA': true,
      'ROLETINHA': true,
      'PARANOIA': true,
      'QUEM É MAIS PROVÁVEL': true,
      'PALAVRA PROIBIDA': true,
      'MEDUSA': true,
      'CARTAS': true,
    };

    await _loadGameSettings();
  }

  Future<void> _loadGameSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      gamesEnabled.forEach((game, _) {
        gamesEnabled[game] = prefs.getBool(game) ?? true; // Carrega o valor armazenado
      });
      
      // Carrega o valor de canRepeat
      canRepeat = prefs.getBool('canRepeat') ?? false;
    } catch (e) {
      // Handle error loading settings - use default values
    } finally {
      setState(() {
        isLoading = false; // Atualiza o estado de carregamento
      });
    }
  }

  Future<void> _saveGameSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      gamesEnabled.forEach((game, enabled) {
        prefs.setBool(game, enabled);
      });
      
      // Salva o valor de canRepeat
      prefs.setBool('canRepeat', canRepeat);
    } catch (e) {
      // Handle error loading settings - use default values
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: const Text('Ativar/Desativar jogos', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white, size: 33),
            onPressed: () {
              _showGameInfoDialog(context);
            }, // Botão de informações
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          // Lista de jogos (seu código existente)
          ...isLoading
              ? [const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ))]
              : gamesEnabled.isEmpty
                  ? [const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Nenhum jogo disponível.', style: TextStyle(color: Colors.white)),
                    ))]
                  : gamesEnabled.keys.map((String game) {
                      return SwitchListTile(
                        activeTrackColor: const Color.fromARGB(255, 29, 255, 9),
                        title: Text(game, style: const TextStyle(color: Colors.white)),
                        value: gamesEnabled[game]!,
                        onChanged: (bool value) {
                          setState(() {
                            if (!value) {
                              int enabledCount = gamesEnabled.values.where((enabled) => enabled).length;
                              if (enabledCount <= 1) {
                                return;
                              }
                            }
                            gamesEnabled[game] = value;
                          });
                        },
                      );
                    }).toList(),

          // Espaço aumentado entre a lista e os botões
          const SizedBox(height: 30),

          // Botão de repetição (canRepeat)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.repeat,
                color: canRepeat ? Colors.green : settingsColor,
              ),
              label: Text(
                canRepeat ? 'Repetir Seguidamente ON' : 'Repetir Seguidamente OFF',
                style: TextStyle(
                  color: settingsColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                setState(() {
                  canRepeat = !canRepeat;
                });
              },
            ),
          ),

          // Botão de probabilidades (seu código existente)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.percent, color: Color(0xFF6A0DAD)),
              label: const Text(
                'Ajustar Probabilidades',
                style: TextStyle(color: Color(0xFF6A0DAD)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                GameHandler.updateGamesList(gamesEnabled, canRepeat);
                _saveGameSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameWeightsScreen(),
                  ),
                );
              },
            ),
          ),

          // Botão de editar perguntas (seu código existente)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note, color: Color(0xFF6A0DAD)),
              label: const Text(
                'Editar Perguntas/Palavras',
                style: TextStyle(color: Color(0xFF6A0DAD)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                GameHandler.updateGamesList(gamesEnabled, canRepeat);
                _saveGameSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditQuestionsScreen(),
                  ),
                );
              },
            ),
          ),

          // Espaço adicional para garantir que os botões não fiquem sob o botão flutuante
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            GameHandler.updateGamesList(gamesEnabled, canRepeat);
            _saveGameSettings();
            Navigator.pop(context);
          },
          backgroundColor: Colors.white,
          foregroundColor: settingsColor,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _showGameInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: settingsColor, // Fundo do AlertDialog
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Informações dos Jogos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: GameHandler.gameDescriptions.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        entry.key, // Nome do jogo
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        entry.value, // Descrição do jogo
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // --- FIM DO NOVO MÉTODO ---
}