import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/new_trip_entry.dart';
import 'package:hanvic_sales_tracker/screens/driver_dashboard/trips_today.dart';
import 'package:hanvic_sales_tracker/screens/driver_dashboard/sales_today.dart';
import 'package:hanvic_sales_tracker/screens/driver_dashboard/monthly_progress.dart';
import 'package:hanvic_sales_tracker/screens/trip_logs/all_trips.dart';
import 'package:hanvic_sales_tracker/screens/driver_dashboard/filter_by_date.dart';
import 'package:hanvic_sales_tracker/screens/driver_dashboard/summary_of_totals.dart';
import 'package:hanvic_sales_tracker/screens/settings/profile.dart';

class DriverDashboard extends StatefulWidget {
  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
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
                _buildStatCard('Trips Today', '80', Colors.blue),
                SizedBox(height: 16),
                _buildStatCard('Sales Today', '\$3,200', Colors.green),
                SizedBox(height: 16),
                _buildStatCard('Monthly Progress', '75%', Colors.orange),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF001F3F), // blue from logo
        foregroundColor: Colors.white,
        title: Text("Driver Dashboard"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: _buildDashboardOverview(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF001F3F)),
            child: Text(
              'Hanvic Logistics',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ExpansionTile(
            title: Text("Dashboard Overview"),
            children: [
              ListTile(
                title: Text("Trips Today"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => TripsToday()));
                },
              ),
              ListTile(
                title: Text("Sales Today"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => SalesToday()));
                },
              ),
              ListTile(
                title: Text("Monthly Progress"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MonthlyProgress()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Add Trip"),
            children: [
              ListTile(
                title: Text("New Trip Entry"),
                onTap: () {
                  Navigator.of(context).pop(); // close the drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NewTripEntry()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("My Trips"),
            children: [
              ListTile(
                title: Text("View All Trips"),
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
              ListTile(
                title: Text("Filter by Date"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FilterByDate()),
                  );
                },
              ),
              ListTile(
                title: Text("Summary of Totals"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SummaryOfTotals()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Profile"),
            children: [
              ListTile(
                title: Text("View Details"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              ListTile(title: Text("Change Password"), onTap: () {}),
            ],
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/login',
                arguments: 'driver',
              );
            },
          ),
        ],
      ),
    );
  }
}
