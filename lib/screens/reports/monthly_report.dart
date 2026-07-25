import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({Key? key}) : super(key: key);

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late List<TripData> _tripsForMonth;

  @override
  void initState() {
    super.initState();
    _addDummyData();
    _loadTripsForMonth(_selectedMonth);
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

  void _loadTripsForMonth(DateTime month) {
    final tripStore = TripDataStore();
    final allDates = tripStore.getAllDates();
    _tripsForMonth = [];

    for (var dateStr in allDates) {
      DateTime date = DateTime.parse(dateStr);
      if (date.year == month.year && date.month == month.month) {
        _tripsForMonth.addAll(tripStore.getTripsForDate(dateStr));
      }
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        (picked.year != _selectedMonth.year ||
            picked.month != _selectedMonth.month)) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _loadTripsForMonth(_selectedMonth);
      });
    }
  }

  double get totalTripAmount =>
      _tripsForMonth.fold(0, (sum, trip) => sum + trip.tripAmount);

  double get totalExpenses =>
      _tripsForMonth.fold(0, (sum, trip) => sum + trip.totalColumn2);

  double get totalNet =>
      _tripsForMonth.fold(0, (sum, trip) => sum + trip.totalAfterSubtracting);

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
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
    final formattedMonth = DateFormat('yyyy-MM').format(_selectedMonth);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
        title: const Text('Monthly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectMonth(context),
            tooltip: 'Select Month',
          ),
        ],
      ),
      body:
          _tripsForMonth.isEmpty
              ? Center(child: Text('No trips found for $formattedMonth'))
              : Column(
                children: [
                  _buildSummaryCard(
                    'Total Trip Amount',
                    totalTripAmount,
                    Colors.blue,
                  ),
                  _buildSummaryCard(
                    'Total Expenses',
                    totalExpenses,
                    Colors.red,
                  ),
                  _buildSummaryCard('Total Net', totalNet, Colors.green),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tripsForMonth.length,
                      itemBuilder: (context, index) {
                        return _buildTripCard(_tripsForMonth[index]);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

// Helper widget for month picker dialog
Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  DateTime? selectedDate;
  await showDialog(
    context: context,
    builder: (context) {
      int selectedYear = initialDate.year;
      int selectedMonth = initialDate.month;

      return AlertDialog(
        title: const Text('Select Month'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              DropdownButton<int>(
                value: selectedYear,
                items:
                    List.generate(
                      lastDate.year - firstDate.year + 1,
                      (index) => firstDate.year + index,
                    ).map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedYear = value;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
              DropdownButton<int>(
                value: selectedMonth,
                items:
                    List.generate(12, (index) => index + 1).map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(
                          DateFormat.MMMM().format(DateTime(0, month)),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedMonth = value;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              selectedDate = DateTime(selectedYear, selectedMonth);
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  return selectedDate;
}
