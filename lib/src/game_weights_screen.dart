import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_handler.dart';

class GameWeightsScreen extends StatefulWidget {
  const GameWeightsScreen({super.key});

  @override
  GameWeightsScreenState createState() => GameWeightsScreenState();
}

class GameWeightsScreenState extends State<GameWeightsScreen> {
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
    // Set isLoading to true at the beginning of initWeights
    // to show loading indicator while calculations are made.
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

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

    _calculateTotalWeight(); // Calculate total initially

    // Normaliza para 100%
    if (totalWeight != 100.0) {
      // Normaliza proporcionalmente
      double factor = 100.0 / totalWeight;
      weights.updateAll((key, value) => value * factor);

      // Arredonda para o inteiro mais próximo e garante 1.0 mínimo
      weights.updateAll((key, value) {
        double roundedValue = value.roundToDouble(); // Round to nearest whole number
        return max(1.0, roundedValue); // Ensure it's at least 1.0
      });

      // Recalcula o total após arredondamento
      _calculateTotalWeight();

      // Ajuste final no jogo com maior peso para garantir 100.0
      // Este ajuste só deve ocorrer se o total ainda não for 100.0
      if (totalWeight != 100.0) {
        // Encontra o jogo ativo com maior peso para ajustar
        String? gameToAdjust;
        double maxWeight = -1.0;

        // Iterate only through active games to find the one with max weight
        for (var entry in weights.entries) {
          if (activeGames.contains(entry.key) && entry.value > maxWeight) {
            maxWeight = entry.value;
            gameToAdjust = entry.key;
          }
        }

        if (gameToAdjust != null) {
          weights[gameToAdjust] = weights[gameToAdjust]! + (100.0 - totalWeight);
          // Ensure it doesn't go below 1.0 after adjustment
          weights[gameToAdjust] = max(1.0, weights[gameToAdjust]!);
        }
      }
    }

    _calculateTotalWeight(); // Final recalculation to confirm 100%

    if (mounted) {
      setState(() {
        isLoading = false; // Set isLoading to false after all calculations are done
      });
    }
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
    // Não é necessário chamar setState aqui, pois este método é frequentemente chamado dentro de outro setState
    // ou antes de um setState final em _initWeights.
    // Se você precisar atualizar a UI imediatamente após isso, chame setState explicitamente.
    isWeightValid = totalWeight == 100;
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
      // Salva no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      for (var entry in weights.entries) {
        await prefs.setDouble('weight_${entry.key}', entry.value);
      }

      // Atualiza os pesos no GameHandler
      GameHandler.gameWeights = Map.from(weights);
    } catch (e) {
      // Lida com erros, por exemplo, mostrando uma SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar pesos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.pop(context); // Volta para a tela anterior após salvar
      }
    }
  }

  Future<void> _resetWeights() async {
    // Define isLoading como true imediatamente para mostrar feedback
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final prefs = await SharedPreferences.getInstance();
    Set<String> activeGames = _getActiveGameNames();

    // Remove todos os pesos salvos do SharedPreferences para os jogos ativos
    for (var gameName in activeGames) {
      await prefs.remove('weight_$gameName');
    }

    // Reseta os pesos do GameHandler para o estado padrão inicial
    GameHandler.resetGameWeightsToDefault();

    // Chama _initWeights() que irá carregar os pesos padrão do GameHandler,
    // aplicar o mínimo de 1%, normalizar e, finalmente, definir isLoading como false.
    await _initWeights(); // Aguarda _initWeights para garantir que ele seja concluído e atualize o estado

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Probabilidades resetadas para as configurações padrão!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title:
            const Text('Configurar Probabilidades', style: TextStyle(color: Colors.white)),
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
                  color: !isWeightValid ? Colors.red.withValues(alpha: 0.3) : null,
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
                    padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 80), // Margem inferior para o botão
                    children: _getActiveGameNames().map((gameName) {
                      // Garantir que o peso nunca seja menor que 1
                      // This check is also in _initWeights, but good to have here for slider display
                      if (weights[gameName] == null || weights[gameName]! < 1.0) {
                        weights[gameName] = 1.0;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(gameName,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: weights[gameName] ?? 1.0,
                                  min: 1.0, // Mínimo de 1%
                                  max: 100,
                                  divisions: 99, // 1 a 100 em incrementos de 1
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white.withValues(alpha: 0.3),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Adjust bottom padding for both buttons
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "resetBtn", // Unique tag for multiple FABs
              onPressed: isLoading ? null : _resetWeights, // Disable if loading
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 16), // Space between buttons
            FloatingActionButton(
              heroTag: "saveBtn", // Unique tag for multiple FABs
              onPressed: isWeightValid && !isLoading ? _saveWeights : null, // Disable if invalid or loading
              backgroundColor: Colors.white,
              foregroundColor: settingsColor,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}