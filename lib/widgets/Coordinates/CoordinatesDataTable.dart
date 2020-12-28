import 'package:flutter/material.dart';
import 'Coordinates.dart';
import 'CoordinateService.dart';

class CoordinatesDataTable extends StatefulWidget {
  CoordinatesDataTable() : super();
  final String title = 'Flutter Data Table';
  @override
  CoordinatesDataTableState createState() => CoordinatesDataTableState();
}

class CoordinatesDataTableState extends State<CoordinatesDataTable> {
  List<Coordinates> coordinatees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Coordinates> _coordinatees;

  @override
  void initState() {
    super.initState();
    _coordinatees = [];
    _scaffoldKey =
        GlobalKey(); //SnackBar göstermek için bağlamı elde etmenin anahtarı
    _getCoordinates();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _getCoordinates() {
    CoordinateService.getCoordinates().then((coordinatees) {
      setState(() {
        _coordinatees = coordinatees;
      });
      print("Lenght ${coordinatees.length}");
    });
  }

//Burası dursun şimdilik Atamayı burada yapacağıztmm
  setCoordinates() {
    _coordinatees.forEach((element) {
      var lat = element.deviceName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
