import 'package:flutter/material.dart';
import 'package:mi_trabajo/utils/dimensions.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});

  static const routeName = "/logo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF28DF99),
      backgroundColor: const Color(0xFFF3F8FF),
      //backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logoAzul.png",
              width: Dimensions.screenWidth * 0.8,
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.screenHeight * 0.01),
              child: const Text(
                "Mi Trabajo",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white,
                  color: Color(0xFF5271FF),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
