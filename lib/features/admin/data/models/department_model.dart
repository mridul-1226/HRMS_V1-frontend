import 'package:hrms/features/admin/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  DepartmentModel({
    required super.name,
    required super.leaveAllotments,
    super.id,
    required super.companyId,
    super.description,
    super.headId,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      companyId: json['company'],
      name: json['name'],
      description: json['description'],
      headId: json['head'],
      leaveAllotments: json['leave_allotments'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': companyId,
      'name': name,
      'description': description,
      'head': headId,
      'leave_allotments': leaveAllotments,
    };
  }

  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      companyId: entity.companyId,
      name: entity.name,
      description: entity.description,
      headId: entity.headId,
      leaveAllotments: entity.leaveAllotments,
    );
  }
}
