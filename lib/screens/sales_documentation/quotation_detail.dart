import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart';

class QuotationDetailPage extends StatelessWidget {
  final Receipt quotation;

  const QuotationDetailPage({Key? key, required this.quotation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: Text('Quotation Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quotation Number: ${quotation.receiptNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Customer Name: ${quotation.customerName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${dateFormat.format(quotation.date)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
