import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

class GameInfoDialog extends StatelessWidget {
  final String instructions;
  
  const GameInfoDialog({
    super.key,
    required this.instructions,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        instructions,
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  
  static void show(BuildContext context, String instructions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameInfoDialog(instructions: instructions);
      },
    );
  }
}