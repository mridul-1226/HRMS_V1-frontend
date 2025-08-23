import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/features/admin/presentation/screens/company_details_screen.dart';
import 'package:hrms/features/admin/presentation/screens/notifications_screen.dart';

class QuickActions extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onLogout;
  const QuickActions({
    required this.context,
    required this.onLogout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTypography.headline6()),
        const SizedBox(height: 12),
        Container(
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
            children: [
              _buildActionTile(
                'Company Details',
                Icons.business,
                () => Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (_) => const CompanyDetailsScreen(),
                  ),
                ),
              ),
              const Divider(),
              _buildActionTile(
                'Notifications',
                Icons.notifications,
                () => Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              const Divider(),
              _buildActionTile(
                'Logout',
                Icons.logout,
                onLogout,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTypography.body1(color: isDestructive ? Colors.red : null),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
