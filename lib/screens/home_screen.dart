import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:mi_trabajo/models/custon_activity_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mi_trabajo/databases_sqlite/customa_database.dart';
import 'package:mi_trabajo/screens/activisys_screen.dart';
import 'package:mi_trabajo/screens/add_custom_activity_screen.dart';
import 'package:mi_trabajo/screens/create_custom_activity.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:mi_trabajo/models/user_%20model.dart';
import 'package:mi_trabajo/services/db_service.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
import 'package:mi_trabajo/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    // Llamada a getUserData desde la clase MyHomePage
    //Future.delayed(const Duration(milliseconds: 500), () {
    DBService.instance.getUserData.then((userData) {
      setState(() {
        this.userData = userData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5faff),
      body: SafeArea(
        child: userData == null
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colores.morado, size: 50),
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                  Dimensions.screenWidth * 0.08,
                  Dimensions.screenHeight * 0.03,
                  Dimensions.screenWidth * 0.08,
                  0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Header(userData: userData),
                    PorCobrarInfo(userData: userData),
                    quickActivities(),
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          "Ampliando funcionalidades",
                          style: Styles.style1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
      //floatingActionButton: const FloatingButton(),
    );
  }

  SizedBox quickActivities() {
    return SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            "Actividades rápidas",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colores.azul),
          ),
        ),
        FutureBuilder(
          future: CustomADatabase.instance.getAllCustomA(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CustomActivityModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colores.azul, size: 40),
              );
            }
            if (snapshot.hasError) {
              return Text("Error ${snapshot.error}");
            }

            List<CustomActivityModel>? customActivity = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    children: customActivity.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCustomActivity(
                                    customActivityModel: activity),
                              ),
                            );
                          },
                          onLongPress: () async {
                            await CustomADatabase.instance
                                .deleteCustomA(activity.nameActivity)
                                .then((_) {
                              setState(() {});
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      Color(int.parse("0xFF${activity.color}")),
                                ),
                                child: Icon(
                                  IconData(activity.icon,
                                      fontFamily: iconFont,
                                      fontPackage: iconFontPackage),
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  activity.nameActivity,
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await NavigationService.instance
                              .navigatePushName(CreateCustomActiviy.routeName)
                              .then((value) => setState(() {}));
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colores.morado),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Crear",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        )
      ]),
    );
  }
}

class PorCobrarInfo extends StatelessWidget {
  const PorCobrarInfo({
    super.key,
    required this.userData,
  });

  final UserData? userData;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimensions.screenHeight * 0.13,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Total por cobrar:",
                style: TextStyle(color: Colores.azul, fontSize: 16),
              ),
              Text(
                "\$ ${userData!.totalPendiente.toStringAsFixed(2)}",
                style: const TextStyle(
                    color: Color(0xFF15CDA1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.userData,
  });

  final UserData? userData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.screenHeight * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.screenWidth * 0.04),
            child: CircleAvatar(
              radius: (Dimensions.screenHeight * 0.08) / 2,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(userData!.image),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenido,",
                  style:
                      TextStyle(color: Colors.blueGrey.shade300, fontSize: 18),
                ),
                Text(
                  "${userData!.name.split(' ')[0]}!",
                  style: const TextStyle(
                    color: Colores.azul,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => NavigationService.instance
                .navigatePushName(ActivitysScreen.routeName),
            child: const Icon(
              Icons.notifications_active_sharp,
              color: Colores.morado,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colores.morado,
      onPressed: () {
/*         CustomActivityModel customActivity =
            CustomActivityModel("Bordado", 0.25, "earbuds", "0xff61e683");
        CustomADatabase.instance.addCustomActivity(customActivity); */
        //CustomADatabase.instance.deleteCustomA("Corte");
        //CustomADatabase.instance.close();
        //0print(Icons.abc.codePoint);
        //print("prueba de que funciono");
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}
