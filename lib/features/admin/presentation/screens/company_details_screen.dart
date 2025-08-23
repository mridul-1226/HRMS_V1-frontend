import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Company Details',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCompanyHeader(),
            const SizedBox(height: 20),
            _buildCompanyInfo(),
            const SizedBox(height: 20),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('Tech Solutions Inc.', style: AppTypography.headline6()),
          const SizedBox(height: 4),
          Text(
            'Software Development Company',
            style: AppTypography.body2(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company Information', style: AppTypography.headline6()),
          const SizedBox(height: 16),
          _buildInfoRow('Registration Number', 'REG123456789'),
          _buildInfoRow('Tax ID', 'TAX987654321'),
          _buildInfoRow('Founded', 'January 2015'),
          _buildInfoRow('Employees', '124'),
          _buildInfoRow('Industry', 'Information Technology'),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information', style: AppTypography.headline6()),
          const SizedBox(height: 16),
          _buildInfoRow('Address', '123 Business Street, Tech City, TC 12345'),
          _buildInfoRow('Phone', '+1 (555) 123-4567'),
          _buildInfoRow('Email', 'info@techsolutions.com'),
          _buildInfoRow('Website', 'www.techsolutions.com'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.body2(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body2(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
