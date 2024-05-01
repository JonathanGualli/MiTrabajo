import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mi_trabajo/screens/register_screen.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:mi_trabajo/providers/auth_provider.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/services/snackbar_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthProvider? _auth;

  bool formEmailStatus = false;
  bool formPasswordStatus = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    SnackBarService.instance.buildContext = context;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: loginPageUI(),
      ),
    );
  }

  Widget loginPageUI() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.screenWidth * 0.16,
        //vertical: Dimensions.screenHeight * 0.05,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageLogin(),
            loginWithSocialNetoworks(),
            inputForm(),
            loginButtom(),
            registerButtom(),
          ],
        ),
      ),
    );
  }

  Widget imageLogin() {
    return //Padding(
        //padding: const EdgeInsets.only(bottom: 23),
        //child:
        Center(
      child: Image.asset(
        "assets/logoAzul.png",
        height: Dimensions.screenWidth * 0.5,
      ),
    );
  }

  Widget loginWithSocialNetoworks() {
    return SizedBox(
      height: Dimensions.screenHeight * 0.2,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Iniciar sesión con: ",
            style: TextStyle(
                color: Colores.morado,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [googleButton(), facebookButton()],
          ),
          const Center(
            child: Text("- O -",
                style: TextStyle(
                    color: Colores.morado,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget googleButton() {
    return ElevatedButton(
      onPressed: () async {
        await _auth!.signInWithGoogle();
      },
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colores.morado),
          fixedSize: const MaterialStatePropertyAll(Size(122, 44)),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget facebookButton() {
    return ElevatedButton(
      onPressed: () {
        _auth!.logoutUser();
      },
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colores.azul),
          fixedSize: const MaterialStatePropertyAll(Size(122, 44)),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.facebook_sharp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget inputForm() {
    return SizedBox(
      height: Dimensions.screenHeight * 0.17,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Center(
      child: SizedBox(
        width: Dimensions.screenWidth * 0.65,
        child: TextFormField(
          controller: emailController,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          validator: (input) {
            if (input!.isEmpty) {
              return 'Ingrese su correo electrónico';
            }
            return null;
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.all(1),
            hintText: "Correo electrónico",
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colores.azul,
            prefixIconColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Center(
      child: SizedBox(
        width: Dimensions.screenWidth * 0.65,
        child: TextFormField(
          controller: passwordController,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          validator: (input) {
            if (input!.isEmpty) {
              return 'Ingrese su contraseña';
            }
            return null;
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: const Icon(Icons.lock),
            contentPadding: const EdgeInsets.all(1),
            hintText: "Contraseña",
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colores.azul,
            prefixIconColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButtom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No estás registrado?',
            style: TextStyle(color: Colores.azul, fontSize: 14)),
        TextButton(
          onPressed: () {
            NavigationService.instance
                .navigatePushName(RegisterScreen.routeName);
          },
          child: const Text(
            'Crear Cuenta',
            style: TextStyle(
                color: Color(0xFFFF00E5),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget loginButtom() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        width: Dimensions.screenWidth * 0.45,
        height: Dimensions.screenHeight * 0.055,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colores.morado),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)))),
          onPressed: _auth!.status == AuthStatus.authenticating
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    _auth!.loginWithEmailAndPassword(
                        emailController.text, passwordController.text);
                  }
                },
          child: _auth!.status == AuthStatus.authenticating
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white, size: 30)
              : const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
      ),
    );
  }
}
