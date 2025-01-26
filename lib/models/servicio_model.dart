import 'package:uuid/uuid.dart';

class Servicio {
  String codigo;
  String nombre;
  double precio;
  String image;

  Servicio(this.codigo,this.nombre,this.precio, this.image);

  // Constructor para convertir un mapa en un objeto Servicio
  Servicio.fromMap(Map<String, dynamic> map):
        codigo = map['codigo'],
        nombre = map['nombre'],
        precio = map['precio'].toDouble(),
        image = map['image'];

  // Método para convertir un objeto Servicio en un mapa
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
      'image': image,
    };
  }

  // Método estático para crear un nuevo Servicio con ID autogenerado
  static Servicio nuevoServicio({
    required String nombre,
    required double precio,
    required String image,
  }) {
    var uuid = const Uuid();
    String newId = uuid.v4(); // Genera un UUID v4 único
    return Servicio(newId, nombre, precio, image);
  }
}