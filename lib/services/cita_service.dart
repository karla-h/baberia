import 'package:barberapp/models/cliente_model.dart';
import 'package:barberapp/services/message.dart';
import 'package:barberapp/services/servicio_service.dart';
import 'package:flutter/material.dart';
import 'package:barberapp/models/servicio_model.dart';
import 'package:barberapp/models/cita_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barberapp/services/cliente_service.dart';

class CitaService {
  final CollectionReference _citaCollection =
      FirebaseFirestore.instance.collection('citas');

  Future<List> getClientList() async {
    QuerySnapshot querySnapshot = await _citaCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Cita>> getCitasbyCliente(String cliente) async {
    QuerySnapshot querySnapshot =
        await _citaCollection.where("cliente", isEqualTo: cliente).get();
    return querySnapshot.docs
        .map((doc) => Cita.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCita(Cita cita) async {
    await _citaCollection.doc(cita.codigo).set(cita.toMap());
  }

  Future<List<Cita>> getCitasPendientesHoy() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    Timestamp startTimestamp = Timestamp.fromDate(today);
    Timestamp endTimestamp =
        Timestamp.fromDate(today.add(const Duration(days: 1)));

    QuerySnapshot querySnapshot = await _citaCollection
        .where("fecha", isGreaterThanOrEqualTo: startTimestamp)
        .where("fecha", isLessThan: endTimestamp)
        .get();

    return querySnapshot.docs
        .map((doc) => Cita.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Cita>> getAllCitas() async {
    try {
      QuerySnapshot querySnapshot =
          await _citaCollection.where('estado', isEqualTo: 'A').get();
      return querySnapshot.docs
          .map((doc) => Cita.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error al obtener todas las citas activas: $error');
      rethrow;
    }
  }

  Future<void> actualizarEstadoCita(String citaId, String nuevoEstado) async {
    try {
      await _citaCollection.doc(citaId).update({'estado': nuevoEstado});
    } catch (error) {
      print('Error al actualizar estado de la cita: $error');
      rethrow;
    }
  }
}

class GuardarCitaScreen extends StatefulWidget {
  const GuardarCitaScreen({super.key});

  @override
  State createState() => _GuardarCitaScreenState();
}

class _GuardarCitaScreenState extends State<GuardarCitaScreen> {
  late TextEditingController _clienteController;
  late DateTime _fechaSeleccionada;
  List<Servicio> serviciosList = [];
  List<Servicio> serviciosSeleccionados = [];
  List<String> clientesList = [];
  bool clienteRegistrado = false;

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController();
    _fechaSeleccionada = DateTime.now();
    _cargarServicios();
    _cargarClientes();
  }

  Future<void> _cargarServicios() async {
    try {
      List<Servicio> servicios = await ServicioService().getServicioList();
      setState(() {
        serviciosList = servicios;
      });
    } catch (error) {
      print('Error al cargar servicios: $error');
    }
  }

  Future<void> _cargarClientes() async {
    try {
      List<Cliente> clientes = await ClienteService().getClientList();
      setState(() {
        clientesList = clientes.map((cliente) => cliente.dni).toList();
      });
    } catch (error) {
      print('Error al cargar clientes: $error');
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        title: const Text('Guardar Cita',
            style: TextStyle(
                color: Color.fromRGBO(126, 217, 87, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _clienteController,
                    decoration: InputDecoration(
                      labelText: 'Cliente',
                      border: const OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          clienteRegistrado ? Icons.check_circle : Icons.error,
                          color: clienteRegistrado ? Colors.green : Colors.red,
                        ),
                        onPressed: () {
                          _buscarCliente();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: () async {
                DateTime? fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: _fechaSeleccionada,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (fechaSeleccionada != null) {
                  setState(() {
                    _fechaSeleccionada = fechaSeleccionada;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.grey),
              ),
              controller:
                  TextEditingController(text: _fechaSeleccionada.toString()),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _mostrarSeleccionServicios();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsetsDirectional.only(
                        top: 15, bottom: 15, end: 50, start: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
                  ),
                  child: const Text('Agregar Servicio',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: serviciosSeleccionados.length,
                itemBuilder: (context, index) {
                  final servicio = serviciosSeleccionados[index];
                  return ListTile(
                    textColor: Colors.white,
                    leading: Image.network(
                      servicio.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(servicio.nombre),
                    subtitle: Text('S/. ${servicio.precio.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          serviciosSeleccionados.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
        onPressed: () {
          _guardarCita();
          _mostrarDialogoRegistroExitoso(context);
        },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  void _buscarCliente() {
    // Lógica para buscar cliente
    String dniCliente = _clienteController.text.trim();
    if (clientesList.contains(dniCliente)) {
      setState(() {
        clienteRegistrado = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente encontrado: $dniCliente')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cliente no encontrado'),
          content: const Text('¿Desea registrar a este cliente?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _registrarNuevoCliente(dniCliente);
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      );
    }
  }

  void _registrarNuevoCliente(String dniCliente) async {
    showDialog(
      context: context,
      builder: (context) => const ClientsScreen(),
    );
  }

  void _mostrarSeleccionServicios() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          'Seleccionar Servicios',
          style: TextStyle(color: Colors.white, fontFamily: 'Consolas'),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: serviciosList.length,
            itemBuilder: (context, index) {
              final servicio = serviciosList[index];
              return ListTile(
                textColor: Colors.white,
                title: Text(servicio.nombre),
                subtitle: Text('S/. ${servicio.precio.toStringAsFixed(2)}'),
                leading: Image.network(
                  servicio.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  if (!serviciosSeleccionados.contains(servicio)) {
                    setState(() {
                      serviciosSeleccionados.add(servicio);
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'El servicio ${servicio.nombre} ya ha sido seleccionado'),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
              minimumSize: const Size(100, 50),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _guardarCita() async {
    try {
      String cliente = _clienteController.text.trim();
      List<String> servicios =
          serviciosSeleccionados.map((s) => s.nombre).toList();
      String estado = 'A';
      Cita nuevaCita = Cita.nuevaCita(
          "Julio Goicochea", cliente, _fechaSeleccionada, servicios, estado);

      await CitaService().addCita(nuevaCita);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cita guardada correctamente')),
      );

      var clienteInfo = await ClienteService().getClienteInfo(cliente);
      String telefonoCliente = clienteInfo['telefono'] ?? '';

      if (telefonoCliente.isNotEmpty) {
        WhatsAppService().sendWhatsAppMessage(
          telefonoCliente,
          'Hola ${clienteInfo['nombre']}, te hemos agendado una cita para el ${_fechaSeleccionada.toString()}',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mensaje enviado por WhatsApp')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontró número de teléfono del cliente')),
        );
      }

      _clienteController.clear();
      setState(() {
        clienteRegistrado = false;
        serviciosSeleccionados.clear();
      });
    } catch (error) {
      print('Error al guardar la cita: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la cita')),
      );
    }
  }
}

void _mostrarDialogoRegistroExitoso(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cita registrada'),
      content: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text('La cita se ha sido registrado correctamente.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}
