import 'package:barberapp/models/servicio_model.dart';
import 'package:flutter/material.dart';
import 'package:barberapp/models/cita_model.dart';
import 'package:barberapp/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioService {
  final CollectionReference _serviciosCollection =
      DBFire.collection('servicios');

  Future<List<Servicio>> getServicioList() async {
    QuerySnapshot querySnapshot = await _serviciosCollection.get();
    return querySnapshot.docs
        .map((doc) => Servicio.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCliente(Cita cita) async {
    await _serviciosCollection.doc(cita.codigo).set(cita.toMap());
  }

  Future<List<Cita>> findByClient(String client) async {
    QuerySnapshot querySnapshot =
        await _serviciosCollection.where("cliente", isEqualTo: client).get();
    return querySnapshot.docs
        .map((doc) => Cita.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
          title: const Text('Servicios',
              style: TextStyle(
                  color: Color.fromRGBO(126, 217, 87, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
        ),
        body: _ServicioService());
  }
}

class _ServicioService extends StatefulWidget {
  @override
  EstadoServicios createState() => EstadoServicios();
}

class EstadoServicios extends State<_ServicioService> {
  late List<bool> _serviciosSeleccionados;
  ServicioService servicio = ServicioService();
  late List<Servicio> serviciosList = [];

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    try {
      List<Servicio> servicios = await servicio.getServicioList();

      setState(() {
        serviciosList = servicios;
        _serviciosSeleccionados = List.filled(servicios.length, false);
      });
    } catch (error) {
      print('Error al cargar servicios: $error');
    }
  }

  void _mostrarDetallesServicio(Servicio servicio, int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del servicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              servicio.image,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10),
            Text('Nombre: ${servicio.nombre}'),
            const SizedBox(height: 5),
            Text('Precio: S/.${servicio.precio.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
    setState(() {
      _serviciosSeleccionados[index] =
          false; // Deseleccionar el servicio al cerrar el diálogo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: serviciosList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!_serviciosSeleccionados[index]) {
                      setState(() {
                        _serviciosSeleccionados[index] = true;
                      });
                      _mostrarDetallesServicio(serviciosList[index], index);
                    }
                  },
                  child: Card(
                    elevation: _serviciosSeleccionados[index] ? 5 : 2,
                    color: _serviciosSeleccionados[index]
                        ? const Color.fromRGBO(126, 217, 87, 1)
                        : Colors.black45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          serviciosList[index].image,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          serviciosList[index].nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(126, 217, 87, 1),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'S/.${serviciosList[index].precio.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
