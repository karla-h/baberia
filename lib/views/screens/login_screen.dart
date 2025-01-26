import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/servicio_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 15, left: 15),
        ),
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 15, right: 30),
            child: const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.lgUkeZHLrJZ56CXxgnRzMgHaHa?rs=1&pid=ImgDetMain'),
          ),
          ),
        ],
        title: const Text(""),
        centerTitle: true,
      ),
      body: const AuthenticationChecker(),
    );
  }
}

class AuthenticationChecker extends StatelessWidget {
  const AuthenticationChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/');
            });
            return Container();
          } else {
            return const LoginScreenForm();
          }
        }
      },
    );
  }
}

class LoginScreenForm extends StatefulWidget {
  const LoginScreenForm({super.key});

  @override
  State<LoginScreenForm> createState() => _LoginScreenFormState();
}

class _LoginScreenFormState extends State<LoginScreenForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        print("Error logging in: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(height: 70),
              const Row(
                children: <Widget>[
                  Text("Bienvenido a ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  Text("Style",
                      style: TextStyle(
                          color: Color.fromRGBO(126, 217, 87, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('Tu barbería de confianza',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Container(height: 60),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: 'E-mail / Username',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su correo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                },
              ),
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                    const Text(
                      'Recuérdame',
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  const Text('¿Olvidó su contraseña?',
                      style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () => _submitForm(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
                ),
                child: const Text('INICIAR SESIÓN',
                    style: TextStyle(
                        color: Color.fromRGBO(31, 31, 31, 1),
                        fontWeight: FontWeight.bold,
                        height: 2)),
              ),
              Container(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServicesScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(37, 37, 37, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), 
                    side: const BorderSide(
                        color: Color.fromARGB(122, 117, 127, 120)),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20), 
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'INGRESAR COMO INVITADO',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 3),
                    Icon(
                      Icons.person_outline_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
              Container(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(width: 10),
                  const Text('Registrate ahora',
                      style:
                          TextStyle(color: Color.fromRGBO(126, 217, 87, 1))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
