import 'dart:async';
import 'dart:math';
import 'package:flutter_proje/widgets/Coordinates/Charts.dart';
import 'package:flutter_proje/widgets/Coordinates/Coordinates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'CoordinateService.dart';

class MapSample extends StatefulWidget {
  final String title = "Charts";
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static List<Coordinates> coordinateList;
  CameraPosition myLati;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.93567, 29.15507),
    zoom: 14.4746,
  );

  setLatLng() async {
    double lati;
    double longi;
    await getCoordinates();
    int counter = 0;
    coordinateList.forEach((element) {
      if (counter == 0) {
        lati = double.parse(element.latitude);
        longi = double.parse(element.longitude);
        myLati = CameraPosition(target: LatLng(lati, longi), zoom: 14.4746);
      }
      counter++;
    });
  }

  final List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) async {
    await getCoordinates();
    setState(() {
      coordinateList.length;
    });

    coordinateList.forEach((element) {
      _markers.add(
        Marker(
          markerId: MarkerId(element.id.toString()),
          position: LatLng(
              double.parse(element.latitude), double.parse(element.longitude)),
          infoWindow: InfoWindow(
              title: "Cihaz Adı: " + element.deviceName,
              snippet: "Paylaşılan Dosya Sayısı:" + element.sharedFilesCount),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      _markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  void initState() {
    setLatLng();
    super.initState();
  }

  _onGraphicButtonPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Charts()));
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            //onMapCreated: (GoogleMapController controller) {
            // _controller.complete(controller);
            //},
            onMapCreated: _onMapCreated,
            markers: _markers.toSet(),
            onTap: (cordinate) {
              addMarker(cordinate);

              //Burada haaa tmm charts ı mı çağıracam
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  button(_onGraphicButtonPressed, Icons.bar_chart),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<List<Coordinates>> getCoordinates() {
    CoordinateService.getCoordinates().then((element) {
      coordinateList = element;
    });
    return CoordinateService.getCoordinates();
  }
} //Sonuncu
