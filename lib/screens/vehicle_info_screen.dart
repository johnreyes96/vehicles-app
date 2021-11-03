import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/models/history.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vehicle.brand.description} ${widget.vehicle.line} ${widget.vehicle.plaque}'),
      ),
      body: Center(
        child: _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goAddHistory(History(
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

  void _goAddHistory(History history) async {
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
    return Container();
  }

  Widget _getListView() {
    return Container();
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
}