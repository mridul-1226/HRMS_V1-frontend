import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';

class CreateUpdatePolicyScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? existingPolicy;
  final String? scope;
  final int? scopeId;

  const CreateUpdatePolicyScreen({
    super.key,
    this.isEdit = false,
    this.existingPolicy,
    this.scope,
    this.scopeId,
  });

  @override
  State<CreateUpdatePolicyScreen> createState() =>
      _CreateUpdatePolicyScreenState();
}

class _CreateUpdatePolicyScreenState extends State<CreateUpdatePolicyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _effectiveDateController = TextEditingController();

  String? _selectedType;
  DateTime? _selectedDate;
  List<Map<String, String>> _policyDetails = [];
  final List<GlobalKey<FormState>> _detailKeys = [];

  final List<String> _policyTypes = [
    'leave',
    'attendance',
    'overtime',
    'late',
    'working_hours',
    'others',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingPolicy != null) {
      _loadExistingPolicy();
    } else {
      _addNewDetailField();
    }
  }

  void _loadExistingPolicy() {
    final policy = widget.existingPolicy!;
    _titleController.text = policy['title'] ?? '';
    _selectedType = policy['type'];
    _effectiveDateController.text = policy['effective_date'] ?? '';

    // Load existing details
    final details = policy['details'] as Map<String, dynamic>?;
    if (details != null) {
      _policyDetails =
          details.entries.map((entry) {
            return {'key': entry.key, 'value': entry.value.toString()};
          }).toList();
    }

    if (_policyDetails.isEmpty) {
      _addNewDetailField();
    }
  }

  void _addNewDetailField() {
    setState(() {
      _policyDetails.add({'key': '', 'value': ''});
      _detailKeys.add(GlobalKey<FormState>());
    });
  }

  void _removeDetailField(int index) {
    if (_policyDetails.length > 1) {
      setState(() {
        _policyDetails.removeAt(index);
        _detailKeys.removeAt(index);
      });
    }
  }

  bool _hasDuplicateKeys() {
    final keys = _policyDetails.map((detail) => detail['key']?.trim()).toList();
    final uniqueKeys = keys.toSet();
    return keys.length != uniqueKeys.length;
  }

  List<int> _getDuplicateIndices() {
    final keys = _policyDetails.map((detail) => detail['key']?.trim()).toList();
    final duplicateIndices = <int>[];

    for (int i = 0; i < keys.length; i++) {
      for (int j = i + 1; j < keys.length; j++) {
        if (keys[i] == keys[j] && keys[i]?.isNotEmpty == true) {
          if (!duplicateIndices.contains(i)) duplicateIndices.add(i);
          if (!duplicateIndices.contains(j)) duplicateIndices.add(j);
        }
      }
    }

    return duplicateIndices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 32),
              _buildPolicyTypeSection(),
              const SizedBox(height: 24),
              _buildScopeDisplay(),
              const SizedBox(height: 24),
              _buildPolicyDetailsSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        widget.isEdit ? 'Update Policy' : 'Create Policy',
        style: AppTypography.headline6(color: AppColors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.info.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.isEdit ? Icons.edit_document : Icons.policy,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEdit ? 'Update Policy' : 'Create New Policy',
                      style: AppTypography.headline6(color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Define rules and guidelines for your organization',
                      style: AppTypography.body2(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Policy Information', Icons.info_outline),
        const SizedBox(height: 16),
        _buildCustomTextField(
          controller: _titleController,
          label: 'Policy Title',
          hint: 'Sick Leave Policy',
          icon: Icons.title,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Policy title is required';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildDecorativeDropdownField(
          label: 'Policy Type',
          value: _selectedType,
          items: _policyTypes,
          hint: 'Select policy type',
          icon: Icons.category,
          onChanged: (value) => setState(() => _selectedType = value),
          validator: (value) {
            if (value == null) return 'Policy type is required';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildScopeDisplay() {
    String scopeText = 'Company-wide Policy';
    IconData scopeIcon = Icons.business;
    Color scopeColor = AppColors.primary;

    if (widget.scope == 'department') {
      scopeText = 'Department Policy';
      scopeIcon = Icons.apartment;
      scopeColor = AppColors.info;
    } else if (widget.scope == 'employee') {
      scopeText = 'Employee Policy';
      scopeIcon = Icons.person;
      scopeColor = AppColors.success;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Policy Scope', Icons.groups),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scopeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scopeColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(scopeIcon, color: scopeColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  scopeText,
                  style: AppTypography.body1(
                    color: scopeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: scopeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.scope?.toUpperCase() ?? 'COMPANY',
                  style: AppTypography.caption(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Policy Details', Icons.description),
            IconButton(
              onPressed: _addNewDetailField,
              icon: Icon(Icons.add_circle, color: AppColors.primary, size: 28),
              tooltip: 'Add Detail',
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._policyDetails.asMap().entries.map((entry) {
          final index = entry.key;
          final detail = entry.value;
          final isDuplicate = _getDuplicateIndices().contains(index);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDuplicate
                        ? AppColors.error
                        : AppColors.grey.withValues(alpha: 0.3),
                width: isDuplicate ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: detail['key'],
                        onChanged: (value) {
                          setState(() {
                            _policyDetails[index]['key'] = value;
                          });
                        },
                        style: AppTypography.body1(color: AppColors.black),
                        decoration: InputDecoration(
                          labelText: 'Detail Heading',
                          hintText: 'e.g., max_days, allowed_hours',
                          hintStyle: AppTypography.body2(color: AppColors.grey),
                          filled: true,
                          fillColor: AppColors.primary.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.error
                                      : AppColors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.error
                                      : AppColors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.primary
                                      : AppColors.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.error),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Key is required';
                          if (isDuplicate) return 'Duplicate key not allowed';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: detail['value'],
                        onChanged: (value) {
                          setState(() {
                            _policyDetails[index]['value'] = value;
                          });
                        },
                        style: AppTypography.body1(color: AppColors.black),
                        decoration: InputDecoration(
                          labelText: 'Detail Value',
                          hintText: 'e.g., 30',
                          hintStyle: AppTypography.body2(color: AppColors.grey),
                          filled: true,
                          fillColor: AppColors.primary.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.error
                                      : AppColors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.error
                                      : AppColors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDuplicate
                                      ? AppColors.primary
                                      : AppColors.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.error),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Value is required';
                          }
                          if (isDuplicate) return 'Duplicate key not allowed';
                          return null;
                        },
                      ),
                    ),
                    if (_policyDetails.length > 1)
                      IconButton(
                        onPressed: () => _removeDetailField(index),
                        icon: Icon(Icons.remove_circle, color: AppColors.error),
                        tooltip: 'Remove Detail',
                      ),
                  ],
                ),
                if (isDuplicate) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.error, color: AppColors.error, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Duplicate key detected! Please use unique keys.',
                        style: AppTypography.caption(color: AppColors.error),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildDateField(),
      ],
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: _buildCustomTextField(
          controller: _effectiveDateController,
          label: 'Effective Date',
          hint: 'Select date',
          icon: Icons.event,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Effective date is required';
            return null;
          },
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _effectiveDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTypography.headline6(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTypography.body1(color: AppColors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body2(color: AppColors.grey),
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.primary.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.grey.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.grey.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            validator: validator,
            onChanged: onChanged,
            style: AppTypography.body1(color: AppColors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.body2(color: AppColors.grey),
              prefixIcon: Icon(icon, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.replaceAll('_', ' ').toUpperCase(),
                          style: AppTypography.body1(color: AppColors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
            dropdownColor: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              widget.isEdit ? 'Update Policy' : 'Create Policy',
              style: AppTypography.button(color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTypography.button(color: AppColors.grey),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_hasDuplicateKeys()) {
        // Trigger vibration effect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fix duplicate keys before submitting!',
              style: AppTypography.body2(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      final details = <String, dynamic>{};
      for (final detail in _policyDetails) {
        final key = detail['key']?.trim();
        final value = detail['value']?.trim();
        if (key != null &&
            value != null &&
            key.isNotEmpty &&
            value.isNotEmpty) {
          // Try to parse as number, otherwise keep as string
          final numValue = num.tryParse(value);
          details[key] = numValue ?? value;
        }
      }

      final policyData = {
        'type': _selectedType,
        'title': _titleController.text,
        'details': details,
        'effective_date': _effectiveDateController.text,
      };

      // Add scope-specific fields based on parameters
      if (widget.scope == 'employee' && widget.scopeId != null) {
        policyData['employee'] = widget.scopeId;
      } else if (widget.scope == 'department' && widget.scopeId != null) {
        policyData['department'] = widget.scopeId;
      } else if (widget.scopeId != null) {
        policyData['company'] = widget.scopeId;
      }

      // TODO: Implement API call to create/update policy
      print('Policy Data: $policyData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? 'Policy updated successfully!'
                : 'Policy created successfully!',
            style: AppTypography.body2(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _effectiveDateController.dispose();
    super.dispose();
  }
}
