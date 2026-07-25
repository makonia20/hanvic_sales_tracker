import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart' as model;
import 'quotation_detail.dart' as quotation_detail;

import '../../models/sales_data_store.dart';

class ViewAllQuotationsPage extends StatefulWidget {
  @override
  _ViewAllQuotationsPageState createState() => _ViewAllQuotationsPageState();
}

class _ViewAllQuotationsPageState extends State<ViewAllQuotationsPage> {
  final SalesDataStore _dataStore = SalesDataStore();

  String nameFilter = '';
  DateTime? dateFilter;

  List get filteredQuotations {
    return _dataStore.quotations.where((quotation) {
      final matchesName = quotation.customerName.toLowerCase().contains(
        nameFilter.toLowerCase(),
      );
      final matchesDate =
          dateFilter == null ||
          (quotation.date.year == dateFilter!.year &&
              quotation.date.month == dateFilter!.month &&
              quotation.date.day == dateFilter!.day);
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

  void _navigateToDetail(model.Receipt quotation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                quotation_detail.QuotationDetailPage(quotation: quotation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: Text('All Quotations')),
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
                  filteredQuotations.isEmpty
                      ? Center(child: Text('No quotations found.'))
                      : ListView.builder(
                        itemCount: filteredQuotations.length,
                        itemBuilder: (context, index) {
                          final quotation = filteredQuotations[index];
                          return ListTile(
                            title: Text(quotation.receiptNumber),
                            subtitle: Text(
                              '${quotation.customerName} - ${dateFormat.format(quotation.date)}',
                            ),
                            onTap: () => _navigateToDetail(quotation),
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
