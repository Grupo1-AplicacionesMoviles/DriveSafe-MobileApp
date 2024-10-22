class MaintenanceModel {
  final String typeProblem;
  final String title;
  final String description;
  final int tenantId;
  final int ownerId;

  MaintenanceModel({required this.typeProblem,
  required this.title,
    required this.description,
    required this.tenantId,
    required this.ownerId
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      typeProblem: json['TypeProblem'],
      title: json['Title'],
      description: json['Description'],
      tenantId: json['TenantId'],
      ownerId: json['OwnerId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TypeProblem': typeProblem,
      'Title': title,
      'Description': description,
      'TenantId': tenantId,
      'OwnerId': ownerId
    };
  }
}