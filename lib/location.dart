class Location {
  double? latitude;
  double? longitude;
  double? altitude;
  double? bearing;
  double? accuracy;
  double? speed;
  double? time;
  bool? isMock;
  double? ellipsoidalAltitude;
  double? horizontalAccuracy;
  double? verticalAccuracy;
  double? courseAccuracy;
  bool? isProducedByAccessory;
  bool? isSimulatedBySoftware;
  // sourceInformation;

  Location(
      {this.longitude,
      this.latitude,
      this.altitude,
      this.accuracy,
      this.bearing,
      this.speed,
      this.time,
      this.isMock,
      this.ellipsoidalAltitude,
      this.horizontalAccuracy,
      this.verticalAccuracy,
      this.courseAccuracy,
      this.isProducedByAccessory,
      this.isSimulatedBySoftware,});

  toMap() {
    var obj = {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'bearing': bearing,
      'accuracy': accuracy,
      'speed': speed,
      'time': time,
      'is_mock': isMock,
      'ellipsoidalAltitude': ellipsoidalAltitude,
      'horizontalAccuracy': horizontalAccuracy,
      'verticalAccruracy': verticalAccuracy,
      'courseAccuracy': courseAccuracy,
      'isProducedByAccessory': isProducedByAccessory,
      'isSimulatedBySoftware': isSimulatedBySoftware,
    };
    return obj;
  }
}
