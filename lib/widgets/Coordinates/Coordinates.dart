class Coordinates {
  String id;
  String deviceName;
  String latitude;
  String longitude;
  String sharedFilesCount;

  Coordinates(
      {this.id,
      this.deviceName,
      this.latitude,
      this.longitude,
      this.sharedFilesCount});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      id: json['ID'] as String, // diğer serviste id var mıydı? evet
      deviceName: json['deviceName'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      sharedFilesCount: json['sharedFilesCount'] as String,
    );
  }
}
