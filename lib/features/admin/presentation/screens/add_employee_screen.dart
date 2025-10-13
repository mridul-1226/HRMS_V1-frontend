import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/core/utils/toast.dart';
import 'package:hrms/features/admin/domain/entities/employee_entity.dart';
import 'package:hrms/features/admin/presentation/blocs/manage_employee_bloc/manage_employee_bloc.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final _workingStartController = TextEditingController();
  final _workingEndController = TextEditingController();
  final _companyController = TextEditingController();
  String? _selectedEmployeeType;
  DateTime? _dob;
  DateTime? _joiningDate;
  bool _overtimeEligible = false;
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bankAccountController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _salaryController.dispose();
    _workingStartController.dispose();
    _workingEndController.dispose();
    _companyController.dispose();
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

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _selectJoiningDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _joiningDate) {
      setState(() {
        _joiningDate = picked;
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
    return BlocConsumer<ManageEmployeeBloc, ManageEmployeeState>(
      listener: (context, state) {
        if (state is EmployeeAddedSuccess) {
          Toast.show(message: 'Employee added successfully');
          context.pop();
        } else if (state is ManageEmployeeError) {
          Toast.show(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state is ManageEmployeeLoading,
          child: Scaffold(
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
                          _buildTextField(
                            'First Name',
                            'Enter first name',
                            _firstNameController,
                          ),
                          _buildTextField(
                            'Last Name',
                            'Enter last name',
                            _lastNameController,
                          ),
                          _buildTextField(
                            'Email',
                            'Enter email address',
                            _emailController,
                            validator: _emailValidator,
                          ),
                          _buildTextField(
                            'Phone',
                            'Enter phone number',
                            _phoneController,
                            validator: _phoneValidator,
                          ),
                          _buildTextField(
                            'Address',
                            'Enter address',
                            _addressController,
                            maxLines: 3,
                          ),
                          _buildDateField(
                            'Date of Birth',
                            'Select DOB',
                            _dob,
                            () => _selectDob(context),
                          ),
                          _buildTextField(
                            'Bank Account',
                            'Enter bank account number',
                            _bankAccountController,
                          ),
                          _buildTextField(
                            'Emergency Contact Name',
                            'Enter emergency contact name',
                            _emergencyNameController,
                          ),
                          _buildTextField(
                            'Emergency Contact Phone',
                            'Enter emergency contact phone',
                            _emergencyPhoneController,
                            validator: _phoneValidator,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDepartmentSection(),
                      const SizedBox(height: 20),
                      _buildAnimatedFormSection(
                        'Employment Details',
                        Icons.work,
                        [
                          _buildDropdownField(
                            'Department',
                            _selectedDepartment,
                            _departments
                                .map((dept) => dept['name'] as String)
                                .toList(),
                            (value) =>
                                setState(() => _selectedDepartment = value),
                          ),
                          _buildDropdownField(
                            'Employee Type',
                            _selectedEmployeeType,
                            EmployeeType.values.map((e) => e.name).toList(),
                            (value) =>
                                setState(() => _selectedEmployeeType = value),
                          ),
                          _buildTextField(
                            'Salary',
                            'Enter salary',
                            _salaryController,
                            validator: _salaryValidator,
                          ),
                          _buildDateField(
                            'Joining Date',
                            'Select joining date',
                            _joiningDate,
                            () => _selectJoiningDate(context),
                          ),
                          _buildTextField(
                            'Working Start Time',
                            'e.g., 09:00',
                            _workingStartController,
                          ),
                          _buildTextField(
                            'Working End Time',
                            'e.g., 17:00',
                            _workingEndController,
                          ),
                          CheckboxListTile(
                            title: Text(
                              'Overtime Eligible',
                              style: AppTypography.body2(),
                            ),
                            value: _overtimeEligible,
                            onChanged:
                                (value) => setState(
                                  () => _overtimeEligible = value ?? false,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state is! ManageEmployeeLoading
                                        ? _submitForm
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                  shadowColor: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                child: Text(
                                  'Add Employee',
                                  style: AppTypography.button(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (state is ManageEmployeeLoading)
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: AppTypography.body2(),
      readOnly: readOnly,
      onTap: onTap,
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
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
    );
  }

  Widget _buildDateField(
    String label,
    String hint,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      style: AppTypography.body2(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: AppTypography.body2(),
        hintStyle: AppTypography.body2(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
      ),
      controller: TextEditingController(
        text: date != null ? '${date.day}/${date.month}/${date.year}' : '',
      ),
      validator: (value) {
        if (date == null) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _salaryValidator(String? value) {
    if (value == null || value.isEmpty) return 'Salary is required';
    if (double.tryParse(value) == null) return 'Salary must be numeric';
    return null;
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) {
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
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
    );
  }

  void _submitForm() {
    if (_dob != null && DateTime.now().difference(_dob!).inDays / 365 < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Date of birth must be at least 18 years ago',
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

    if (_joiningDate != null &&
        _dob != null &&
        _joiningDate!.difference(_dob!).inDays / 365 < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Joining date must be at least 18 years after date of birth',
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

      final SharedPrefService prefs = getIt<SharedPrefService>();
      final company = prefs.getString(LocalStorageKeys.companyId);

      context.read<ManageEmployeeBloc>().add(
        AddEmployeeEvent({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'name':
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'dob': _dob?.toString(),
          'bank_account': _bankAccountController.text.trim(),
          'emergency_contact': {
            _emergencyNameController.text.trim():
                _emergencyPhoneController.text.trim(),
          },
          'company': company,
          'department_name': _selectedDepartment,
          'employee_type': _selectedEmployeeType,
          'salary': _salaryController.text.trim(),
          'joining_date': _joiningDate?.toString(),
          'working_hours': {
            'start': _workingStartController.text.trim(),
            'end': _workingEndController.text.trim(),
          },
          'overtime_eligible': _overtimeEligible,
        }),
      );
    }
  }
}
