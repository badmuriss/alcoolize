import 'package:alcoolize/src/game_handler.dart';
import 'package:flutter/material.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  int playerCount = 1; // Valor inicial do contador
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  List<String> playersList = []; // Lista para armazenar os nomes dos jogadores

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A0DAD),
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela inicial
          },
        ),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Adicionando o Form
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Cor transparente para o container
                  borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Texto "Quantidade de Jogadores"
                    const Text(
                      'Quantos Jogadores?',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Contador de jogadores
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white),
                          onPressed: playerCount > 1
                              ? () {
                                  setState(() {
                                    playerCount--;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          '$playerCount',
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: playerCount < 18
                              ? () {
                                  setState(() {
                                    playerCount++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Gerar campos de input com base no contador
              Expanded(
                child: ListView.builder(
                  itemCount: playerCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '${index + 1}° vítima',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um nome';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (index < playersList.length) {
                            playersList[index] = value; // Atualiza o nome do jogador
                          } else {
                            playersList.add(value); // Adiciona novo nome à lista
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              // Adicionar espaçamento entre os campos de texto e o botão
              const SizedBox(height: 40), // Aumentar o espaçamento acima do botão

              // Botão "Começar o Jogo" alinhado mais acima
              Align(
                alignment: Alignment.bottomCenter, // Alinha o botão na parte inferior
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Se o formulário for válido, exiba a mensagem
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Jogo iniciado com $playerCount ${playerCount > 1 ? 'jogadores' : 'jogador'}!'),
                        ),
                      );
                      GameHandler.resetUsedWords();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameHandler.chooseRandomGame(context, playersList), // Chama a função que escolhe aleatoriamente o jogo
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF6A0DAD), 
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Começar o Jogo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0DAD),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
