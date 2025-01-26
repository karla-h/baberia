class Cliente {

  String nombre;
  String dni;
  String telefono;

  Cliente(this.nombre, this.dni, this.telefono);

  // Método para convertir un mapa en un objeto Cliente
  Cliente.fromMap(Map<String, dynamic> map)
      : nombre = map['nombre'],
        dni = map['dni'],
        telefono = map['telefono'];

  // Método para convertir un objeto Cliente en un mapa
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'dni': dni,
      'telefono': telefono,
    };
  }

  @override
  String toString() {
    return 'Cliente{nombre: $nombre, dni: $dni, telefono: $telefono}';
  }
}