import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  _DailyReportState createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  DateTime _selectedDate = DateTime.now();
  late List<TripData> _tripsForDate;

  @override
  void initState() {
    super.initState();
    _addDummyData();
    _loadTripsForDate(_selectedDate);
  }

  void _addDummyData() {
    TripDataStore().addTripsForDate('2024-06-05', [
      TripData(
        tripDetail: 'Driver X - Trip Y',
        tripFrom: 'City X',
        tripTo: 'City Y',
        dieselAmount: 20,
        tollgateAmount: 5,
        vidAmount: 1,
        foodAmount: 10,
        policeAmount: 0,
        tripAmount: 100,
      ),
    ]);
  }

  void _loadTripsForDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    _tripsForDate = TripDataStore().getTripsForDate(dateString);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadTripsForDate(_selectedDate);
      });
    }
  }

  Widget _buildTripCard(TripData trip) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(trip.tripDetail ?? 'No Detail'),
        subtitle: Text('${trip.tripFrom ?? ''} → ${trip.tripTo ?? ''}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Trip Amount: \$${trip.tripAmount.toStringAsFixed(2)}'),
            Text('Expenses: \$${trip.totalColumn2.toStringAsFixed(2)}'),
            Text('Net: \$${trip.totalAfterSubtracting.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
        title: const Text('Daily Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
            tooltip: 'Select Date',
          ),
        ],
      ),
      body:
          _tripsForDate.isEmpty
              ? Center(child: Text('No trips found for $formattedDate'))
              : ListView.builder(
                itemCount: _tripsForDate.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(_tripsForDate[index]);
                },
              ),
    );
  }
}
