import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/new_trip_entry.dart';

class SummaryOfTotals extends StatefulWidget {
  @override
  _SummaryOfTotalsState createState() => _SummaryOfTotalsState();
}

class _SummaryOfTotalsState extends State<SummaryOfTotals> {
  int _totalTrips = 0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    final tripStore = TripDataStore();
    List<String> allDates = tripStore.getAllDates();

    int totalTrips = 0;
    double totalAmount = 0.0;

    for (String dateStr in allDates) {
      List<TripData> trips = tripStore.getTripsForDate(dateStr);
      totalTrips += trips.length;
      for (var trip in trips) {
        totalAmount += trip.tripAmount;
      }
    }

    setState(() {
      _totalTrips = totalTrips;
      _totalAmount = totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary of Totals'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Total Trips'),
                trailing: Text('$_totalTrips'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Total Amount'),
                trailing: Text('\$${_totalAmount.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
