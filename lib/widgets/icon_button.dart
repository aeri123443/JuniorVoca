import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class LargeIconButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;

  const LargeIconButton({
    super.key,
    required this.icon,
    this.iconSize = 150,
    required this.onPressed,
  });

  @override
  State<LargeIconButton> createState() => _LargeIconButtonState();
}

class _LargeIconButtonState extends State<LargeIconButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1/1, 
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: IconButton(
          color: AppColors.textSecondary,
          icon: Icon(widget.icon),
          padding: EdgeInsets.zero,
          iconSize: widget.iconSize,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
