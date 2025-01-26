import 'package:barberapp/models/cliente_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'firebase_service.dart';
import 'dart:async';

class ClienteService {
  final CollectionReference _clientesCollection = DBFire.collection('clientes');

  Future<List<Cliente>> getClientList() async {
    QuerySnapshot querySnapshot = await _clientesCollection.get();
    return querySnapshot.docs
        .map((doc) => Cliente.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Cliente?> findByDni(String dni) async {
    QuerySnapshot querySnapshot =
        await _clientesCollection.where("dni", isEqualTo: dni).get();

    return querySnapshot.docs
        .map((doc) => Cliente.fromMap(doc.data() as Map<String, dynamic>))
        .toList()
        .first;
  }

  Future<void> addCliente(Cliente cliente) async {
    await _clientesCollection.doc(cliente.dni).set(cliente.toMap());
  }

  // Actualizar un cliente existente
  Future<void> updateCliente(Cliente cliente) async {
    await _clientesCollection.doc(cliente.dni).update(cliente.toMap());
  }

  // Eliminar un cliente
  Future<void> deleteCliente(String dni) async {
    await _clientesCollection.doc(dni).delete();
  }

  Future<Map<String, dynamic>> getClienteInfo(String dni) async {
    try {
      Cliente? cliente = await findByDni(dni);
      if (cliente != null) {
        return {
          'nombre': cliente.nombre,
          'telefono': cliente.telefono,
        };
      } else {
        throw 'Cliente no encontrado';
      }
    } catch (error) {
      print('Error al obtener información del cliente: $error');
      rethrow;
    }
  }

  void getCliente(dni) async {
    Cliente? cliente = await findByDni(dni);
    print(cliente.toString());
  }
}

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
          title: const Text('Registrar Cliente',
              style: TextStyle(
                  color: Color.fromRGBO(126, 217, 87, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
        ),
        body: const RegisterClientForm());
  }
}

class LoadClientScreen extends StatefulWidget {
  const LoadClientScreen({super.key});

  @override
  State<LoadClientScreen> createState() => _LoadClientScreenState();
}

class _LoadClientScreenState extends State<LoadClientScreen> {
  ClienteService client = ClienteService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: client.getClientList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: ((context, index) {
                return Text(snapshot.data![index].nombre);
              }));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RegisterClientScreen extends StatelessWidget {
  const RegisterClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Clientes'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterClientForm(),
      ),
    );
  }
}

class RegisterClientForm extends StatefulWidget {
  const RegisterClientForm({super.key});

  @override
  State createState() => _RegisterClientFormState();
}

class _RegisterClientFormState extends State<RegisterClientForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  void dispose() {
    _dniController.dispose();
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  String _dni = '';
  String _nombre = '';
  String _telefono = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30,),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _dniController,
                decoration: const InputDecoration(
                    labelText: 'DNI',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el DNI';
                  }
                  if (!_isNumeric(value)) {
                    return 'El DNI debe contener solo números';
                  }
                  if (value.length != 8) {
                    return 'El DNI debe tener exactamente 8 dígitos';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dni = value!;
                },
                maxLength: 8,
                buildCounter: (BuildContext context,
                        {int? currentLength, int? maxLength, bool? isFocused}) =>
                    Text('$currentLength/$maxLength'),
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _nombreController,
                decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  if (!_isValidName(value)) {
                    return 'El nombre solo debe contener letras y espacios';
                  }
                  if (value.length > 50) {
                    return 'El nombre debe tener máximo 50 caracteres';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombre = value!;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                maxLength: 50,
                buildCounter: (BuildContext context,
                        {int? currentLength, int? maxLength, bool? isFocused}) =>
                    Text('$currentLength/$maxLength'),
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _telefonoController,
                decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el teléfono';
                  }
                  if (!_isNumeric(value)) {
                    return 'El teléfono debe contener solo números';
                  }
                  if (value.length != 9) {
                    return 'El teléfono debe tener exactamente 9 dígitos';
                  }
                  return null;
                },
                onSaved: (value) {
                  _telefono = value!;
                },
                maxLength: 9,
                buildCounter: (BuildContext context,
                        {int? currentLength, int? maxLength, bool? isFocused}) =>
                    Text('$currentLength/$maxLength'),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80,
                  child: ElevatedButton(

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ClienteService().addCliente(Cliente(_nombre, _dni, _telefono));
                        _mostrarDialogoRegistroExitoso();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
                    ),
                    child: const Text('Registrar',
                        style: TextStyle(
                            color: Color.fromRGBO(31, 31, 31, 1),
                            fontWeight: FontWeight.bold,
                            height: 2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return int.tryParse(value) != null;
  }

  bool _isValidName(String value) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
  }

  void _mostrarDialogoRegistroExitoso() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cliente registrado'),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('El cliente ha sido registrado correctamente.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _limpiarCampos();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _limpiarCampos() {
    _dniController.clear();
    _nombreController.clear();
    _telefonoController.clear();
  }
}
