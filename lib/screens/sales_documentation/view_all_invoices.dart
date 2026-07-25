import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart' as model;
import 'invoice_detail.dart' as invoice_detail;
import '../../models/sales_data_store.dart';

class ViewAllInvoicesPage extends StatefulWidget {
  @override
  _ViewAllInvoicesPageState createState() => _ViewAllInvoicesPageState();
}

class _ViewAllInvoicesPageState extends State<ViewAllInvoicesPage> {
  final SalesDataStore _dataStore = SalesDataStore();

  String nameFilter = '';
  DateTime? dateFilter;

  List get filteredInvoices {
    return _dataStore.invoices.where((invoice) {
      final matchesName = invoice.customerName.toLowerCase().contains(
        nameFilter.toLowerCase(),
      );
      final matchesDate =
          dateFilter == null ||
          (invoice.date.year == dateFilter!.year &&
              invoice.date.month == dateFilter!.month &&
              invoice.date.day == dateFilter!.day);
      return matchesName && matchesDate;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateFilter ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateFilter = picked;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      dateFilter = null;
    });
  }

  void _navigateToDetail(model.Receipt invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => invoice_detail.InvoiceDetailPage(invoice: invoice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: Text('All Invoices')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Filter by Customer Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        nameFilter = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    dateFilter == null
                        ? 'Filter by Date'
                        : dateFormat.format(dateFilter!),
                  ),
                ),
                if (dateFilter != null)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearDateFilter,
                    tooltip: 'Clear Date Filter',
                  ),
              ],
            ),
            SizedBox(height: 16),
            // List
            Expanded(
              child:
                  filteredInvoices.isEmpty
                      ? Center(child: Text('No invoices found.'))
                      : ListView.builder(
                        itemCount: filteredInvoices.length,
                        itemBuilder: (context, index) {
                          final invoice = filteredInvoices[index];
                          return ListTile(
                            title: Text(invoice.receiptNumber),
                            subtitle: Text(
                              '${invoice.customerName} - ${dateFormat.format(invoice.date)}',
                            ),
                            onTap: () => _navigateToDetail(invoice),
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
