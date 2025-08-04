import 'package:flutter/material.dart';

class GameFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? child;
  final String? tooltip;
  
  const GameFloatingActionButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    required this.foregroundColor,
    this.child,
    this.tooltip,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        tooltip: tooltip,
        child: child ?? const Icon(Icons.arrow_forward),
      ),
    );
  }
}