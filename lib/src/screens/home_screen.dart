import 'package:alcoolize/src/screens/players_screen.dart';
import 'package:alcoolize/src/screens/settings_screen.dart';
import 'package:alcoolize/src/language_selector.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../localization/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isPressed = false;
  static const homeColor = GameColors.home;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeColor, 
      appBar: AppBar(
        backgroundColor: homeColor,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: LanguageSelector(),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            icon: const Icon(Icons.settings, size: 40, color: Colors.white,),
            onPressed: () {
              // Navigate to settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),// Purple background
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container for image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent, // Substitua por sua imagem
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.no_drinks, // Temporary icon, can also be an image
                  color: Colors.white, // Purple icon
                  size: 120,
                ),
              ),
              const SizedBox(height: 30), // Space between image and button
              
              // "Alcoolize-se" button
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _isPressed = false;
                     Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => PlayersScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _isPressed = false;
                  });
                },
                child: AnimatedContainer(
                  duration: GameConstants.buttonAnimationDuration,
                  width: 250,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _isPressed ? Colors.white : Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.alcoolizeSe,
                      style: TextStyle(
                        color: _isPressed ? homeColor : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 100),
            ],
          ),
        
        ),
        
      ),
    );
  }
}