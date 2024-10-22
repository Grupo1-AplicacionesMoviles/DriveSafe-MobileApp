class UserModel {
  final String name;
  final String lastName;
  final String birthDate;
  final int cellphone;
  final String gmail;
  final String password;
  final String type;

  UserModel({required this.name,
    required this.lastName,
    required this.birthDate,
    required this.cellphone,
    required this.gmail,
    required this.password,
    required this.type
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['Name'],
      lastName: json['LastName'],
      birthDate: json['Birthdate'],
      cellphone: json['Cellphone'],
      gmail: json['Gmail'],
      password: json['Password'],
      type: json['Type']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'LastName': lastName,
      'BirthDate': birthDate,
      'Cellphone': cellphone,
      'Gmail': gmail,
      'Password': password,
      'Type': type
    };
  }
}