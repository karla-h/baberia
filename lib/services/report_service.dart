import 'package:barberapp/views/screens/report_screen.dart';
import 'package:barberapp/models/cita_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class report_service{
  final CollectionReference _citaCollection = FirebaseFirestore.instance.collection('citas');

  Future<List> getClientList() async {
    QuerySnapshot querySnapshot = await _citaCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Cita>> getCitasbyCliente(String cliente) async {
    QuerySnapshot querySnapshot = await _citaCollection.where("cliente", isEqualTo: cliente).get();
    return querySnapshot.docs.map((doc) => Cita.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addCita(Cita cita) async {
    await _citaCollection.doc(cita.codigo).set(cita.toMap());
  }

  Future<List<Map<String, dynamic>>> getServiciosSolicitadosMensuales() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month-1, now.day);

    Timestamp startTimestamp = Timestamp.fromDate(DateTime(now.year, 1, 1));
    Timestamp endTimestamp = Timestamp.fromDate(DateTime(now.year, 12, 1));

    QuerySnapshot querySnapshot = await _citaCollection
    //.where("fecha", isGreaterThanOrEqualTo: startTimestamp)
    //.where("fecha", isLessThan: endTimestamp)
        .get();

    Map<String, dynamic> serviciosMensuales = {};

    List<Map<String, dynamic>> listaServiciosMensuales = [];

    List<Cita> citas = querySnapshot.docs.map((doc) => Cita.fromMap(doc.data() as  Map<String, dynamic>)).toList();
    //print('LONGITUDD: ${citas.length}');
    for(var cita in citas){
      for(var s in cita.servicios){
        if(serviciosMensuales.containsKey(s)) {
          serviciosMensuales[s]++;
          //print('SERVICIO : ${s}');
        }else{
          serviciosMensuales[s.trim()]=1;
          //print('SERVICIO : ${s}');
        }
      }
    }
    //print('LONGITUDD: ${serviciosMensuales.length}');

    serviciosMensuales.forEach((servicio, cantidad) =>
        listaServiciosMensuales.add({
          'servicio': servicio,
          'cantidad': cantidad
        })
    );
    return listaServiciosMensuales;
  }


  /////////////////////////////////////////////////////////////////

  Future<List<TimeSeriesSales>> getCitasAtendidas() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month-1, now.day);

    Timestamp startTimestamp = Timestamp.fromDate(DateTime(now.year, 1, 1));
    Timestamp endTimestamp = Timestamp.fromDate(DateTime(now.year, 12, 1));

    QuerySnapshot querySnapshot = await _citaCollection
    //.where("fecha", isGreaterThanOrEqualTo: startTimestamp)
    //.where("fecha", isLessThan: endTimestamp)
        .get();

    Map<DateTime, dynamic> citasAtendidas = {};

    //List<Map<String, dynamic>> listaCitasAtendidas = [];

    List<TimeSeriesSales> timeSeriesSales = [];

    List<Cita> citas = querySnapshot.docs.map((doc) => Cita.fromMap(doc.data() as  Map<String, dynamic>)).toList();
    //print('LONGITUDD: ${citas.length}');
    for(var cita in citas){
      if(citasAtendidas.containsKey(cita.fecha)) {
        citasAtendidas[cita.fecha]++;
        //print('FECHA : ${cita.fecha}');
      }else{
        citasAtendidas[cita.fecha]=1;
        //print('FECHA : ${cita.fecha}');
      }
    }
    //print('LONGITUDD ARRAY CITAS ATENDIDAS: ${citasAtendidas.length}');

    citasAtendidas.forEach((fecha, cantidad) {
      timeSeriesSales.add(TimeSeriesSales(
          DateTime(fecha.year, fecha.month, fecha.day), cantidad+10));
      timeSeriesSales.add(TimeSeriesSales(
          DateTime(fecha.year, fecha.month, fecha.day+1), cantidad+23));
    });
    return timeSeriesSales;
  }
}

