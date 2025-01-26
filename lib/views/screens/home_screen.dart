import 'package:barberapp/services/cliente_service.dart';
import 'package:barberapp/views/screens/pendiente_screen.dart';
import 'package:barberapp/views/screens/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/cita_service.dart';
import '../../services/servicio_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedOption = 'Pendiente';

  final List<Map<String, dynamic>> menuOptions = [
    {'title': 'Pendiente', 'screen': const MostrarCitasScreen(), 'icon': Icons.receipt_long},
    {'title': 'Clientes', 'screen': const ClientsScreen(), 'icon': Icons.supervised_user_circle_outlined},
    {'title': 'Servicios', 'screen': const ServicesScreen(), 'icon': Icons.cut},
    {'title': 'Citas', 'screen': const GuardarCitaScreen(), 'icon': Icons.date_range},
    {'title': 'Reportes', 'screen': const ReportScreen(), 'icon': Icons.report},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
          title: const Text('Barberia Style', style: TextStyle(color: Color.fromRGBO(126, 217, 87, 1), fontSize: 20, fontWeight: FontWeight.bold)),
          foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(31, 31, 31, 1),
                ),
                child: Center(
                  child: Text(
                    'Menú de Gestión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Padding(padding: EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.lgUkeZHLrJZ56CXxgnRzMgHaHa?rs=1&pid=ImgDetMain'),
                  ),),
                title: const Text('Ver Perfil', style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  });
                },
              ),
              const Divider(),
              // Generar dinámicamente los ListTile
              ...menuOptions.map((option) => ListTile(
                leading: Icon(option['icon'], color: const Color.fromRGBO(126, 217, 87, 1)),
                title: Text(option['title'], style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedOption = option['title'];
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => option['screen']),
                    );
                  });
                },
              )),
            ],
          ),
        ),
        body: const Center(
          child: CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.lgUkeZHLrJZ56CXxgnRzMgHaHa?rs=1&pid=ImgDetMain'),
          ),
        )
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        centerTitle: true,
        title: const Text('Citas pendientes', style: TextStyle(color: Color.fromRGBO(126, 217, 87, 1), fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: const MostrarCitasScreen(),
    );
  }
}

class BarbersScreen extends StatelessWidget {
  const BarbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barberos'),
      ),
      body: const Center(
        child: Text('Pantalla de Barberos'),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        title: const Text('Perfil de usuario',
            style: TextStyle(
                color: Color.fromRGBO(126, 217, 87, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.lgUkeZHLrJZ56CXxgnRzMgHaHa?rs=1&pid=ImgDetMain'), 
            ),
            const SizedBox(height: 20),
            const Text(
              'Julio Goicochea Robles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsetsDirectional.only(top: 15, bottom: 15, end: 50, start: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
              ),
              child: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signOut();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsetsDirectional.only(top: 15, bottom: 15, end: 50, start: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
              ),
              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
