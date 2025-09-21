import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartment;
  List<Map<String, dynamic>> _departments = [];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadDepartments() {
    final prefs = getIt<SharedPrefService>();
    final departmentsCsv = prefs.getString(LocalStorageKeys.departments) ?? '';

    if (departmentsCsv.isNotEmpty) {
      final departmentsList = departmentsCsv.split(',');
      setState(() {
        _departments =
            departmentsList.map((dept) {
              final parts = dept.split(':');
              if (parts.length == 2) {
                return {'name': parts[0], 'id': parts[1]};
              }
              return {'name': '', 'id': ''};
            }).toList();
      });
    }
  }

  void _navigateToAddDepartment() async {
    final result = await context.pushNamed('add-department');
    if (result == true) {
      _loadDepartments();
    }
  }

  void _navigateToDepartmentPolicies(
    String departmentId,
    String departmentName,
  ) {
    context.pushNamed(
      'policy-list',
      queryParameters: {'scopeId': departmentId, 'scope': departmentName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Add Employee',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAnimatedFormSection(
                  'Personal Information',
                  Icons.person,
                  [
                    _buildTextField('Full Name', 'Enter full name'),
                    _buildTextField('Email', 'Enter email address'),
                    _buildTextField('Phone', 'Enter phone number'),
                    _buildTextField('Address', 'Enter address', maxLines: 3),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDepartmentSection(),
                const SizedBox(height: 20),
                _buildAnimatedFormSection('Employment Details', Icons.work, [
                  _buildDropdownField(
                    'Department',
                    _selectedDepartment,
                    _departments.map((dept) => dept['name'] as String).toList(),
                    (value) => setState(() => _selectedDepartment = value),
                  ),
                  _buildTextField('Position', 'Enter position/role'),
                  _buildTextField('Salary', 'Enter salary'),
                  _buildTextField('Start Date', 'Select start date'),
                ]),
                const SizedBox(height: 32),
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.primary.withValues(alpha: 0.3),
                      ),
                      child: Text(
                        'Add Employee',
                        style: AppTypography.button(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFormSection(
    String title,
    IconData icon,
    List<Widget> fields,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.headline6()),
            ],
          ),
          const SizedBox(height: 16),
          ...fields.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: field,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  Text('Departments', style: AppTypography.headline6()),
                ],
              ),
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: _navigateToAddDepartment,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Department'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_departments.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.business, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No departments created yet',
                    style: AppTypography.body1(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create departments before adding employees',
                    style: AppTypography.body2(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          else
            Column(
              children:
                  _departments.map((dept) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dept['name'],
                                  style: AppTypography.body2(),
                                ),
                                if (dept['description'] != null &&
                                    dept['description'].isNotEmpty)
                                  Text(
                                    dept['description'],
                                    style: AppTypography.body2(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                if (dept['head'] != null &&
                                    dept['head'].isNotEmpty)
                                  Text(
                                    'Head: ${dept['head']}',
                                    style: AppTypography.caption(
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed:
                                () => _navigateToDepartmentPolicies(
                                  dept['id'],
                                  dept['name'],
                                ),
                            child: Text(
                              'Policies',
                              style: AppTypography.button(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      style: AppTypography.body2(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: AppTypography.body2(),
        hintStyle: AppTypography.body2(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.edit, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      style: AppTypography.body2(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: AppTypography.body2(),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
      ),
      items:
          items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: AppTypography.body2()),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_departments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please create at least one department first',
              style: AppTypography.body2(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Employee added successfully!',
            style: AppTypography.body2(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}
