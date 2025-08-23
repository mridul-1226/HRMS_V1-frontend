import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/features/admin/presentation/screens/announcements_screen.dart';
import 'package:hrms/features/admin/presentation/screens/employees_screen.dart';
import 'package:hrms/features/admin/presentation/screens/leaves_screen.dart';
import 'package:hrms/features/admin/presentation/screens/add_employee_screen.dart';

class MainSectionsGrid extends StatelessWidget {
  final BuildContext context;
  const MainSectionsGrid({required this.context, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Main Sections', style: AppTypography.headline6()),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildSectionCard(
              'Announcements',
              Icons.campaign,
              Colors.orange,
              () => Navigator.push(
                this.context,
                MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
              ),
            ),
            _buildSectionCard(
              'Employees',
              Icons.people,
              Colors.blue,
              () => Navigator.push(
                this.context,
                MaterialPageRoute(builder: (_) => const EmployeesScreen()),
              ),
            ),
            _buildSectionCard(
              'Leave Requests',
              Icons.pending_actions,
              Colors.green,
              () => Navigator.push(
                this.context,
                MaterialPageRoute(builder: (_) => const LeavesScreen()),
              ),
            ),
            _buildSectionCard(
              'Add Employee',
              Icons.person_add,
              Colors.purple,
              () => Navigator.push(
                this.context,
                MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTypography.body2(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
