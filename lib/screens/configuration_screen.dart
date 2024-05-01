import 'package:flutter/material.dart';
import 'package:mi_trabajo/providers/auth_provider.dart';

class ConfigurationScreen extends StatelessWidget {
  static const routeName = "/configuration";

  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          AuthProvider.instance.logoutUser();
        },
        child: const Text("Cerrar sesión"),
      )),
    );
  }
}
