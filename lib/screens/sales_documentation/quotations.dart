// ignore_for_file: unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/receipt.dart' as receipt_model;
import 'package:hanvic_sales_tracker/models/sales_data_store.dart';
import 'package:intl/intl.dart';

class QuotationsPage extends StatefulWidget {
  @override
  _QuotationsPageState createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  late String quotationNumber;
  String customerName = "";

  late DateTime date;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final DateFormat numberFormat = DateFormat('yyyyMMddHHmmss');

  List<QuotationItem> items = List.generate(
    10,
    (index) => QuotationItem(description: '', quantity: 0, price: 0.0),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    quotationNumber = "QTN-" + numberFormat.format(date);
  }

  double get total {
    return items.fold(0, (sum, item) => sum + item.quantity * item.price);
  }

  void _saveAsPDF() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Save as PDF clicked')));
  }

  void _printQuotation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Print clicked')));
  }

  void _shareQuotation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share clicked')));
  }

  void _createAnother() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Create Another clicked')));
  }

  void _updateQuantity(int index, String value) {
    final qty = int.tryParse(value) ?? 0;
    setState(() {
      items[index].quantity = qty;
    });
  }

  void _updatePrice(int index, String value) {
    final price = double.tryParse(value) ?? 0.0;
    setState(() {
      items[index].price = price;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quotations')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Color(0xFF0D47A1),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo and title
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Sales Quotation',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.view_list, color: Colors.white),
                          tooltip: 'View All Quotations',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/view_all_quotations',
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Quotation info
                    Text(
                      "Quotation Number: $quotationNumber",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Date: ', style: TextStyle(fontSize: 18)),
                        Text(
                          dateFormat.format(date),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Customer name input
                    TextFormField(
                      initialValue: customerName,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter customer name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          customerName = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // Items table header
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(),

              // Items list with editable quantity and price
              ...items.asMap().entries.map((entry) {
                int index = entry.key;
                QuotationItem item = entry.value;
                return Padding(
                  SizedBox(height: 8),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          initialValue: item.description,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              items[index].description = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: item.quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                          ),
                          onChanged: (value) => _updateQuantity(index, value),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: item.price.toStringAsFixed(2),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                          ),
                          onChanged: (value) => _updatePrice(index, value),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\$${(item.quantity * item.price).toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    items.add(
                      QuotationItem(description: "", quantity: 0, price: 0.0),
                    );
                  });
                },
                icon: Icon(Icons.add),
                label: Text('Add Item'),
              ),

              Divider(),
              // Total
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 24),
              // Thank you message
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Thank you, if you have any questions email us on support@example.com or call us on +1234567890 to get full information.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24),
              // Buttons arranged in 1 row with 2 buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final newQuotation = receipt_model.Receipt(
                          receiptNumber: quotationNumber,
                          customerName: customerName,
                          date: date,
                          items:
                              items
                                  .map(
                                    (item) => receipt_model.Item(
                                      description: item.description,
                                      quantity: item.quantity,
                                      price: item.price,
                                    ),
                                  )
                                  .toList(),
                        );
                        SalesDataStore().addQuotation(newQuotation);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quotation saved successfully'),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.save, size: 20),
                    label: Text('Save', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      minimumSize: Size(140, 48),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _printQuotation,
                    icon: Icon(Icons.print, size: 20),
                    label: Text('Print', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      minimumSize: Size(140, 48),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuotationItem {
  String description;
  int quantity;
  double price;

  QuotationItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}
