import 'package:flutter/material.dart';
import 'package:hrms/core/config/color_cofig.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/features/admin/presentation/screens/company_details_screen.dart';
import 'package:hrms/features/admin/presentation/screens/notifications_screen.dart';
import 'package:hrms/features/admin/presentation/widgets/main_sections_grid.dart';
import 'package:hrms/features/admin/presentation/widgets/quick_actions.dart';
import 'package:hrms/features/admin/presentation/widgets/quick_stats.dart';
import 'package:hrms/features/admin/presentation/widgets/welcome_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Admin Dashboard',
          style: AppTypography.headline6(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  _showLogoutDialog(context);
                  break;
                case 'company':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CompanyDetailsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'company',
                    child: Row(
                      children: [
                        const Icon(Icons.business, size: 20),
                        const SizedBox(width: 8),
                        Text('Company Details', style: AppTypography.body2()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: AppTypography.body2(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeCard(),
            const SizedBox(height: 20),
            const QuickStats(),
            const SizedBox(height: 20),
            MainSectionsGrid(context: context),
            const SizedBox(height: 20),
            QuickActions(context: context, onLogout: () => _showLogoutDialog(context)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout', style: AppTypography.headline6()),
            content: Text(
              'Are you sure you want to logout?',
              style: AppTypography.body2(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: AppTypography.button()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle logout logic here
                },
                child: Text(
                  'Logout',
                  style: AppTypography.button(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}