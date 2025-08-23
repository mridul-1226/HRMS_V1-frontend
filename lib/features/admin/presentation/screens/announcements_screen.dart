import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Announcements',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddAnnouncementDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => _buildAnnouncementCard(index),
      ),
    );
  }

  Widget _buildAnnouncementCard(int index) {
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
                  'Company Update #${index + 1}',
                  style: AppTypography.headline6(),
                ),
              ),
              Text(
                '2 days ago',
                style: AppTypography.caption(color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Important announcement regarding company policies and procedures...',
            style: AppTypography.body2(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                '124 views',
                style: AppTypography.caption(color: Colors.grey[500]),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text('Edit', style: AppTypography.button()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('New Announcement', style: AppTypography.headline6()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  style: AppTypography.body2(),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  style: AppTypography.body2(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: AppTypography.button()),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Post',
                  style: AppTypography.button(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
