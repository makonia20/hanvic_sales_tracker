import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/new_trip_entry.dart';
import 'package:intl/intl.dart';

class FilterByDate extends StatefulWidget {
  @override
  _FilterByDateState createState() => _FilterByDateState();
}

class _FilterByDateState extends State<FilterByDate> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _filteredTrips = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  void _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _pickEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyFilter() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End date cannot be before start date')),
      );
      return;
    }

    final tripStore = TripDataStore();
    List<String> allDates = tripStore.getAllDates();

    List<Map<String, dynamic>> filtered = [];

    for (String dateStr in allDates) {
      DateTime date = DateTime.parse(dateStr);
      if ((date.isAtSameMomentAs(_startDate!) || date.isAfter(_startDate!)) &&
          (date.isAtSameMomentAs(_endDate!) || date.isBefore(_endDate!))) {
        List<TripData> trips = tripStore.getTripsForDate(dateStr);
        for (var trip in trips) {
          filtered.add({'date': date, 'trip': trip});
        }
      }
    }

    setState(() {
      _filteredTrips = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter by Date'),
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartDate,
                    child: Text(
                      _startDate == null
                          ? 'Select Start Date'
                          : 'Start: ${_dateFormat.format(_startDate!)}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndDate,
                    child: Text(
                      _endDate == null
                          ? 'Select End Date'
                          : 'End: ${_dateFormat.format(_endDate!)}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _applyFilter,
              child: Text('Apply Filter'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child:
                  _filteredTrips.isEmpty
                      ? Center(
                        child: Text('No trips found for selected date range'),
                      )
                      : ListView.builder(
                        itemCount: _filteredTrips.length,
                        itemBuilder: (context, index) {
                          final item = _filteredTrips[index];
                          final trip = item['trip'] as TripData;
                          final date = item['date'] as DateTime;
                          return ListTile(
                            title: Text(trip.tripDetail ?? 'Trip'),
                            subtitle: Text(_dateFormat.format(date)),
                            trailing: Text(
                              '\$${trip.tripAmount.toStringAsFixed(2)}',
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
