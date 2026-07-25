// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/screens/trip_logs/all_trips.dart';
import 'package:hanvic_sales_tracker/screens/settings/profile.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/add_driver.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/view_drivers.dart';
import 'package:hanvic_sales_tracker/screens/sales_documentation/receipts.dart';
import 'package:hanvic_sales_tracker/screens/sales_documentation/quotations.dart';
import 'package:hanvic_sales_tracker/screens/sales_documentation/invoice.dart';
import 'package:hanvic_sales_tracker/screens/reports/monthly_report.dart';
import 'package:hanvic_sales_tracker/screens/reports/daily_report.dart';
import 'package:hanvic_sales_tracker/screens/settings/change_password.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  DateTime? _selectedDate;
  String? _selectedMonth;
  String? _selectedDriver;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> _drivers = [
    'Driver 1',
    'Driver 2',
    'Driver 3',
    'Driver 4',
  ];

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatCard('Total Trips Today', '120', Colors.blue),
                SizedBox(height: 16),
                _buildStatCard('Total Drivers', '25', Colors.green),
                SizedBox(height: 16),
                _buildStatCard('Total Sales Today', '\$5,000', Colors.orange),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Choose a date'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Month',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedMonth,
                  items:
                      _months
                          .map(
                            (month) => DropdownMenuItem(
                              value: month,
                              child: Text(month),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Driver',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDriver,
                  items:
                      _drivers
                          .map(
                            (driver) => DropdownMenuItem(
                              value: driver,
                              child: Text(driver),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDriver = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        height: 120,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> _pages = [
    // Replace the dashboard overview with the new widget
    // The widget will be called via _buildDashboardOverview in build method
    // So here we put a placeholder Container, will update build method accordingly
    Container(),
    // Removed AddDriver and ViewDrivers from embedded pages
    // AddDriver(),
    // ViewDrivers(),
    Center(child: Text('All Trips')),
    Center(child: Text('Monthly Report')),
    Center(child: Text('Daily Report')),
    Profile(),
    Center(child: Text('Change Password')),
    Center(child: Text('Logout')),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Hanvic Logistics Admin'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        backgroundColor: Color(0xFF001F3F), // blue from logo
        foregroundColor: Colors.white, // white text color
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Admin Dashboard",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(color: Color(0xFF001F3F)),
            ),

            ExpansionTile(
              title: Text("Dashboard"),
              leading: Icon(Icons.dashboard),
              children: [
                ListTile(
                  title: Text("Overview"),
                  onTap: () => _onItemSelected(0),
                ),
              ],
            ),

            ExpansionTile(
              title: Text("Driver Management"),
              leading: Icon(Icons.person),
              children: [
                ListTile(
                  title: Text("Add Driver"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddDriver()),
                    );
                  },
                ),
                ListTile(
                  title: Text("View Drivers"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewDrivers()),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              title: Text("Trip Logs"),
              leading: Icon(Icons.map),
              children: [
                ListTile(
                  title: Text("All Trips"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => AllTrips(loggedInDriver: 'Driver 1'),
                      ),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              title: Text("Sales Documentation"),
              leading: Icon(Icons.description),
              children: [
                ListTile(
                  title: Text("Receipts"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ReceiptsPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text("Quotations"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QuotationsPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text("Invoice"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InvoicePage()),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              title: Text("Reports"),
              leading: Icon(Icons.pie_chart),
              children: [
                ListTile(
                  title: Text("Monthly Report"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MonthlyReport()),
                    );
                  },
                ),
                ListTile(
                  title: Text("Daily Report"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DailyReport()),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              children: [
                ListTile(
                  title: Text("Admin Profile"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Profile()));
                  },
                ),
                ListTile(
                  title: Text("Change Password"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                ),
              ],
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                  arguments: 'admin',
                );
              },
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child:
            _selectedIndex == 0
                ? _buildDashboardOverview()
                : _pages[_selectedIndex],
      ),
    );
  }
}
