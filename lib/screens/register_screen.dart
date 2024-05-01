import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:mi_trabajo/providers/auth_provider.dart';
import 'package:mi_trabajo/providers/global_variables_provider.dart';
import 'package:mi_trabajo/services/cloud_storage.dart';
import 'package:mi_trabajo/services/db_service.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/services/snackbar_service.dart';
import 'package:mi_trabajo/widgets/app_icon.dart';
import 'package:mi_trabajo/widgets/image_circle.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = "/userRegister";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: registerPageUI(),
      ),
    );
  }

  Widget registerPageUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      _auth = Provider.of<AuthProvider>(context);
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.screenWidth * 0.16,
            //vertical: Dimensions.screenHeight * 0.05,
          ),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              textTittle(),
              inputForm(),
              registerButtom(),
            ],
          )));
    });
  }

  Widget textTittle() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: Dimensions.screenWidth * 0.06),
          child: GestureDetector(
            child: const AppIcon(
              icon: Icons.arrow_back_ios_new_outlined,
              size: 35,
            ),
            onTap: () {
              NavigationService.instance.goBack();
            },
          ),
        ),
        const Text(
          "Registrarse",
          style: TextStyle(
              color: Colores.morado, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget inputForm() {
    return SizedBox(
      height: Dimensions.screenHeight * 0.8,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //imageSelectorWidget(),
            const ImageCircle(
              imagePath: "assets/profileImage.png",
              isRegister: true,
            ),
            nameTextField(),
            emailTextField(),
            phoneTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Nombre:',
              style: TextStyle(
                fontSize: 20,
                color: Colores.morado,
              )),
        ),
        Center(
          child: SizedBox(
            width: Dimensions.screenWidth * 0.65,
            child: TextFormField(
              controller: nameController,
              autocorrect: false,
              style: const TextStyle(color: Colors.white),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su nombre';
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
                prefixIcon: const Icon(Icons.account_box_rounded),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Nombre",
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
        ),
      ],
    );
  }

  Widget emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Dirección de correo:',
              style: TextStyle(
                fontSize: 20,
                color: Colores.morado,
              )),
        ),
        Center(
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
        ),
      ],
    );
  }

  Widget phoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Número telefónico:',
              style: TextStyle(
                fontSize: 20,
                color: Colores.morado,
              )),
        ),
        Center(
          child: SizedBox(
            width: Dimensions.screenWidth * 0.65,
            child: TextFormField(
              controller: phoneController,
              autocorrect: false,
              style: const TextStyle(color: Colors.white),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su número de teléfono';
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
                prefixIcon: const Icon(Icons.phone_android),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Número telefónico",
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
        ),
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Contraseña:',
              style: TextStyle(
                fontSize: 20,
                color: Colores.morado,
              )),
        ),
        Center(
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
        ),
      ],
    );
  }

  Widget registerButtom() {
    return SizedBox(
      width: Dimensions.screenWidth * 0.45,
      height: Dimensions.screenHeight * 0.055,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colores.morado),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        onPressed: _auth!.status == AuthStatus.registering
            ? null
            : () async {
                if (GlobalVariables.instance.getTemporalImage() == null) {
/*                   SnackBarService.instance.showSnackBar(
                      "Por favor ingresa una imagen para tu perfil", false); */
                  _auth!.registerUserWithEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                    (String uid) async {
                      await DBService.instance.createdUserInDB(
                        uid,
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        "https://firebasestorage.googleapis.com/v0/b/mi-trabajo-c8b17.appspot.com/o/profileImage.png?alt=media&token=9879f1c7-30dc-40d1-baf3-5478d229313b",
                      );
                    },
                  );
                } else {
                  if (formKey.currentState!.validate()) {
                    _auth!.registerUserWithEmailAndPassword(
                        emailController.text, passwordController.text,
                        (String uid) async {
                      await CloudStorageService.instance
                          .uploadImage(
                              uid,
                              GlobalVariables.instance.getTemporalImage()!,
                              "profile_images")
                          .then((result) async {
                        var imageURL = await result!.ref.getDownloadURL();
                        await DBService.instance.createdUserInDB(
                            uid,
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            imageURL);
                      });
                    });
                  }
                }
              },
        child: _auth!.status == AuthStatus.registering
            ? LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white, size: 30)
            : const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
