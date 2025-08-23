import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Employees', '124', Icons.people)),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Pending Leaves', '8', Icons.pending_actions),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Announcements', '3', Icons.campaign)),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
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
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(count, style: AppTypography.headline6(color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
