import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/core/utils/toast.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';
import 'package:hrms/features/admin/presentation/blocs/org_detail_bloc/org_detail_bloc.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class OrganizationDetailsScreen extends StatefulWidget {
  const OrganizationDetailsScreen({super.key});

  @override
  State<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState extends State<OrganizationDetailsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _taxIdController = TextEditingController();
  final prefs = getIt<SharedPrefService>();

  String? _selectedIndustry;
  String? _selectedCompanySize;
  bool _isLoading = false;

  // Country code picker
  final FlCountryCodePicker _countryPicker = const FlCountryCodePicker();
  CountryCode? _selectedCountryCode;

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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Prefill fields from shared prefs, use empty string if null
    _companyNameController.text =
        prefs.getString(LocalStorageKeys.companyName)?.trim().isNotEmpty == true
            ? prefs.getString(LocalStorageKeys.companyName)!
            : '';
    _companyEmailController.text =
        prefs.getString(LocalStorageKeys.email)?.trim().isNotEmpty == true
            ? prefs.getString(LocalStorageKeys.email)!
            : '';
    _addressController.text =
        prefs.getString(LocalStorageKeys.companyAddress)?.trim().isNotEmpty ==
                true
            ? prefs.getString(LocalStorageKeys.companyAddress)!
            : '';
    _phoneController.text =
        prefs.getString(LocalStorageKeys.companyPhone)?.trim().isNotEmpty ==
                true
            ? prefs.getString(LocalStorageKeys.companyPhone)!
            : '';
    _websiteController.text =
        prefs.getString(LocalStorageKeys.companyWebsite)?.trim().isNotEmpty ==
                true
            ? prefs.getString(LocalStorageKeys.companyWebsite)!
            : '';
    _taxIdController.text =
        prefs.getString(LocalStorageKeys.companyTaxId)?.trim().isNotEmpty ==
                true
            ? prefs.getString(LocalStorageKeys.companyTaxId)!
            : '';

    // Dropdowns: if value is null/empty, keep null so hint shows
    final industry = prefs.getString(LocalStorageKeys.companyIndustry);
    _selectedIndustry =
        (industry != null && industry.trim().isNotEmpty) ? industry : null;
    final size = prefs.getString(LocalStorageKeys.companySize);
    _selectedCompanySize =
        (size != null && size.trim().isNotEmpty) ? size : null;

    // Country code: if null/empty, default to +91
    final savedCode = prefs.getString(LocalStorageKeys.countryCode);
    _selectedCountryCode =
        (savedCode != null && savedCode.trim().isNotEmpty)
            ? CountryCode.fromDialCode(savedCode)
            : CountryCode.fromDialCode('+91');
    _selectedCountryCode ??= const CountryCode(
      name: 'India',
      code: 'IN',
      dialCode: '+91',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Organization Details',
          style: AppTypography.headline6(color: AppColors.primary),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<OrgDetailBloc, OrgDetailState>(
        listener: (context, state) {
          if (state is OrgDetailStoring) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
            if (state is OrgDetailStored) {
              context.goNamed('admin-dashboard');
            } else if (state is OrgDetailError) {
              Toast.show(message: state.message, isError: true);
            }
          }
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.info.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.info,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tell us about your organization',
                          style: AppTypography.headline5(
                            color: AppColors.info,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This information helps us customize your experience',
                          style: AppTypography.body1(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Required Information Section
                  _buildSectionHeader(
                    'Required Information',
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _companyNameController,
                    label: 'Company Name',
                    icon: Icons.business_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _companyEmailController,
                    label: 'Company Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Company email is required';
                      }
                      if (!value!.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    value: _selectedIndustry,
                    label: 'Industry Type',
                    icon: Icons.category_outlined,
                    items: _industries,
                    onChanged:
                        (value) => setState(() => _selectedIndustry = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an industry';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    value: _selectedCompanySize,
                    label: 'Company Size',
                    icon: Icons.groups_outlined,
                    items: _companySizes,
                    onChanged:
                        (value) => setState(() => _selectedCompanySize = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select company size';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone with country code picker
                  _buildPhoneField(),
                  const SizedBox(height: 32),

                  // Optional Information Section
                  _buildSectionHeader('Optional Information', AppColors.grey),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _addressController,
                    label: 'Company Address',
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website URL',
                    icon: Icons.language_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _taxIdController,
                    label: 'Tax ID',
                    icon: Icons.receipt_long_outlined,
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.info],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: AppColors.white,
                              )
                              : Text(
                                'Save & Continue',
                                style: AppTypography.button(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.headline6(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTypography.body1(color: AppColors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.body2(color: AppColors.grey),
          prefixIcon: Icon(icon, color: AppColors.info),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.info, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.body2(color: AppColors.grey),
          prefixIcon: Icon(icon, color: AppColors.info),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.info, width: 2),
          ),
        ),
        style: AppTypography.body1(color: AppColors.black),
        items:
            items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppTypography.body1(color: AppColors.black),
                ),
              );
            }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: AppTypography.body1(color: AppColors.black),
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: AppTypography.body2(color: AppColors.grey),
          prefixIcon: InkWell(
            onTap: () async {
              final code = await _countryPicker.showPicker(context: context);
              if (code != null) {
                setState(() => _selectedCountryCode = code);
                await prefs.setString(
                  LocalStorageKeys.countryCode,
                  code.dialCode,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectedCountryCode?.flagImage() ?? const SizedBox(),
                  const SizedBox(width: 4),
                  Text(
                    _selectedCountryCode?.dialCode ?? '+91',
                    style: AppTypography.body1(color: AppColors.info),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.info),
                ],
              ),
            ),
          ),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.info, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Phone number is required';
          }
          return null;
        },
      ),
    );
  }

  void _saveDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final company = Company(
        companyId: prefs.getString(LocalStorageKeys.companyId) ?? '',
        ownerName: prefs.getString(LocalStorageKeys.name) ?? '',
        companyName: _companyNameController.text.trim(),
        email: _companyEmailController.text.trim(),
        industry: _selectedIndustry!,
        size: _selectedCompanySize!,
        address: _addressController.text.trim(),
        countryCode: _selectedCountryCode?.dialCode ?? '+91',
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim(),
        taxId: _taxIdController.text.trim(),
      );

      context.read<OrgDetailBloc>().add(OrgDetailStoreEvent(company));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _companyNameController.dispose();
    _companyEmailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }
}
