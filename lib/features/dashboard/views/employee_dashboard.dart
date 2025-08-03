import 'package:flutter/material.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, Employee!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/apply-leave'),
              child: Text('Apply Leave'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/payslips'),
              child: Text('View Payslips'),
            ),
          ],
        ),
      ),
    );
  }
}