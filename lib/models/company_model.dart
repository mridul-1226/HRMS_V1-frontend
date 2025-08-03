class CompanyModel {
  final String id;
  final String name;
  final String address;
  final String industry;

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.industry,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      industry: json['industry'],
    );
  }
}