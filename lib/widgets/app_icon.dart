import 'package:flutter/material.dart';
import 'package:mi_trabajo/utils/colors.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const AppIcon(
      {super.key,
      required this.icon,
      this.backgroundColor = Colores.morado,
      this.iconColor = Colors.white,
      this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 25,
      ),
    );
  }
}
