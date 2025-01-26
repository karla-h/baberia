import 'package:flutter/material.dart';

import '../../models/cita_model.dart';
import '../../services/cita_service.dart';

class MostrarCitasScreen extends StatefulWidget {
  const MostrarCitasScreen({super.key});

  @override
  State<MostrarCitasScreen> createState() => _MostrarCitasScreenState();
}

class _MostrarCitasScreenState extends State<MostrarCitasScreen> {
  List<Cita> citas = []; // Lista de todas las citas
  final CitaService _citaService =
      CitaService(); // Instancia del servicio CitaService

  @override
  void initState() {
    super.initState();
    _getAllCitas(); // Cargar todas las citas al iniciar la pantalla
  }

  Future<void> _getAllCitas() async {
    try {
      List<Cita> allCitas = await _citaService.getAllCitas();
      setState(() {
        citas = allCitas;
      });
    } catch (error) {
      print('Error al obtener todas las citas: $error');
      // Manejo de errores, si es necesario
    }
  }

  Future<void> _confirmarCitaRealizada(Cita cita) async {
    try {
      await _citaService.actualizarEstadoCita(cita.codigo, 'E');
      await _getAllCitas();
    } catch (error) {
      print('Error al confirmar cita realizada: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        title: const Text('Citas Pendientes',
            style: TextStyle(
                color: Color.fromRGBO(126, 217, 87, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
      ),
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      body: citas.isEmpty
          ? const Center(child: Text('No hay citas registradas.'))
          : SafeArea(
              child: ListView.builder(
                itemCount: citas.length,
                itemBuilder: (context, index) {
                  final cita = citas[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.black45,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      title: Text(
                        'Cliente: ${cita.cliente}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Barbero: ${cita.barbero}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Servicios:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cita.servicios
                                .map(
                                  (servicio) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_right,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            servicio,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _confirmarCitaRealizada(cita);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(126, 217, 87, 1),
                        ),
                        child: const Text(
                          'Confirmar realizada',
                          style: TextStyle(color: Colors.white),
                        ),                        
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

void _mostrarDialogoRegistroExitoso(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cita Atendida'),
      content: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text('La cita se ha sido atendida.'),
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
