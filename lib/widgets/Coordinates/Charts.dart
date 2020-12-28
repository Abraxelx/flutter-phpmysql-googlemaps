import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'map.dart';

class Charts extends StatefulWidget {
  final Widget child;

  Charts({Key key, this.child}) : super(key: key);

  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<charts.Series<Devices, String>> devicesData;
  List<Devices> locaData = List<Devices>();

  generateFromDB() {
    MapSampleState.coordinateList.forEach((element) {
      var id = element.id;
      var name = element.deviceName;
      var shareCount = element.sharedFilesCount;

      var dev = new Devices(int.parse(id), name, int.parse(shareCount));

      locaData.add(new Devices(int.parse(id), name, int.parse(shareCount)));
    });
  }

  finalResult() {
    generateFromDB();
    devicesData.add(
      charts.Series(
        domainFn: (Devices device, _) => device.name,
        measureFn: (Devices device, _) => device.count,
        id: "Coordinate",
        data: locaData,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Devices device, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    devicesData = List<charts.Series<Devices, String>>();
    finalResult();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
              ],
            ),
            title: Text('Grafiksel Dağılım'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Cihazlar Arasında Paylaşılan Dosya Grafiği',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.BarChart(
                            devicesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Devices {
  int id;
  int count;
  String name;

  Devices(this.id, this.name, this.count); //
}
