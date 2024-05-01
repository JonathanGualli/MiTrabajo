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
