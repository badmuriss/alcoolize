import 'package:flutter/material.dart';
import '../../constants/game_constants.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback onClose;
  final VoidCallback onInfo;
  
  const GameAppBar({
    super.key,
    required this.backgroundColor,
    required this.onClose,
    required this.onInfo,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.close, 
          color: Colors.white, 
          size: GameSizes.appBarIconSize
        ),
        onPressed: onClose,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info, 
            color: Colors.white, 
            size: GameSizes.appBarIconSize
          ),
          onPressed: onInfo,
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}