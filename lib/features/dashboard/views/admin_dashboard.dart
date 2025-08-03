import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, Admin!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/employee-management'),
              child: Text('Manage Employees'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/leave-management'),
              child: Text('Manage Leaves'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/payroll'),
              child: Text('Payroll'),
            ),
          ],
        ),
      ),
    );
  }
}