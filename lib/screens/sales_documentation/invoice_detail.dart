import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart';

class InvoiceDetailPage extends StatelessWidget {
  final Receipt invoice;

  const InvoiceDetailPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice Number: \${invoice.receiptNumber}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Customer Name: \${invoice.customerName}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Date: \${dateFormat.format(invoice.date)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Items:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FlexColumnWidth(4),
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
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...invoice.items.map((item) {
                    final total = item.quantity * item.price;
                    return TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(item.description),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(item.quantity.toString()),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('\$${item.price.toStringAsFixed(2)}'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('\$${total.toStringAsFixed(2)}'),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
