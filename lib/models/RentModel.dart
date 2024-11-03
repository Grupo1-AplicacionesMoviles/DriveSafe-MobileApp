class RentModel {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final int vehicleId;
  final int ownerId;
  final int tenantId;
  final String pickUpPlace;

  RentModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.vehicleId,
    required this.ownerId,
    required this.tenantId,
    required this.pickUpPlace
  });

  factory RentModel.fromJson(Map<String, dynamic> json) {
    return RentModel(
        id: json['Id'],
        status: json['Status'],
        startDate: json['StartDate'],
        endDate: json['EndDate'],
        vehicleId: json['VehicleId'],
        ownerId: json['OwnerId'],
        tenantId: json['TenantId'],
        pickUpPlace: json['PickUpPlace']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Status': status,
      'StartDate': startDate,
      'EndDate': endDate,
      'VehicleId': vehicleId,
      'OwnerId': ownerId,
      'TenantId': tenantId,
      'PickUpPlace': pickUpPlace
    };
  }

  RentModel copyWith({
    int? id,
    String? status,
    String? startDate,
    String? endDate,
    int? vehicleId,
    int? ownerId,
    int? tenantId,
    String? pickUpPlace,
  }) {
    return RentModel(
      id: id ?? this.id,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      vehicleId: vehicleId ?? this.vehicleId,
      ownerId: ownerId ?? this.ownerId,
      tenantId: tenantId ?? this.tenantId,
      pickUpPlace: pickUpPlace ?? this.pickUpPlace,
    );
  }
}