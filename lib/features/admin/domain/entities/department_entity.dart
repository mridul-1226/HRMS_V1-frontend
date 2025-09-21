class DepartmentEntity {
  final int? id;
  final int companyId;
  final String name;
  final String? description;
  final int? headId;
  final Map<String, dynamic> leaveAllotments;

  DepartmentEntity({
    this.id,
    required this.companyId,
    required this.name,
    this.description,
    this.headId,
    required this.leaveAllotments,
  });
}