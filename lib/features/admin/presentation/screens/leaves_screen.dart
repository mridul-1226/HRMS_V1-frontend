import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Leave Requests',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) => _buildLeaveCard(index),
      ),
    );
  }

  Widget _buildLeaveCard(int index) {
    final isApproved = index % 3 == 0;
    final isPending = index % 3 == 1;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Employee ${index + 1}',
                  style: AppTypography.body1(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isApproved
                          ? Colors.green.withValues(alpha: 0.1)
                          : isPending
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isApproved
                      ? 'Approved'
                      : isPending
                      ? 'Pending'
                      : 'Rejected',
                  style: AppTypography.caption(
                    color:
                        isApproved
                            ? Colors.green
                            : isPending
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sick Leave',
            style: AppTypography.body2(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Dec 15, 2023 - Dec 17, 2023 (3 days)',
            style: AppTypography.caption(color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Need to take care of sick family member...',
            style: AppTypography.body2(),
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Approve',
                      style: AppTypography.button(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Reject',
                      style: AppTypography.button(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
