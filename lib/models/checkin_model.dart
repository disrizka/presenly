class CheckinModel {
  final int? id;
  final String address;
  final double latitude;
  final double longitude;
  final String dateTime;

  CheckinModel({
    this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime': dateTime,
    };
  }

  factory CheckinModel.fromMap(Map<String, dynamic> map) {
    return CheckinModel(
      id: map['id'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dateTime: map['dateTime'],
    );
  }
}
