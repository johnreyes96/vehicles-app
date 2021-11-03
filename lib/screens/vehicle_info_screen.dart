import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/history.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/models/vehicle.dart';
import 'package:vehicles_app/screens/history_screen.dart';
import 'package:vehicles_app/screens/vehicle_screen.dart';

class VehicleInfoScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Vehicle vehicle;
  
  VehicleInfoScreen({ required this.token, required this.user, required this.vehicle });

  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vehicle.brand.description} ${widget.vehicle.line} ${widget.vehicle.plaque}'),
      ),
      body: Center(
        child: _showLoader
          ? LoaderComponent(text: 'Por favor espere...')
          : _getContent()
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goHistory(History(
          date: '',
          dateLocal: '',
          details: [],
          detailsCount: 0,
          id: 0,
          mileage: 0,
          remarks: '',
          total: 0,
          totalLabor: 0,
          totalSpareParts: 0
        ))
      ),
    );
  }

  void _goHistory(History history) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
        token: widget.token,
        user: widget.user,
        vehicle: widget.vehicle
      ))
    );
    if (result == 'yes') {
      //TODO: pending refresh the page
    }
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showVehicleInfo(),
        Expanded(
          child: widget.vehicle.histories.length == 0 ? _noContent() : _getListView()
        )
      ],
    );
  }

  Widget _showVehicleInfo() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: widget.vehicle.imageFullPath,
                  errorWidget: (context, url, err) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/vehicles_logo.png'),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  )
                )
              ),
              Positioned(
                bottom: 0,
                left: 60,
                child: InkWell(
                  onTap: () => _goEdit(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.blue
                      )
                    )
                  ),
                )
              )
            ]
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Tipo de vehículo: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.vehicleType.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Marca: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.brand.description,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Modelo: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.model.toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Placa: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.plaque,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Línea: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.line,
                              style: TextStyle(
                                fontSize: 14
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Color: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.color,
                              style: TextStyle(
                                fontSize: 14
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Comentarios: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.remarks == null ? 'N/A' : widget.vehicle.remarks!,
                              style: TextStyle(
                                fontSize: 14
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              '# Historias: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.vehicle.historiesCount.toString(),
                              style: TextStyle(
                                fontSize: 14
                              )
                            ),
                          ],
                        )
                      ]
                    ),
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'El vehículo no tiene historias registradas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getVehicle,
      child: ListView(
        children: widget.vehicle.histories.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goHistory(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.date,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      e.mileage.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      e.remarks == null ? 'N/A' : e.remarks!,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      e.totalLabor.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      e.totalSpareParts.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                    )
                                  ]
                                )
                              ]
                            )
                          ]
                        )
                      )
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 40
                    )
                  ]
                )
              )
            )
          );
        }).toList(),
      )
    );
  }

  void _goEdit() async {
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => VehicleScreen(
          token: widget.token, 
          user: widget.user,
          vehicle: widget.vehicle,
        )
      )
    );
    if (result == 'yes') {
      //TODO: Pending refresh vehicle  info
    }
  }

  Future<Null> _getVehicle() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet.',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

    //TODO: pending to get the vehicle
    Response response = await ApiHelper.getUser(widget.token, widget.user.id);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

    // setState(() {
    //   _user = response.result;
    // });
  }
}