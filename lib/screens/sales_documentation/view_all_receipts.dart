import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart' as model;
import 'receipt_detail.dart' as receipt_detail;
import '../../models/sales_data_store.dart';

class ViewAllReceiptsPage extends StatefulWidget {
  @override
  _ViewAllReceiptsPageState createState() => _ViewAllReceiptsPageState();
}

class _ViewAllReceiptsPageState extends State<ViewAllReceiptsPage> {
  final SalesDataStore _dataStore = SalesDataStore();

  String nameFilter = '';
  DateTime? dateFilter;

  List get filteredReceipts {
    return _dataStore.receipts.where((receipt) {
      final matchesName = receipt.customerName.toLowerCase().contains(
        nameFilter.toLowerCase(),
      );
      final matchesDate =
          dateFilter == null ||
          (receipt.date.year == dateFilter!.year &&
              receipt.date.month == dateFilter!.month &&
              receipt.date.day == dateFilter!.day);
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

  void _navigateToDetail(model.Receipt receipt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => receipt_detail.ReceiptDetailPage(receipt: receipt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: Text('All Receipts')),
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
                  filteredReceipts.isEmpty
                      ? Center(child: Text('No receipts found.'))
                      : ListView.builder(
                        itemCount: filteredReceipts.length,
                        itemBuilder: (context, index) {
                          final receipt = filteredReceipts[index];
                          return ListTile(
                            title: Text(receipt.receiptNumber),
                            subtitle: Text(
                              '${receipt.customerName} - ${dateFormat.format(receipt.date)}',
                            ),
                            onTap: () => _navigateToDetail(receipt),
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
