import 'package:flutter/material.dart';
import 'package:mi_trabajo/models/custon_activity_model.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:mi_trabajo/models/activity_model.dart';
import 'package:mi_trabajo/services/db_service.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/widgets/app_icon.dart';

class AddCustomActivity extends StatefulWidget {
  final CustomActivityModel customActivityModel;
  const AddCustomActivity({super.key, required this.customActivityModel});

  static const routeName = "/add_custom_activity";

  @override
  State<AddCustomActivity> createState() => _AddCustomActivityState();
}

class _AddCustomActivityState extends State<AddCustomActivity> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime date = DateTime.now();
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  TextEditingController activityController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ActivityData? _activity;

  @override
  void initState() {
    super.initState();
    activityController.text = widget.customActivityModel.nameActivity;
    //detailsController.text = widget.customActivityModel.;
    //quantityController.text = widget.customActivityModel.quantity.toString();
    priceController.text = widget.customActivityModel.price.toStringAsFixed(2);
    //date = widget.customActivityModel.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        //child: Stack(children: [icons(), AddCustomActivityUI()]),
        child: addCustomActivityUI(),
      ),
    );
  }

  Widget addCustomActivityUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.screenWidth * 0.12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //icons(),
              textTittle(),
              inputForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget textTittle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        const Text(
          "Añadir actividad",
          style: TextStyle(
              color: Colores.azul, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          child: const AppIcon(
            icon: Icons.add,
            size: 40,
          ),
          onTap: () {
            if (formKey.currentState!.validate()) {
              String details = detailsController.text.isNotEmpty
                  ? detailsController.text
                  : "";
              int quantity = quantityController.text.isNotEmpty
                  ? int.parse(quantityController.text)
                  : 1;

              _activity = ActivityData(
                activityId: "",
                date: date,
                activityType: activityController.text,
                details: details,
                price: double.parse(priceController.text),
                quantity: quantity,
                state: "Pendiente",
              );

              DBService.instance
                  .createdActivityInDB(_activity!)
                  .then((_) => NavigationService.instance.goBack());
            }
          },
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
        onChanged: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            datePiker(),
            activityTextField(),
            detailsTextField(),
            priceTextField(),
            //button(),
          ],
        ),
      ),
    );
  }

  Widget datePiker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Fecha:',
              style: TextStyle(
                fontSize: 23,
                color: Colores.azul,
              )),
        ),
        EasyDateTimeLine(
          onDateChange: (selectedDate) => date = selectedDate,
          locale: "es_ES",
          initialDate: DateTime.now(),
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.dropDown,
            dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
          ),
          dayProps: const EasyDayProps(
            /* inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 238, 240, 255),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ), */
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colores.azul,
                        Colores.morado,
                      ])),
            ),
          ),
        ),
      ],
    );
  }

  Widget activityTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Actividad:',
              style: TextStyle(
                fontSize: 23,
                color: Colores.azul,
              )),
        ),
        Center(
          child: SizedBox(
            //width: Dimensions.screenWidth * 0.56,
            child: TextFormField(
              controller: activityController,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese el nombre de la actividad';
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
                prefixIcon: const Icon(Icons.assignment),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Tipo de actividad",
                hintStyle: const TextStyle(
                  color: Colors.white60,
                ),
                filled: true,
                fillColor: Colores.morado,
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

  Widget detailsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Detalles:',
              style: TextStyle(
                fontSize: 23,
                color: Colores.azul,
              )),
        ),
        Center(
          child: SizedBox(
            //width: Dimensions.screenWidth * 0.56,
            child: TextFormField(
              controller: detailsController,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.white, fontSize: 20),
/*               validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese los detalles';
                }
                return null;
              }, */
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.forum),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Nombre, detalles, descripción",
                hintStyle: const TextStyle(
                  color: Colors.white60,
                ),
                filled: true,
                fillColor: Colores.morado,
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

  Widget priceTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        quantity(),
        price(),
      ],
    );
  }

  Expanded quantity() {
    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Cantidad:',
              style: TextStyle(
                fontSize: 23,
                color: Colores.azul,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              autocorrect: false,
              style: const TextStyle(color: Colors.white, fontSize: 25),
/*                   validator: (input) {
                  if (input!.isEmpty) {
                    return 'Ingresa la cantidad';
                  }
                  return null;
                }, */
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.numbers),
                contentPadding: const EdgeInsets.all(1),
                hintText: "1",
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                filled: true,
                fillColor: Colores.morado,
                prefixIconColor: Colors.white,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded price() {
    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Precio:',
              style: TextStyle(
                fontSize: 23,
                color: Colores.azul,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              autocorrect: false,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingresa el precio unitario';
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
                prefixIcon: const Icon(Icons.attach_money),

                contentPadding: const EdgeInsets.all(1),
                //hintText: "Cantidad",
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                filled: true,
                fillColor: Colores.morado,
                prefixIconColor: Colors.white,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
