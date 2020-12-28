import 'dart:convert';
import 'package:http/http.dart'
    as http; //http eklentisini pubspec.yam dosyasına ekledim
import 'Coordinates.dart';

class CoordinateService {
  static const ROOT = 'http://10.0.2.2/coordinatesDB/coordinates_actions.php';
  static const GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';

  static Future<List<Coordinates>> getCoordinates() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Coordinates> list = parseResponse(response.body);
        return list;
      } else {
        return List<Coordinates>();
      }
    } catch (e) {
      return List<
          Coordinates>(); //istisna / hata durumunda boş bir liste döndür.
    }
  }

  static List<Coordinates> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<Coordinates>((json) => Coordinates.fromJson(json))
        .toList();
  }

  //koordinatı veritabanına ekleme fonksiyonu
  static Future<String> addCoordinates(
    String deviceName,
    String latitude,
    String longitude,
    String sharedFilesCount,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['DeviceName'] = deviceName;
      map['Latitude'] = latitude;
      map['Longitude'] = longitude;
      map['Sharedfilescount'] = sharedFilesCount;

      final response = await http.post(ROOT, body: map);
      print('addCoordinates Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
