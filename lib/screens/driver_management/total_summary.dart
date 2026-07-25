import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';

class TotalSummary extends StatelessWidget {
  final List<TripData> trips;

  TotalSummary({required this.trips});

  @override
  Widget build(BuildContext context) {
    double totalColumn2 = 0;
    double totalTripAmount = 0;
    double totalAfterSubtracting = 0;

    for (var trip in trips) {
      totalColumn2 += trip.totalColumn2;
      totalTripAmount += trip.tripAmount;
      totalAfterSubtracting += trip.totalAfterSubtracting;
    }

    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[400]),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Total for All Trips',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '\$' + totalColumn2.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '\$' + totalTripAmount.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '\$' + totalAfterSubtracting.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
