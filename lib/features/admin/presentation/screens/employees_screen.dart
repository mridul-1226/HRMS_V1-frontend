import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Employees',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) => _buildEmployeeCard(index),
      ),
    );
  }

  Widget _buildEmployeeCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              'E${index + 1}',
              style: AppTypography.body2(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee ${index + 1}',
                  style: AppTypography.body1(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Software Developer',
                  style: AppTypography.body2(color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  'EMP00${index + 1}',
                  style: AppTypography.caption(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu actions
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Text('View Details', style: AppTypography.body2()),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit', style: AppTypography.body2()),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      'Remove',
                      style: AppTypography.body2(color: Colors.red),
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
