import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/core/utils/toast.dart';
import 'package:hrms/features/admin/domain/entities/department_entity.dart';
import 'package:hrms/features/admin/presentation/blocs/department_bloc/department_bloc.dart';

class AddDepartmentScreen extends StatefulWidget {
  const AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _headController = TextEditingController();
  final _yearlyLeaveController = TextEditingController();

  final List<Map<String, String>> _leaveAllotments = [
    {'key': '', 'value': ''},
  ];
  final List<TextEditingController> _keyControllers = [TextEditingController()];
  final List<TextEditingController> _valueControllers = [
    TextEditingController(),
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    _nameController.dispose();
    _descriptionController.dispose();
    _headController.dispose();
    _yearlyLeaveController.dispose();
    for (var controller in _keyControllers) {
      controller.dispose();
    }
    for (var controller in _valueControllers) {
      controller.dispose();
    }
    _fadeController.dispose();
    super.dispose();
  }

  void _addLeaveField() {
    setState(() {
      _leaveAllotments.add({'key': '', 'value': ''});
      _keyControllers.add(TextEditingController());
      _valueControllers.add(TextEditingController());
    });
  }

  void _removeLeaveField(int index) {
    if (_leaveAllotments.length > 1) {
      setState(() {
        _leaveAllotments.removeAt(index);
        _keyControllers[index].dispose();
        _valueControllers[index].dispose();
        _keyControllers.removeAt(index);
        _valueControllers.removeAt(index);
      });
    }
  }

  bool _hasDuplicateKeys() {
    final keys = _leaveAllotments.map((item) => item['key']?.trim()).toList();
    final uniqueKeys = keys.toSet();
    return keys.length != uniqueKeys.length;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_hasDuplicateKeys()) {
        Toast.show(
          message: 'Please fix duplicate leave type names',
          isError: true,
        );
        return;
      }

      for (final allotment in _leaveAllotments) {
        if (allotment['key']?.trim().isEmpty == true ||
            allotment['value']?.trim().isEmpty == true) {
          Toast.show(
            message: 'Please fill all leave allotment fields',
            isError: true,
          );
          return;
        }
      }

      final leaveAllotmentJson = <String, dynamic>{};
      for (final allotment in _leaveAllotments) {
        final key = allotment['key']?.trim();
        final value = allotment['value']?.trim();
        if (key != null &&
            value != null &&
            key.isNotEmpty &&
            value.isNotEmpty) {
          final numValue = num.tryParse(value);
          leaveAllotmentJson[key] = numValue ?? value;
        }
      }

      leaveAllotmentJson['yearly_leave'] =
          int.tryParse(_yearlyLeaveController.text) ?? 0;
      final prefs = getIt<SharedPrefService>();
      final companyId = prefs.getString(LocalStorageKeys.companyId);

      final departmentEntity = DepartmentEntity(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        headId:
            _headController.text.trim().isEmpty
                ? null
                : int.tryParse(_headController.text.trim()),
        leaveAllotments: leaveAllotmentJson,
        companyId: int.tryParse(companyId ?? '0') ?? 0
      );

      context.read<DepartmentBloc>().add(AddDepartmentEvent(department: departmentEntity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentBloc, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentAdded) {
          Toast.show(message: state.message);
          context.pushReplacementNamed(
            'policy-list',
            queryParameters: {
              'scopeId': state.department.id.toString(),
              'scope': state.department.name,
            },
          );
        } else if (state is DepartmentError) {
          Toast.show(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is DepartmentLoading;

        return IgnorePointer(
          ignoring: isLoading,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.grey[50],
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  title: Text(
                    'Add Department',
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
                            'Department Information',
                            Icons.business,
                            [
                              _buildTextField(
                                'Department Name',
                                'Enter department name',
                                _nameController,
                              ),
                              _buildTextField(
                                'Description',
                                'Enter department description',
                                _descriptionController,
                                maxLines: 3,
                              ),
                              _buildTextField(
                                'Department Head',
                                'Enter head name (optional)',
                                _headController,
                                required: false,
                              ),
                              _buildTextField(
                                'Yearly Leave Allotment',
                                'Enter yearly leave days',
                                _yearlyLeaveController,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildLeaveAllotmentSection(),
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
                                  'Create Department',
                                  style: AppTypography.button(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: AppColors.white.withValues(alpha: 0.7),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
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

  Widget _buildLeaveAllotmentSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.green[50]!],
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
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Leave Allotment Details',
                    style: AppTypography.headline6(),
                  ),
                ],
              ),
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  onPressed: _addLeaveField,
                  icon: Icon(
                    Icons.add_circle,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._leaveAllotments.asMap().entries.map((entry) {
            final index = entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
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
                    child: TextFormField(
                      controller: _keyControllers[index],
                      onChanged: (value) {
                        _leaveAllotments[index]['key'] = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Leave Type',
                        hintText: 'e.g., sick_leave, casual_leave',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty == true) return 'Required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _valueControllers[index],
                      onChanged: (value) {
                        _leaveAllotments[index]['value'] = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Days',
                        hintText: 'e.g., 10',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty == true) return 'Required';
                        return null;
                      },
                    ),
                  ),
                  if (_leaveAllotments.length > 1)
                    IconButton(
                      onPressed: () => _removeLeaveField(index),
                      icon: Icon(Icons.remove_circle, color: AppColors.error),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool required = true,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
      validator:
          required
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
              : null,
    );
  }
}
