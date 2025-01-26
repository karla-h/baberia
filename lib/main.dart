import 'package:barberapp/services/cita_service.dart';
import 'package:barberapp/services/servicio_service.dart';
import 'package:barberapp/views/screens/home_screen.dart';
import 'package:barberapp/views/screens/login_screen.dart';
import 'package:barberapp/views/screens/pendiente_screen.dart';
import 'package:barberapp/views/screens/report_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const MyHomePage(),
        '/login': (context) => const LoginScreen(),
        '/pendientes': (context) => const MostrarCitasScreen(),
        '/barberos': (context) => const BarbersScreen(),
        '/servicios': (context) => const ServicesScreen(),
        '/citas': (context) => const GuardarCitaScreen(),
        'reports': (context) => const ReportScreen(),
      },
    );
  }
}
