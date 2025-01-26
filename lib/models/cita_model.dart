import 'package:uuid/uuid.dart';

class Cita {
  String codigo;
  String barbero;
  String cliente;
  DateTime fecha;
  String estado;
  List<String> servicios;

  Cita(
    this.codigo,
    this.barbero,
    this.cliente,
    this.fecha,
    this.estado,
    this.servicios,
  );

  // Constructor para convertir un mapa en un objeto Cita
  Cita.fromMap(Map<String, dynamic> map)
      : codigo = map['codigo'],
        barbero = map['barbero'],
        cliente = map['cliente'],
        fecha = DateTime.parse(map['fecha']),
        estado = map['estado'],
        servicios = List<String>.from(map['servicio'] ?? []);

  // Método para convertir un objeto Cita en un mapa
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'barbero': barbero,
      'cliente': cliente,
      'fecha': fecha.toIso8601String(), // Convertir DateTime a String ISO 8601
      'servicio': servicios,
      'estado': estado
    };
  }

  static Cita nuevaCita(String barbero,String cliente,DateTime fecha,List<String> servicios, String estado) {
    var uuid = const Uuid();
    String newId = uuid.v4(); // Genera un UUID v4 único
    return Cita(newId, barbero,cliente,fecha,'A',servicios);
  }
}