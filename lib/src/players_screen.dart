import 'package:alcoolize/src/game_handler.dart';
import 'package:flutter/material.dart';
import 'localization/generated/app_localizations.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  PlayersScreenState createState() => PlayersScreenState();
}

class PlayersScreenState extends State<PlayersScreen> {
  int playerCount = 1; // Initial counter value
  final _formKey = GlobalKey<FormState>(); // Form key
  List<String> playersList = List.filled(30, ''); // Pre-initialize with empty strings
  List<TextEditingController> controllers = []; // Add controllers for text fields

  @override
  void initState() {
    super.initState();
    // Initialize controllers for all possible players
    for (int i = 0; i < 30; i++) {
      controllers.add(TextEditingController());
    }
  }
  
  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A0DAD),
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Return to initial screen
          },
        ),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Adding the Form
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Transparent color for the container
                  borderRadius: BorderRadius.circular(12), // Rounded borders
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Number of Players" text
                    Text(
                      AppLocalizations.of(context)!.playersQuestion,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Player counter
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
                          onPressed: playerCount < 30
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

              // Generate input fields based on the counter
              Expanded(
                child: ListView.builder(
                  itemCount: playerCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: TextFormField(
                        controller: controllers[index], // Use the controller
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.victimPlaceholder(index + 1),
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            return AppLocalizations.of(context)!.pleaseEnterName;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          playersList[index] = value; // Update the player name
                        },
                      ),
                    );
                  },
                ),
              ),

              // Add spacing between text fields and button
              const SizedBox(height: 40), // Increase spacing above the button

              // "Start Game" button aligned higher
              Align(
                alignment: Alignment.bottomCenter, // Aligns the button at the bottom
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Trim the playersList to the actual number of players
                      List<String> actualPlayers = playersList.sublist(0, playerCount);
                      
                      // Rest of your code
                      GameHandler.resetUsedWords();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameHandler.chooseRandomGame(context, actualPlayers),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF6A0DAD), 
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.startGame,
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
