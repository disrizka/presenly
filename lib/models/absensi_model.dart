// ✅ Final AbsensiModel (untuk Check-in, Check-out, dan History)
class AbsensiModel {
  final int? id;
  final int userId;
  final String status; // checkin / checkout
  final String? checkIn;
  final String? checkOut;
  final String? checkInAddress;
  final String? checkOutAddress;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final String createdAt;
  final String? updatedAt;

  AbsensiModel({
    this.id,
    required this.userId,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.checkInAddress,
    this.checkOutAddress,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    required this.createdAt,
    this.updatedAt,
  });

  factory AbsensiModel.fromMap(Map<String, dynamic> map) {
    return AbsensiModel(
      id: map['id'],
      userId: map['user_id'],
      status: map['status'],
      checkIn: map['check_in'],
      checkOut: map['check_out'],
      checkInAddress: map['check_in_address'],
      checkOutAddress: map['check_out_address'],
      checkInLat: map['check_in_lat'],
      checkInLng: map['check_in_lng'],
      checkOutLat: map['check_out_lat'],
      checkOutLng: map['check_out_lng'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'check_in': checkIn,
      'check_out': checkOut,
      'check_in_address': checkInAddress,
      'check_out_address': checkOutAddress,
      'check_in_lat': checkInLat,
      'check_in_lng': checkInLng,
      'check_out_lat': checkOutLat,
      'check_out_lng': checkOutLng,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
