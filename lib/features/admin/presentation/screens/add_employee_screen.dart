import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartment;

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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFormSection('Personal Information', [
                _buildTextField('Full Name', 'Enter full name'),
                _buildTextField('Email', 'Enter email address'),
                _buildTextField('Phone', 'Enter phone number'),
                _buildTextField('Address', 'Enter address', maxLines: 3),
              ]),
              const SizedBox(height: 20),
              _buildFormSection('Employment Details', [
                _buildTextField('Employee ID', 'Enter employee ID'),
                _buildDropdownField(
                  'Department',
                  _selectedDepartment,
                  ['Engineering', 'HR', 'Finance', 'Marketing', 'Sales'],
                  (value) => setState(() => _selectedDepartment = value),
                ),
                _buildTextField('Position', 'Enter position/role'),
                _buildTextField('Salary', 'Enter salary'),
                _buildTextField('Start Date', 'Select start date'),
              ]),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add Employee',
                    style: AppTypography.button(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headline6()),
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

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      style: AppTypography.body2(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        labelStyle: AppTypography.body2(),
        hintStyle: AppTypography.body2(color: Colors.grey[500]),
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
        border: const OutlineInputBorder(),
        labelStyle: AppTypography.body2(),
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
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Employee added successfully!',
            style: AppTypography.body2(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
