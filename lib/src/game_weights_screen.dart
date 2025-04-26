import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_handler.dart';

class GameWeightsScreen extends StatefulWidget {
  const GameWeightsScreen({super.key});

  @override
  _GameWeightsScreenState createState() => _GameWeightsScreenState();
}

class _GameWeightsScreenState extends State<GameWeightsScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  late Map<String, double> weights;
  double totalWeight = 0;
  bool isLoading = true;
  bool isWeightValid = true;

  @override
  void initState() {
    super.initState();
    _initWeights();
  }

  Future<void> _initWeights() async {
    // Create a copy of the weights from GameHandler
    weights = Map.from(GameHandler.gameWeights);
    
    // Garantir que todos os jogos ativos tenham pelo menos 1% de peso
    // Usamos o activeGamesList para determinar quais jogos estão ativos
    Set<String> activeGames = _getActiveGameNames();
    
    for (var gameName in activeGames) {
      if (weights[gameName] == null || weights[gameName]! < 1.0) {
        weights[gameName] = 1.0;
      }
    }
    
    _calculateTotalWeight();
    
    // Normaliza para 100%
    if (totalWeight != 100.0) {
      // Normaliza proporcionalmente
      double factor = 100.0 / totalWeight;
      weights.updateAll((key, value) => value * factor);
      
      // Arredonda para uma casa decimal
      weights.updateAll((key, value) => value.ceil().toDouble());
      
      // Recalcula o total após arredondamento
      _calculateTotalWeight();
      
      // Ajuste final no jogo com maior peso
      if (totalWeight != 100.0) {
        String gameToAdjust = weights.entries
            .where((entry) => activeGames.contains(entry.key))
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
        
        weights[gameToAdjust] = weights[gameToAdjust]! + (100.0 - totalWeight);
      }
    }

    _calculateTotalWeight();

    setState(() {
      isLoading = false;
    });
  }

  // Método para obter os nomes dos jogos ativos
  Set<String> _getActiveGameNames() {
    Set<String> activeGames = {};
    
    // Percorre a lista de jogos ativos e obtém seus nomes
    for (var gameFunction in GameHandler.activeGamesList) {
      for (var entry in GameHandler.allGames.entries) {
        if (entry.value == gameFunction) {
          activeGames.add(entry.key);
          break;
        }
      }
    }
    
    return activeGames;
  }

  void _calculateTotalWeight() {
    totalWeight = weights.values.fold(0, (sum, weight) => sum + weight);
    setState(() {
      isWeightValid = totalWeight == 100;
    });
  }

  Future<void> _saveWeights() async {
    // Não permite salvar se o peso total for maior que 100
    if (totalWeight > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O peso total não pode exceder 100%'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      for (var entry in weights.entries) {
        await prefs.setDouble('weight_${entry.key}', entry.value);
      }
      
      // Update the GameHandler weights
      GameHandler.gameWeights = Map.from(weights);
    } catch (e) {
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: const Text('Configurar Probabilidades', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: !isWeightValid ? Colors.red.withOpacity(0.3) : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Peso Total: ${totalWeight.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  if (!isWeightValid)
                    const Text(
                      'Deve ser 100%',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80), // Margem inferior para o botão
                children: _getActiveGameNames()
                    .map((gameName) {
                  // Garantir que o peso nunca seja menor que 1
                  if (weights[gameName] == null || weights[gameName]! < 1.0) {
                    weights[gameName] = 1.0;
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gameName, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: weights[gameName] ?? 1.0,
                              min: 1.0, // Mínimo de 1%
                              max: 100,
                              divisions: 99, // 1 a 100 em incrementos de 1
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.3),
                              onChanged: (value) {
                                setState(() {
                                  weights[gameName] = value;
                                  _calculateTotalWeight();
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              '${(weights[gameName] ?? 1.0).toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white30),
                    ],
                  );
                }).toList(),
              ),
            ),
          // Espaço adicional para garantir que os botões não fiquem sob o botão flutuante
        const SizedBox(height: 100),
          ],
        ),
       floatingActionButton: Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: isWeightValid ? _saveWeights : null,
        backgroundColor: Colors.white,
        foregroundColor: settingsColor,
        child: const Icon(Icons.check),
      ),
    ),
    );
  }
}