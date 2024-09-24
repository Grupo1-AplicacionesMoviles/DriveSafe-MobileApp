class VehicleModel {
  final String brand;
  final String model;
  final int maximumSpeed;
  final int consumption;
  final String dimensions;
  final int weight;
  final String carClass;
  final String transmission;
  final String timeType;
  final int rentalCost;
  final String pickUpPlace;
  final String urlImage;
  final String rentStatus;
  final int ownerId;

  VehicleModel({
    required this.brand,
    required this.model,
    required this.maximumSpeed,
    required this.consumption,
    required this.dimensions,
    required this.weight,
    required this.carClass,
    required this.transmission,
    required this.timeType,
    required this.rentalCost,
    required this.pickUpPlace,
    required this.urlImage,
    required this.rentStatus,
    required this.ownerId,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      brand: json['Brand'],
      model: json['Model'],
      maximumSpeed: json['MaximumSpeed'],
      consumption: json['Consumption'],
      dimensions: json['Dimensions'],
      weight: json['Weight'],
      carClass: json['CarClass'],
      transmission: json['Transmission'],
      timeType: json['TimeType'],
      rentalCost: json['RentalCost'],
      pickUpPlace: json['PickUpPlace'],
      urlImage: json['UrlImage'],
      rentStatus: json['RentStatus'],
      ownerId: json['OwnerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Brand': brand,
      'Model': model,
      'MaximumSpeed': maximumSpeed,
      'Consumption': consumption,
      'Dimensions': dimensions,
      'Weight': weight,
      'CarClass': carClass,
      'Transmission': transmission,
      'TimeType': timeType,
      'RentalCost': rentalCost,
      'PickUpPlace': pickUpPlace,
      'UrlImage': urlImage,
      'RentStatus': rentStatus,
      'OwnerId': ownerId,
    };
  }
}