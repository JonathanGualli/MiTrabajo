import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mi_trabajo/databases_sqlite/customa_database.dart';
import 'package:mi_trabajo/models/database_models.dart';
import 'package:mi_trabajo/screens/add_activity_screen.dart';
import 'package:mi_trabajo/screens/edit_activity_screen.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/utils/dimensions.dart';
import 'package:mi_trabajo/models/activity_model.dart';
import 'package:mi_trabajo/services/db_service.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
//ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ActivitysScreen extends StatefulWidget {
  const ActivitysScreen({super.key});

  static const routeName = "/activitys";

  @override
  State<ActivitysScreen> createState() => _ActivitysScreenState();
}

class _ActivitysScreenState extends State<ActivitysScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5FAFF),
          bottom: const TabBar(
            tabs: [
              Tab(text: ("TODAS")),
              Tab(text: ("PENDIENTES")),
              Tab(text: ("PAGADAS")),
              Tab(text: ("REPORTES")),
            ],
            unselectedLabelStyle: TextStyle(
              color: Colores.azul,
            ),
            labelStyle: TextStyle(
                color: Colores.azul, fontWeight: FontWeight.bold, fontSize: 13),
            indicatorColor: Colores.azul,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          title: const Center(
            child: Text(
              "Actividades",
              style: TextStyle(
                color: Colores.azul,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        floatingActionButton: const FloatingButton(),
        //backgroundColor: Colors.white,
        backgroundColor: const Color(0xFFF5FAFF),
        body: const TabBarView(
          children: <Widget>[
            ActivityScreenUI(filter: ''),
            ActivityScreenUI(filter: 'Pendiente'),
            ActivityScreenUI(filter: 'Pagado'),
            ActivityScreenUI(filter: ''),
          ],
        ),
      ),
    );
  }
}

class ActivityScreenUI extends StatelessWidget {
  final String filter;
  const ActivityScreenUI({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: FutureBuilder(
                future: CustomADatabase.instance.getActivities(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colores.azul, size: 40),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Error ${snapshot.error}");
                  }
                  List<ActivityModel>? activityModel = snapshot.data!;

                  return snapshot.hasData
                      ? activityModel.isEmpty
                          ? const Text("no hay data")
                          : ListView.builder(
                              itemCount: activityModel.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title:
                                      Text(activityModel[index].activityType),

                                  // Agrega más widgets para mostrar otros datos del modelo de actividad
                                );
                              },
                            )
                      //Text(activityModel.length.toString())
                      : Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.blue, size: 30),
                        );
                }),
          ),
          //ListActivitys(filter: filter),
        ],
      ),
    );
  }
}

class ListActivitys extends StatelessWidget {
  final String filter;
  const ListActivitys({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: DBService.instance.getActivitisStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colores.azul, size: 40),
            );
          }
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }

          List<ActivityData>? activityData = filter != ''
              ? snapshot.data!
                  .where((activity) => activity.state == filter)
                  .toList()
              : snapshot.data!;

          return snapshot.hasData
              ? activityData.isEmpty
                  // POR HACER
                  ? const Text("LOsiento no hay datos xd")
                  : ListView.builder(
                      itemCount: activityData.length,
                      itemBuilder: (context, index) {
                        final activity = activityData[index];

                        return Dismissible(
                          key: Key(activityData[index].activityId),
                          //direction: DismissDirection.endToStart,
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            if (direction.name == "endToStart") {
                              DBService.instance.deleteActivity(
                                  activity.activityId,
                                  (activity.price * activity.quantity),
                                  activity.state);
                              DismissUpdateDetails();
                            }

                            //Hay que tener en cuenta que nunca se va a dar este caso, porque en el confirmDismiss siempre va a dar false.
/*                             if (direction.name == "startToEnd") {
                              DBService.instance
                                  .changeState(activity.activityId);
                            } */
                          },
                          confirmDismiss: (direction) async {
                            bool? result = false;

                            if (direction.name == "startToEnd") {
                              DBService.instance.changeState(
                                  activity.activityId,
                                  activity.state,
                                  (activity.price * activity.quantity));
                            }
                            if (direction.name == "endToStart") {
                              result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "¿Estas seguro de eliminar esta actividad?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          return Navigator.pop(context, false);
                                        },
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text(
                                          "Si, estoy seguro",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 118, 108),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return result;
                          },
                          secondaryBackground: Container(
                            color: const Color((0xFFFF9B9B)),
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimensions.screenWidth * 0.05),
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          background: Container(
                            color: const Color(0xFFA1EEBD),
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimensions.screenWidth * 0.05),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: activity.state == "Pagado"
                                    ? const Icon(Icons.cancel,
                                        size: 50, color: Colors.white)
                                    : const Icon(
                                        Icons.check_circle,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                          child: Card(
                            //color: Color.fromARGB(255, 255, 255, 255),
                            color: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            elevation: 0.0,

                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.screenWidth * 0.005,
                                vertical: Dimensions.screenHeight * 0.0080),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              leading: /* const CircleAvatar(
                                backgroundColor: Colores.azul,
                                child: Icon(Icons.assignment,
                                    color: Colors.white),
                              ), */
                                  Text(
                                activity.quantity.toString(),
                                style: TextStyle(
                                    //color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue.shade900),
                              ),
                              title: Text(
                                activity.activityType,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.blue.shade900
                                    //color: Colors.blue,
                                    ),
                              ),
                              subtitle:
                                  /*                                           Text(
                                    //'dd MMMM y - HH:mm a' para mostarar fecha y hora
                                    DateFormat('dd MMMM y').format(activity
                                        .date), // Fto de fecha y hora legible
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ), */

                                  activity.details.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activity.details,
                                              style: const TextStyle(
                                                  fontSize: 19.0,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colores.azul),
                                            ),
/*                                             Text(
                                              //'dd MMMM y - HH:mm a' para mostarar fecha y hora
                                              DateFormat('dd MMMM', 'es')
                                                  .format(activity
                                                      .date), // Fto de fecha y hora legible
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ) */
                                          ],
                                        )
                                      : /* Text(
                                          //'dd MMMM y - HH:mm a' para mostarar fecha y hora
                                          DateFormat('dd MMMM', 'es').format(
                                              activity
                                                  .date), // Fto de fecha y hora legible
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ), */
                                      null,
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
/*                                   Text(
                                    "\$ ${activity.price}",
                                    style: const TextStyle(fontSize: 14),
                                  ), */
                                  Text(
                                    activity.state,
                                    style: activity.state == "Pendiente"
                                        ? const TextStyle(
                                            color: Color(0xFFFF9B9B),
                                            fontSize: 18)
                                        : const TextStyle(
                                            color: Color.fromARGB(
                                                255, 167, 238, 120),
                                            fontSize: 18),
                                  ),
/*                                   Text(
                                    "total: \$ ${(activity.price * activity.quantity).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colores.azul, fontSize: 17),
                                  ), */
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Detalles de la actividad",
                                          style: TextStyle(
                                            color: Colores.azul,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InformationActivity(
                                              information:
                                                  activity.activityType,
                                              subtitle: "Tipo de actividad: ",
                                            ),
                                            InformationActivity(
                                                information: DateFormat(
                                                        'dd MMMM y - HH:mm a',
                                                        'es')
                                                    .format(activity.date),
                                                subtitle: "Fecha: "),
                                            InformationActivity(
                                                information: activity.details,
                                                subtitle: "Detalles:"),
                                            InformationActivity(
                                                information: activity.quantity
                                                    .toString(),
                                                subtitle: "Cantidad: "),
                                            InformationActivity(
                                                information:
                                                    "\$ ${activity.price.toString()}",
                                                subtitle: "Precio unitario: "),
                                            InformationActivity(
                                                information: activity.state,
                                                subtitle: "Estado: "),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditActivityScreen(
                                                          activityData:
                                                              activity),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "Editar",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              NavigationService.instance
                                                  .goBack();
                                            },
                                            child: const Text(
                                              "Cerrar",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        );
                      },
                    )
              : Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.blue, size: 30),
                );
        }),
      ),
    );
  }
}

class InformationActivity extends StatelessWidget {
  const InformationActivity({
    super.key,
    required this.information,
    required this.subtitle,
  });

  final String information;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          information,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
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
        NavigationService.instance
            .navigatePushName(AddActivityScreen.routeName);
        //print(Timestamp.now().seconds);
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}
