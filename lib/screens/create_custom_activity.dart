import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:mi_trabajo/databases_sqlite/customa_database.dart';
import 'package:mi_trabajo/models/database_models.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/services/snackbar_service.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:mi_trabajo/utils/styles.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:mi_trabajo/widgets/app_icon.dart';

class CreateCustomActiviy extends StatefulWidget {
  const CreateCustomActiviy({super.key});

  static const routeName = "/CreateCustomActivity";

  @override
  State<CreateCustomActiviy> createState() => _CreateCustomActiviyState();
}

class _CreateCustomActiviyState extends State<CreateCustomActiviy> {
  late Color dialogPickerColor;
  late IconData _icon;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dialogPickerColor = Colors.blue; // Material blue.
    _icon = const IconData(
      62531,
      fontFamily: iconFont,
      fontPackage: iconFontPackage,
    );
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFf5faff),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: createCustomIconPageUI(),
        ),
      ),
    );
  }

  Widget createCustomIconPageUI() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.screenWidth * 0.1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          textTittle(),
          inputForm(),
          selectColor(),
          selectIcon(),
          preview(),
          createButton()
        ],
      ),
    );
  }

  SizedBox createButton() {
    return SizedBox(
      width: double.infinity,
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
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            CustomActivityModel customActivity = CustomActivityModel(
                nameController.text,
                double.parse(priceController.text),
                _icon.codePoint,
                dialogPickerColor.hex);
            await CustomADatabase.instance
                .addCustomActivity(customActivity)
                .then((info) {
              if (info == "true") {
                NavigationService.instance.goBack();
              } else if (info == "existe") {
                SnackBarService.instance.showSnackBar(
                    "Ya existe una actividad con ese nombre", false);
              } else {
                SnackBarService.instance
                    .showSnackBar("A ocurrido un error", false);
              }
            });

            //print(customActivity.toJson());
          }
        },
        child: const Text(
          'Crear',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget inputForm() {
    return SizedBox(
      height: Dimensions.screenHeight * 0.28,
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
            nameActivity(),
            priceActivity(),
          ],
        ),
      ),
    );
  }

  Widget textTittle() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: const AppIcon(
              icon: Icons.arrow_back_ios_new_outlined,
              size: 40,
            ),
            onTap: () {
              NavigationService.instance.goBack();
            },
          ),
          const Expanded(
            child: Text(
              "Crear actividad rápida",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colores.azul,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget preview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Vista previa',
            style: TextStyle(
              fontSize: 20,
              color: Colores.azul,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          //color: Colors.red,
          decoration: BoxDecoration(
            border: Border.all(color: Colores.morado, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            children: [
              Container(
                width: Dimensions.screenWidth * 0.3,
                height: Dimensions.screenWidth * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape
                      .circle, // Establece la forma del contenedor como un círculo
                  color: dialogPickerColor, // Color del círculo
                ),
                child: Icon(
                  IconData(_icon.codePoint,
                      fontFamily: iconFont, fontPackage: iconFontPackage),
                  size: 70,
                  color: esColorClaro(dialogPickerColor)
                      ? const Color.fromARGB(255, 187, 165, 219)
                      : Colors.white,
                  //color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: nameController.text.isEmpty
                    ? const Text(
                        "Nombre",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colores.morado,
                        ),
                      )
                    : Text(
                        nameController.text,
                        style: const TextStyle(
                            fontSize: 20, color: Colores.morado),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget selectIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Selecciona un icono: ",
          style: Styles.style1,
        ),
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colores.background),
              elevation: MaterialStatePropertyAll(0)),
          onPressed: () {
            pickIcon();
          },
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _icon,
                size: 55,
                color: Colors.blue,
              )),
        )
      ],
    );
  }

  Widget selectColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Selecciona un color: ',
          style: Styles.style1,
        ),
        SizedBox(
          height: Dimensions.screenHeight * 0.05,
          width: Dimensions.screenWidth * 0.25,
          child: FloatingActionButton(
            onPressed: () async {
              final Color colorBeforeDialog = dialogPickerColor;

              if (!(await colorPickerDialog())) {
                setState(() {
                  dialogPickerColor = colorBeforeDialog;
                });
              }
            },
            backgroundColor: dialogPickerColor,
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget nameActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Nombre de la actividad:',
            style: Styles.style1,
          ),
        ),
        TextFormField(
          controller: nameController,
          validator: (input) {
            if (input!.isEmpty) {
              return 'Ingrese el nombre de la actividad';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {});
          },
          style: const TextStyle(
              color: Colors.blue, fontSize: 19, fontWeight: FontWeight.bold),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: const Icon(Icons.favorite),
            contentPadding: const EdgeInsets.all(1),
            hintText: "Nombre",
            hintStyle: const TextStyle(
              color: Colors.white60,
            ),
            filled: true,
            fillColor: const Color(0xFFE5D4FF),
            prefixIconColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
    );
  }

  Widget priceActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Precio: ',
            style: Styles.style1,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: priceController,
          validator: (input) {
            if (input!.isEmpty) {
              return 'Ingrese el precio de la actividad';
            }
            return null;
          },
          style: const TextStyle(
              color: Colors.blue, fontSize: 19, fontWeight: FontWeight.bold),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: const Icon(Icons.monetization_on),
            contentPadding: const EdgeInsets.all(1),
            hintText: "Precio de actividad",
            hintStyle: const TextStyle(
              color: Colors.white60,
            ),
            filled: true,
            fillColor: const Color(0xFFE5D4FF),
            prefixIconColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Selecciona el color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Selecciona el tono del color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
/*       wheelSubheading: Text(
        ' color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ), */
      //showMaterialName: true,
      //showColorName: true,
      //showColorCode: true,
/*       copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ), */
      //materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      //colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      //colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: false,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  Future<bool> pickIcon() async {
    IconData? icon = await showIconPicker(context,
        iconPackModes: [IconPack.cupertino],
        iconColor: Colors.blue,
        showSearchBar: false,
        title: const Text(
          'Selecciona un icono',
          style: TextStyle(
            color: Colores.azul,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        showTooltips: true);

    if (icon == null) {
      return false;
    } else {
      setState(() {
        _icon = icon;
        //debugPrint('Picked Icon:  $icon');
        /*  _icon = Icon(
          icon,
          size: 55,
          color: Colors.blue,
        ); */
      });

      return true;
    }
  }

  bool esColorClaro(Color color) {
    final luminancia = color.computeLuminance();
    return luminancia >
        0.9; // Considera el color como claro si la luminancia es mayor que 0.5
  }
}
