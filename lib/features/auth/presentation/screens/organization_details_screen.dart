import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrganizationDetailsScreen extends StatefulWidget {
  const OrganizationDetailsScreen({super.key});

  @override
  State<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState extends State<OrganizationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _taxIdController = TextEditingController();

  String? _selectedIndustry;
  String? _selectedCompanySize;
  bool _isLoading = false;

  final List<String> _industries = [
    'Information Technology',
    'Manufacturing',
    'Retail',
    'Healthcare',
    'Finance',
    'Education',
    'Real Estate',
    'Other',
  ];

  final List<String> _companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '200+ employees',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about your organization',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This information helps us customize your experience',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 32),

              Text(
                'Required Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade600,
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name *',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., ABC Corp',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Company name is required';
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _companyEmailController,
                decoration: InputDecoration(
                  labelText: 'Company Email *',
                  border: OutlineInputBorder(),
                  hintText: 'contact@company.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Company email is required';
                  }
                  if (!value!.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: InputDecoration(
                  labelText: 'Industry Type *',
                  border: OutlineInputBorder(),
                ),
                items:
                    _industries.map((industry) {
                      return DropdownMenuItem(
                        value: industry,
                        child: Text(industry),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedIndustry = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select an industry';
                  return null;
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCompanySize,
                decoration: InputDecoration(
                  labelText: 'Company Size *',
                  border: OutlineInputBorder(),
                ),
                items:
                    _companySizes.map((size) {
                      return DropdownMenuItem(value: size, child: Text(size));
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCompanySize = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select company size';
                  return null;
                },
              ),
              SizedBox(height: 32),

              Text(
                'Optional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Company Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Website URL',
                  border: OutlineInputBorder(),
                  hintText: 'https://company.com',
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _taxIdController,
                decoration: InputDecoration(
                  labelText: 'Tax ID',
                  border: OutlineInputBorder(),
                  hintText: 'For payroll compliance',
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDetails,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Save & Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(Duration(seconds: 2));
      setState(() => _isLoading = false);
      context.goNamed('admin-dashboard');
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyEmailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }
}
