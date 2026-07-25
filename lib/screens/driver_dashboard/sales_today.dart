import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/new_trip_entry.dart';

class SalesToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Today'),
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'New Trip Entry',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => NewTripEntry()));
            },
          ),
        ],
      ),
      body: Center(child: Text('Sales Today Page')),
    );
  }
}
