import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

import '../../services/report_service.dart';


class TimeSeriesSales {
  final DateTime fecha;
  final int cantidad;

  TimeSeriesSales(this.fecha, this.cantidad);
}

final _monthDayFormat = DateFormat('MM-dd');

//List<TimeSeriesSales> timeSeriesSales = [
final timeSeriesSales = [
  TimeSeriesSales(DateTime(2017, 9, 19), 5),
  TimeSeriesSales(DateTime(2017, 9, 26), 25),
  TimeSeriesSales(DateTime(2017, 10, 3), 100),
  TimeSeriesSales(DateTime(2017, 10, 10), 75),
];

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  List<Map<String, dynamic>> mapaServicios = [];

  List<dynamic> cantidadCitas = [];

  @override
  void initState(){
    super.initState();
    getCountServices();
    getCountCitas();
  }

  Future<void> getCountServices() async{
    List<Map<String, dynamic>> count = await report_service().getServiciosSolicitadosMensuales();
    setState(() {
      try{
        mapaServicios = count;
        print('LONGITUDD ARRAY CITAS ATENDIDAS: ${mapaServicios.length}');
      }catch(e){
        print('asdasd');
      }
    });
  }

  Future<void> getCountCitas() async{
    List<TimeSeriesSales> count = await report_service().getCitasAtendidas();
    setState(() {
      try{
        cantidadCitas = count;
        print('LONGITUDD ARRAY CITAS ATENDIDAS: ${cantidadCitas.length}');
      }catch(e){
        print('asdasd');
      }
    });
  }

  List<String> meses = [
    'Diciembre','Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
        title: const Text('Reportes',
            style: TextStyle(
                color: Color.fromRGBO(126, 217, 87, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        foregroundColor: const Color.fromRGBO(126, 217, 87, 1),
      ),
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              //Container(
              //  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              //  alignment: Alignment.centerLeft,
              //  child: const Text(
              //    '- Bar colors and shadow elevations change with selection state.',
              //  ),
              //),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(126, 217, 87, 1), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(30))
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        //margin: const EdgeInsets.only(top: 10),
                        width: 350,
                        height: 300,
                        child: Chart(
                          data: mapaServicios,
                          variables: {
                            'servicio': Variable(
                              accessor: (Map map) => map['servicio'] as String,
                            ),
                            'cantidad': Variable(
                              accessor: (Map map) => map['cantidad'] as num,
                            ),
                          },
                          marks: [
                            //IntervalMark(
                            //  label: LabelEncode(
                            //      encoder: (tuple) => Label(tuple['cantidad'].toString())),
                            //  elevation: ElevationEncode(value: 0, updaters: {
                            //    'tap': {true: (_) => 5}
                            //  }),
                            //  color:
                            //  ColorEncode(value: Defaults.primaryColor, updaters: {
                            //    'tap': {false: (color) => color.withAlpha(100)}
                            //  }),
                            //)
                            IntervalMark(
                              label: LabelEncode(
                                  encoder: (tuple) => Label(tuple['cantidad'].toString())),
                              gradient: GradientEncode(
                                  value: const LinearGradient(colors: [
                                    Color(0x8883bff6),
                                    Color(0x88188df0),
                                    Color(0xcc188df0),
                                  ], stops: [
                                    0,
                                    0.5,
                                    1
                                  ]),
                                  updaters: {
                                    'tap': {
                                      true: (_) => const LinearGradient(colors: [
                                        Color(0xee83bff6),
                                        Color(0xee3f78f7),
                                        Color(0xff3f78f7),
                                      ], stops: [
                                        0,
                                        0.7,
                                        1
                                      ])
                                    }
                                  }),
                            )
                          ],
                          //axes: [
                          //  Defaults.horizontalAxis,
                          //  Defaults.verticalAxis,
                          //],
                          //selections: {'tap': PointSelection(dim: Dim.x)},
                          //tooltip: TooltipGuide(),
                          //crosshair: CrosshairGuide(),
                          coord: RectCoord(transposed: true),
                          axes: [
                            Defaults.verticalAxis
                              ..line = Defaults.strokeStyle
                              ..grid = null,
                            Defaults.horizontalAxis
                              ..line = null
                              ..grid = Defaults.strokeStyle,
                          ],
                          selections: {'tap': PointSelection(dim: Dim.x)},
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                        child: Text(
                          'Servicios mas solicitados en el mes de ${meses[DateTime.now().month-1]}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(126, 217, 87, 1), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(30))
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 350,
                        height: 300,
                        child: Chart(
                          data: timeSeriesSales,
                          variables: {
                            'fecha': Variable(
                              accessor: (TimeSeriesSales datum) => datum.fecha,
                              scale: TimeScale(
                                formatter: (time) => _monthDayFormat.format(time),
                              ),
                            ),
                            'cantidad': Variable(
                              accessor: (TimeSeriesSales datum) => datum.cantidad,
                            ),
                          },
                          marks: [
                            LineMark(
                              shape: ShapeEncode(value: BasicLineShape(dash: [5, 2])),
                              selected: {
                                'touchMove': {1}
                              },
                            )
                          ],
                          coord: RectCoord(color: Colors.white),
                          axes: [
                            Defaults.horizontalAxis,
                            Defaults.verticalAxis,
                          ],
                          selections: {
                            'touchMove': PointSelection(
                              on: {
                                GestureType.scaleUpdate,
                                GestureType.tapDown,
                                GestureType.longPressMoveUpdate
                              },
                              dim: Dim.x,
                            )
                          },
                          tooltip: TooltipGuide(
                            followPointer: [false, true],
                            align: Alignment.topLeft,
                            offset: const Offset(-20, -20),
                          ),
                          crosshair: CrosshairGuide(followPointer: [false, true]),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                        child: const Text(
                          'Registro de citas atendidas ultimanente',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
