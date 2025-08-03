class UserModel {
  final String id;
  final String email;
  final String role; // 'admin' or 'employee'
  final String companyId;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.companyId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      companyId: json['company_id'],
    );
  }
}