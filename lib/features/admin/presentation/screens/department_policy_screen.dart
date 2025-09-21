import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/utils/toast.dart';
import 'package:hrms/features/admin/presentation/blocs/policy_bloc/policy_bloc.dart';

class DepartmentPolicyScreen extends StatefulWidget {
  final String scopeId;
  final String scope;

  const DepartmentPolicyScreen({
    super.key,
    required this.scopeId,
    required this.scope,
  });

  @override
  State<DepartmentPolicyScreen> createState() => _DepartmentPolicyScreenState();
}

class _DepartmentPolicyScreenState extends State<DepartmentPolicyScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _companyPolicies = [];
  Map<String, Map<String, dynamic>> _departmentPolicies = {};

  final List<String> _policyTypes = [
    'leave',
    'attendance',
    'overtime',
    'late',
    'working_hours',
    'others',
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCompanyPolicies();
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

  void _loadCompanyPolicies() {
    context.read<PolicyBloc>().add(
      LoadPolicies(scope: '', scopeId: int.tryParse(widget.scopeId)),
    );
  }

  Map<String, IconData> _getPolicyIcons() {
    return {
      'leave': Icons.event_available,
      'attendance': Icons.access_time,
      'overtime': Icons.work_history,
      'late': Icons.schedule,
      'working_hours': Icons.schedule_outlined,
      'others': Icons.policy,
    };
  }

  Map<String, Color> _getPolicyColors() {
    return {
      'leave': Colors.green,
      'attendance': Colors.blue,
      'overtime': Colors.orange,
      'late': Colors.red,
      'working_hours': Colors.purple,
      'others': Colors.grey,
    };
  }

  String _getPolicyTitle(String type) {
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
        return 'Other Policies';
      default:
        return 'Policy';
    }
  }

  void _navigateToEditPolicy(String type) {
    context
        .pushNamed(
          'create-policy',
          queryParameters: {
            'scope': 'department',
            'scopeId': widget.scopeId,
            'type': type,
          },
        )
        .then((result) {
          if (result == true) {
            _loadCompanyPolicies();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PolicyBloc, PolicyState>(
      listener: (context, state) {
        if (state is PolicyLoaded) {
          setState(() {
            _companyPolicies = state.policies;
            _departmentPolicies = {};
            for (var policy in state.policies) {
              if (policy['department'] == widget.scopeId) {
                _departmentPolicies[policy['type']] = policy;
              }
            }
          });
        } else if (state is PolicyError) {
          Toast.show(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is PolicyLoading;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              '${widget.scope} Policies',
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
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderCard(),
                          const SizedBox(height: 20),
                          Text(
                            'Policy Types',
                            style: AppTypography.headline6(),
                          ),
                          const SizedBox(height: 16),
                          _buildPolicyList(),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.business, color: AppColors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.scope,
                      style: AppTypography.headline6(color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customize policies for this department',
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

  Widget _buildPolicyList() {
    return Column(
      children:
          _policyTypes.map((type) {
            final hasCompanyPolicy = _companyPolicies.any(
              (p) => p['type'] == type && p['department'] == null,
            );
            final hasDepartmentPolicy = _departmentPolicies.containsKey(type);
            final icons = _getPolicyIcons();
            final colors = _getPolicyColors();

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors[type]!.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icons[type], color: colors[type], size: 24),
                ),
                title: Text(
                  _getPolicyTitle(type),
                  style: AppTypography.body2(),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (hasCompanyPolicy)
                      Text(
                        'Company policy available',
                        style: AppTypography.caption(color: AppColors.grey),
                      ),
                    if (hasDepartmentPolicy)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Department policy active',
                          style: AppTypography.caption(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed:
                        () => _navigateToEditPolicy(type), // Always enabled now
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasDepartmentPolicy
                              ? AppColors.info
                              : AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      hasDepartmentPolicy ? 'Edit' : 'Customize',
                      style: AppTypography.caption(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
