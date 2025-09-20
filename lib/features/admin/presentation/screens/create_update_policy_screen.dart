import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/features/admin/presentation/blocs/policy_bloc/policy_bloc.dart';

class CreateUpdatePolicyScreen extends StatefulWidget {
  final String? scope;
  final int? scopeId;

  const CreateUpdatePolicyScreen({super.key, this.scope, this.scopeId});

  @override
  State<CreateUpdatePolicyScreen> createState() =>
      _CreateUpdatePolicyScreenState();
}

class _CreateUpdatePolicyScreenState extends State<CreateUpdatePolicyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Store all policies data
  final Map<String, Map<String, dynamic>> _policiesData = {};
  final Map<String, List<Map<String, String>>> _policiesDetails = {};
  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _dateControllers = {};

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
    _initializePolicies();
    // Load policies when screen opens
    context.read<PolicyBloc>().add(
      LoadPolicies(scope: widget.scope ?? '', scopeId: widget.scopeId),
    );
  }

  void _initializePolicies() {
    for (final type in _policyTypes) {
      _policiesData[type] = {
        'type': type,
        'title': '',
        'effective_date': '',
        'isEnabled': type != 'others', // Others is optional
      };
      _policiesDetails[type] = [
        {'key': '', 'value': ''},
      ];
      _titleControllers[type] = TextEditingController();
      _dateControllers[type] = TextEditingController();
    }
  }

  void _loadExistingPolicies(List<Map<String, dynamic>> policies) {
    // Clear all fields first
    _initializePolicies();
    for (final policy in policies) {
      final type = policy['type'] as String;
      if (_policyTypes.contains(type)) {
        _policiesData[type]!['title'] = policy['title'] ?? '';
        _policiesData[type]!['effective_date'] = policy['effective_date'] ?? '';
        _policiesData[type]!['isEnabled'] = true;
        _titleControllers[type]!.text = policy['title'] ?? '';
        _dateControllers[type]!.text = policy['effective_date'] ?? '';
        final details = policy['details'] as Map<String, dynamic>?;
        if (details != null) {
          _policiesDetails[type] =
              details.entries.map((entry) {
                return {'key': entry.key, 'value': entry.value.toString()};
              }).toList();
        }
        if (_policiesDetails[type]!.isEmpty) {
          _policiesDetails[type]!.add({'key': '', 'value': ''});
        }
      }
    }
    setState(() {});
  }

  void _addDetailField(String type) {
    setState(() {
      _policiesDetails[type]!.add({'key': '', 'value': ''});
    });
  }

  void _removeDetailField(String type, int index) {
    if (_policiesDetails[type]!.length > 1) {
      setState(() {
        _policiesDetails[type]!.removeAt(index);
      });
    }
  }

  bool _hasDuplicateKeys(String type) {
    final keys =
        _policiesDetails[type]!.map((detail) => detail['key']?.trim()).toList();
    final uniqueKeys = keys.toSet();
    return keys.length != uniqueKeys.length;
  }

  List<int> _getDuplicateIndices(String type) {
    final keys =
        _policiesDetails[type]!.map((detail) => detail['key']?.trim()).toList();
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

  void _nextPage() {
    if (_currentPage < _policyTypes.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOthers() {
    // Mark others as disabled and submit all policies
    setState(() {
      _policiesData['others']!['isEnabled'] = false;
    });
    _handleSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PolicyBloc, PolicyState>(
      listener: (context, state) {
        if (state is PolicyLoaded) {
          _loadExistingPolicies(state.policies);
        } else if (state is PolicyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppTypography.body2(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is PolicyOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppTypography.body2(color: AppColors.white),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          context.goNamed('admin-dashboard');
        }
      },
      builder: (context, state) {
        final isScreenLoading = state is PolicyLoading;
        final isButtonLoading = state is PolicyCreatingOrUpdating;
        return IgnorePointer(
          ignoring: isScreenLoading || isButtonLoading,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: _buildAppBar(),
                body: Column(
                  children: [
                    _buildProgressIndicator(),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                          _syncControllersWithData(_policyTypes[page]);
                        },
                        itemCount: _policyTypes.length,
                        itemBuilder: (context, index) {
                          final currentType = _policyTypes[index];
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _syncControllersWithData(currentType);
                          });
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderSection(),
                                const SizedBox(height: 32),
                                _buildPolicyTypePage(_policyTypes[index]),
                                const SizedBox(height: 32),
                                _buildNavigationButtons(
                                  isButtonLoading: isButtonLoading,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (isScreenLoading)
                Container(
                  color: AppColors.white.withOpacity(0.7),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
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
        'Create Policies',
        style: AppTypography.headline6(color: AppColors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _policyTypes.length,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color:
                        index <= _currentPage
                            ? AppColors.primary
                            : AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentPage + 1} of ${_policyTypes.length}',
            style: AppTypography.caption(color: AppColors.grey),
          ),
        ],
      ),
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
                child: Icon(Icons.policy, color: AppColors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPolicyTypeTitle(_policyTypes[_currentPage]),
                      style: AppTypography.headline6(color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPolicyTypeDescription(_policyTypes[_currentPage]),
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

  String _getPolicyTypeTitle(String type) {
    switch (type) {
      case 'leave':
        return 'Leave Policy';
      case 'attendance':
        return 'Attendance Policy';
      case 'overtime':
        return 'Overtime Policy';
      case 'late':
        return 'Late Policy';
      case 'working_hours':
        return 'Working Hours Policy';
      case 'others':
        return 'Other Policies (Optional)';
      default:
        return 'Policy';
    }
  }

  String _getPolicyTypeDescription(String type) {
    switch (type) {
      case 'leave':
        return 'Define leave rules and guidelines';
      case 'attendance':
        return 'Set attendance requirements and rules';
      case 'overtime':
        return 'Configure overtime policies and rates';
      case 'late':
        return 'Establish late arrival policies';
      case 'working_hours':
        return 'Define standard working hours';
      case 'others':
        return 'Add any additional policies as needed';
      default:
        return 'Define rules and guidelines';
    }
  }

  Widget _buildPolicyTypePage(String type) {
    final isEnabled = _policiesData[type]!['isEnabled'] as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (type == 'others') ...[
          _buildEnableToggle(type),
          const SizedBox(height: 16),
        ],
        if (isEnabled) ...[
          _buildCustomTextField(
            controller: _titleControllers[type]!,
            label: 'Policy Title',
            hint: 'Enter policy title',
            icon: Icons.title,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Policy title is required';
              return null;
            },
            onChanged: (value) {
              _policiesData[type]!['title'] = value;
            },
          ),
          const SizedBox(height: 16),
          _buildPolicyDetailsSection(type),
          const SizedBox(height: 16),
          _buildDateField(type),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                'This policy type is disabled',
                style: AppTypography.body1(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEnableToggle(String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Enable Other Policies',
              style: AppTypography.body1(color: AppColors.black),
            ),
          ),
          Switch(
            value: _policiesData[type]!['isEnabled'] as bool,
            onChanged: (value) {
              setState(() {
                _policiesData[type]!['isEnabled'] = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyDetailsSection(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Policy Details', Icons.description),
            IconButton(
              onPressed: () => _addDetailField(type),
              icon: Icon(Icons.add_circle, color: AppColors.primary, size: 28),
              tooltip: 'Add Detail',
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._policiesDetails[type]!.asMap().entries.map((entry) {
          final index = entry.key;
          final detail = entry.value;
          final isDuplicate = _getDuplicateIndices(type).contains(index);

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
                            _policiesDetails[type]![index]['key'] = value;
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
                            _policiesDetails[type]![index]['value'] = value;
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
                    if (_policiesDetails[type]!.length > 1)
                      IconButton(
                        onPressed: () => _removeDetailField(type, index),
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
      ],
    );
  }

  Widget _buildDateField(String type) {
    return GestureDetector(
      onTap: () => _selectDate(type),
      child: AbsorbPointer(
        child: _buildCustomTextField(
          controller: _dateControllers[type]!,
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

  Future<void> _selectDate(String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        final dateString =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _policiesData[type]!['effective_date'] = dateString;
        _dateControllers[type]!.text = dateString;
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

  Widget _buildNavigationButtons({bool isButtonLoading = false}) {
    final isLastPage = _currentPage == _policyTypes.length - 1;
    final isFirstPage = _currentPage == 0;
    final currentType = _policyTypes[_currentPage];
    final isEnabled = _policiesData[currentType]!['isEnabled'] as bool;

    return Column(
      children: [
        Row(
          children: [
            if (!isFirstPage)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousPage,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Previous',
                    style: AppTypography.button(color: AppColors.primary),
                  ),
                ),
              ),
            if (!isFirstPage) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    isButtonLoading
                        ? null
                        : () => _handleNextOrSubmit(
                          currentType,
                          isLastPage,
                          isEnabled,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    isButtonLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : Text(
                          _getNextButtonText(
                            currentType,
                            isLastPage,
                            isEnabled,
                          ),
                          style: AppTypography.button(color: AppColors.white),
                        ),
              ),
            ),
          ],
        ),
        if (isLastPage) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: isButtonLoading ? null : () => context.pop(),
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
      ],
    );
  }

  String _getNextButtonText(
    String currentType,
    bool isLastPage,
    bool isEnabled,
  ) {
    if (isLastPage) {
      return 'Submit All Policies';
    } else if (currentType == 'others' && !isEnabled) {
      return 'Skip & Submit';
    } else {
      return 'Next';
    }
  }

  void _handleNextOrSubmit(
    String currentType,
    bool isLastPage,
    bool isEnabled,
  ) {
    if (isLastPage) {
      _handleSubmit();
    } else if (currentType == 'others' && !isEnabled) {
      _skipOthers();
    } else {
      _validateAndNext(currentType);
    }
  }

  void _validateAndNext(String currentType) {
    // Validate current page before proceeding
    if (!_validateCurrentPage(currentType)) {
      return;
    }

    // If validation passes, go to next page
    _nextPage();
  }

  bool _validateCurrentPage(String currentType) {
    final isEnabled = _policiesData[currentType]!['isEnabled'] as bool;

    // If this policy type is disabled (only applies to 'others'), skip validation
    if (!isEnabled) {
      return true;
    }

    // Check if title is filled
    if (_policiesData[currentType]!['title'].toString().isEmpty) {
      _showValidationError('Please enter a policy title');
      return false;
    }

    // Check if effective date is selected
    if (_policiesData[currentType]!['effective_date'].toString().isEmpty) {
      _showValidationError('Please select an effective date');
      return false;
    }

    // Check for duplicate keys
    if (_hasDuplicateKeys(currentType)) {
      _showValidationError('Please fix duplicate parameter names');
      return false;
    }

    // Check if all detail fields are filled
    for (final detail in _policiesDetails[currentType]!) {
      final key = detail['key'];
      final value = detail['value'];
      if ((key == null || key.isEmpty) || (value == null || value.isEmpty)) {
        _showValidationError('Please fill all parameter fields');
        return false;
      }
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.body2(color: AppColors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleSubmit() {
    // Validate all enabled policies
    bool hasErrors = false;
    String errorMessage = '';

    for (final type in _policyTypes) {
      if (_policiesData[type]!['isEnabled'] as bool) {
        // Check if title is filled
        if (_policiesData[type]!['title'].toString().isEmpty) {
          hasErrors = true;
          errorMessage = 'Please fill all policy titles';
          break;
        }

        // Check if effective date is selected
        if (_policiesData[type]!['effective_date'].toString().isEmpty) {
          hasErrors = true;
          errorMessage = 'Please select effective dates for all policies';
          break;
        }

        // Check for duplicate keys
        if (_hasDuplicateKeys(type)) {
          hasErrors = true;
          errorMessage = 'Please fix duplicate parameter names in all policies';
          break;
        }

        // Check if all detail fields are filled
        for (final detail in _policiesDetails[type]!) {
          final key = detail['key'];
          final value = detail['value'];
          if ((key == null || key.isEmpty) ||
              (value == null || value.isEmpty)) {
            hasErrors = true;
            errorMessage = 'Please fill all parameter fields in all policies';
            break;
          }
        }

        if (hasErrors) break;
      }
    }

    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
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

    // Prepare all policies data
    final allPolicies = <Map<String, dynamic>>[];

    for (final type in _policyTypes) {
      if (_policiesData[type]!['isEnabled'] as bool) {
        final details = <String, dynamic>{};
        for (final detail in _policiesDetails[type]!) {
          final key = detail['key']?.trim();
          final value = detail['value']?.trim();
          if (key != null &&
              value != null &&
              key.isNotEmpty &&
              value.isNotEmpty) {
            final numValue = num.tryParse(value);
            details[key] = numValue ?? value;
          }
        }

        final policyData = {
          'type': type,
          'title': _policiesData[type]!['title'],
          'details': details,
          'effective_date': _policiesData[type]!['effective_date'],
        };

        // Add scope-specific fields
        if (widget.scope == 'employee' && widget.scopeId != null) {
          policyData['employee'] = widget.scopeId;
        } else if (widget.scope == 'department' && widget.scopeId != null) {
          policyData['department'] = widget.scopeId;
        } else if (widget.scopeId != null) {
          policyData['company'] = widget.scopeId;
        }

        allPolicies.add(policyData);
      }
    }

    // Dispatch CreateOrUpdatePolicy event
    context.read<PolicyBloc>().add(
      CreateOrUpdatePolicy(
        policyData: {'policies': allPolicies},
        isEdit: false,
      ),
    );
  }

  void _syncControllersWithData(String type) {
    // Sync title controller
    if (_titleControllers[type]!.text != _policiesData[type]!['title']) {
      _titleControllers[type]!.text = _policiesData[type]!['title'] as String;
    }

    // Sync date controller
    if (_dateControllers[type]!.text !=
        _policiesData[type]!['effective_date']) {
      _dateControllers[type]!.text =
          _policiesData[type]!['effective_date'] as String;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _titleControllers.values) {
      controller.dispose();
    }
    for (final controller in _dateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
