import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_trabajo/screens/activisys_screen.dart';
import 'package:mi_trabajo/screens/add_activity_screen.dart';
import 'package:mi_trabajo/screens/configuration_screen.dart';
import 'package:mi_trabajo/screens/create_custom_activity.dart';
import 'package:mi_trabajo/widgets/bn_navigation.dart';
import 'package:mi_trabajo/screens/home_screen.dart';
import 'package:mi_trabajo/screens/login_screen.dart';
import 'package:mi_trabajo/screens/logo_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mi_trabajo/screens/register_screen.dart';
import 'package:mi_trabajo/providers/auth_provider.dart';
import 'package:mi_trabajo/providers/global_variables_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:mi_trabajo/services/navigation_service.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  //Se asegura de que se ejecuten todas las inicializaciones antes de correr el proyecto
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('es', null).then((_) {
    runApp(const MyApp());
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5FAFF),
        statusBarIconBrightness: Brightness.dark),
  );

  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider.instance,
        ),
        ChangeNotifierProvider<GlobalVariables>(
          create: (context) => GlobalVariables.instance,
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.instance.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        //initialRoute: CreateCustomActiviy.routeName,
        routes: {
          LogoScreen.routeName: (context) => const LogoScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          AddActivityScreen.routeName: (context) => const AddActivityScreen(),
          ActivitysScreen.routeName: (context) => const ActivitysScreen(),
          BNavigation.routeName: (contest) => const BNavigation(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ConfigurationScreen.routeName: (context) =>
              const ConfigurationScreen(),
          CreateCustomActiviy.routeName: (context) =>
              const CreateCustomActiviy(),
        },
      ),
    );
  }
}
 
/* 
import 'package:flutter/material.dart';
import 'package:mi_trabajo/databases_sqlite/customa_database.dart';
import 'package:mi_trabajo/models/database_models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Trabajo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ActividadesScreen(),
    );
  }
}

class ActividadesScreen extends StatefulWidget {
  @override
  _ActividadesScreenState createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  List<ActivityModel> activities = [];

  @override
  void initState() {
    super.initState();
    cargarDatos(); // Carga los datos al iniciar la pantalla
  }

  Future<void> cargarDatos() async {
    // Obtén todas las actividades de la base de datos
    activities = await CustomADatabase.instance.getActivities();
    setState(() {}); // Actualiza la pantalla después de cargar los datos
  }

  Future<void> agregarActividad() async {
    // Crea una nueva actividad
    ActivityModel nuevaActividad = ActivityModel.noID(
// ID autoincremental, se llenará automáticamente
        DateTime.now().day.toString(), // Fecha actual
        'Tipo de actividad', // Tipo de actividad
        'Detalles de la actividad', // Detalles de la actividad
        10.0, // Precio
        1, // Cantidad
        'Estado'); // Estado

    // Agrega la nueva actividad a la base de datos
    await CustomADatabase.instance.addActivity(nuevaActividad);

    // Vuelve a cargar los datos para reflejar los cambios en la pantalla
    await cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(activities[index].activityType),
            subtitle: Text(
                'Detalles: ${activities[index].details}, Precio: ${activities[index].price.toString()}, id" ${activities[index].activityId.toString()}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            agregarActividad, // Agregar una nueva actividad al presionar el botón de acción flotante
        child: Icon(Icons.add),
      ),
    );
  }
}
 */