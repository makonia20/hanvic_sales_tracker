// ignore_for_file: unused_import, unused_element

import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ViewAllTrips extends StatefulWidget {
  @override
  _ViewAllTripsState createState() => _ViewAllTripsState();
}

class _ViewAllTripsState extends State<ViewAllTrips> {
  final TripDataStore _tripDataStore = TripDataStore();

  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final daysCount = nextMonth.difference(firstDay).inDays;
    return List.generate(
      daysCount,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  void _exportPdf(List<TripData> trips) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Header(level: 0, child: pw.Text('Monthly Trips Report')),
              pw.Paragraph(text: 'Month: ${_selectedMonth}'),
              pw.Table.fromTextArray(
                headers: [
                  'Trip Detail',
                  'From',
                  'To',
                  'Diesel',
                  'Tollgate',
                  'Vid',
                  'Food',
                  'Police',
                  'Trip Amount',
                ],
                data:
                    trips.map((trip) {
                      return [
                        trip.tripDetail ?? '',
                        trip.tripFrom ?? '',
                        trip.tripTo ?? '',
                        trip.dieselAmount.toStringAsFixed(2),
                        trip.tollgateAmount.toStringAsFixed(2),
                        trip.vidAmount.toStringAsFixed(2),
                        trip.foodAmount.toStringAsFixed(2),
                        trip.policeAmount.toStringAsFixed(2),
                        trip.tripAmount.toStringAsFixed(2),
                      ];
                    }).toList(),
              ),
            ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/monthly_trips_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Sharing functionality removed as per request
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_currentMonth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
        title: Text('All Trips - ${DateFormat.yMMMM().format(_currentMonth)}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Column(
              children:
                  days.map((day) {
                    final dateStr = DateFormat('yyyy-MM-dd').format(day);
                    final trips =
                        _tripDataStore
                            .getTripsForDate(dateStr)
                            .cast<TripData>();
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d').format(day),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ...trips.isNotEmpty
                              ? trips.map(
                                (trip) => SizedBox(
                                  height: 100,
                                  child: Card(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: TripTableReadOnly(tripData: trip),
                                    ),
                                  ),
                                ),
                              )
                              : [Text('No trips')],
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _selectedMonth {}

class TripTableReadOnly extends StatelessWidget {
  final TripData tripData;

  const TripTableReadOnly({Key? key, required this.tripData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalColumn2 =
        tripData.dieselAmount +
        tripData.tollgateAmount +
        tripData.vidAmount +
        tripData.foodAmount +
        tripData.policeAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tripData.tripDetail ?? 'Trip',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Details Trip',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'From: ${tripData.tripFrom ?? ''}\nTo: ${tripData.tripTo ?? ''}',
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
              ],
            ),
            _buildAmountRow('Diesel', tripData.dieselAmount),
            _buildAmountRow('Tollgate', tripData.tollgateAmount),
            _buildAmountRow('Vid', tripData.vidAmount),
            _buildAmountRow('Food', tripData.foodAmount),
            _buildAmountRow('Police', tripData.policeAmount),
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Trip Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$${tripData.tripAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Total Column 2',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$${totalColumn2.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$${tripData.tripAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Total After Subtracting',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$${(tripData.tripAmount - totalColumn2).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  TableRow _buildAmountRow(String label, double amount) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text(label)),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('\$${amount.toStringAsFixed(2)}'),
        ),
        Padding(padding: EdgeInsets.all(8), child: Text('\$')),
        Padding(padding: EdgeInsets.all(8), child: Text('')),
      ],
    );
  }
}
