// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/receipt.dart';
import '../../models/sales_data_store.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late String invoiceNumber;
  String customerName = "";

  // Payment related state
  String paymentMethod = 'All'; // Default payment method
  String cashType = 'Cash on Delivery'; // For cash payment popup
  int cashDays = 0; // Days for cash after some days
  String bankDetails = '';
  String ecocashNumber = '';
  String ecocashName = '';

  late DateTime date;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final DateFormat numberFormat = DateFormat('yyyyMMddHHmmss');

  List<Item> items = List.generate(
    10,
    (index) => Item(description: "", quantity: 0, price: 0.0),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    invoiceNumber = "INV-" + numberFormat.format(date);
  }

  double get total {
    return items.fold(0, (sum, item) => sum + item.quantity * item.price);
  }

  void _saveAsPDF() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Save as PDF clicked')));
  }

  void _editInvoice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit clicked')));
  }

  void _printInvoice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Print clicked')));
  }

  void _shareInvoice() {
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
      items[index] = Item(
        description: items[index].description,
        quantity: qty,
        price: items[index].price,
      );
    });
  }

  void _updatePrice(int index, String value) {
    final price = double.tryParse(value) ?? 0.0;
    setState(() {
      items[index] = Item(
        description: items[index].description,
        quantity: items[index].quantity,
        price: price,
      );
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

  Future<void> _showCashOptionsDialog() async {
    String tempCashType = cashType;
    int tempCashDays = cashDays;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cash Payment Options'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('Cash on Delivery'),
                    value: 'Cash on Delivery',
                    groupValue: tempCashType,
                    onChanged: (value) {
                      setState(() {
                        tempCashType = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('After some days'),
                    value: 'After some days',
                    groupValue: tempCashType,
                    onChanged: (value) {
                      setState(() {
                        tempCashType = value!;
                      });
                    },
                  ),
                  if (tempCashType == 'After some days')
                    TextFormField(
                      initialValue:
                          tempCashDays > 0 ? tempCashDays.toString() : '',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter number of days',
                      ),
                      onChanged: (value) {
                        tempCashDays = int.tryParse(value) ?? 0;
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  cashType = tempCashType;
                  cashDays = tempCashDays;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBankDetailsDialog() async {
    String tempBankDetails = bankDetails;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bank Payment Details'),
          content: TextFormField(
            initialValue: tempBankDetails,
            decoration: InputDecoration(labelText: 'Enter banking details'),
            onChanged: (value) {
              tempBankDetails = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  bankDetails = tempBankDetails;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEcocashDetailsDialog() async {
    String tempEcocashNumber = ecocashNumber;
    String tempEcocashName = ecocashName;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ecocash Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: tempEcocashNumber,
                decoration: InputDecoration(labelText: 'Ecocash Number'),
                onChanged: (value) {
                  tempEcocashNumber = value;
                },
              ),
              TextFormField(
                initialValue: tempEcocashName,
                decoration: InputDecoration(labelText: 'Ecocash Name'),
                onChanged: (value) {
                  tempEcocashName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  ecocashNumber = tempEcocashNumber;
                  ecocashName = tempEcocashName;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onPaymentMethodChanged(String? value) {
    if (value == null) return;
    setState(() {
      paymentMethod = value;
    });
    if (value == 'Cash') {
      _showCashOptionsDialog();
    } else if (value == 'Bank') {
      _showBankDetailsDialog();
    } else if (value == 'Ecocash') {
      _showEcocashDetailsDialog();
    } else if (value == 'All') {
      _showCashOptionsDialog();
      _showBankDetailsDialog();
      _showEcocashDetailsDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice')),
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
                              'Sales Invoice',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.view_list, color: Colors.white),
                          tooltip: 'View All Invoices',
                          onPressed: () {
                            Navigator.pushNamed(context, '/view_all_invoices');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Invoice info
                    Text(
                      'Invoice Number: $invoiceNumber',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Date: ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          dateFormat.format(date),
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
                Item item = entry.value;
                return Padding(
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
                              items[index] = Item(
                                description: value,
                                quantity: items[index].quantity,
                                price: items[index].price,
                              );
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
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    items.add(Item(description: "", quantity: 0, price: 0.0));
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
              // Payment method dropdown at bottom
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: paymentMethod,
                      decoration: InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['All', 'Cash', 'Bank', 'Ecocash']
                              .map(
                                (method) => DropdownMenuItem<String>(
                                  value: method,
                                  child: Text(method),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          paymentMethod = value;
                        });
                        if (value == 'Cash') {
                          _showCashOptionsDialog();
                        } else if (value == 'Bank') {
                          _showBankDetailsDialog();
                        } else if (value == 'Ecocash') {
                          _showEcocashDetailsDialog();
                        } else if (value == 'All') {
                          _showCashOptionsDialog();
                          _showBankDetailsDialog();
                          _showEcocashDetailsDialog();
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    // Display selected payment details
                    if (paymentMethod == 'Cash' || paymentMethod == 'All') ...[
                      Text(
                        'Cash Payment: $cashType' +
                            (cashType == 'After some days'
                                ? ', Days: $cashDays'
                                : ''),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                    ],
                    if (paymentMethod == 'Bank' || paymentMethod == 'All') ...[
                      Text(
                        'Bank Details: $bankDetails',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                    ],
                    if (paymentMethod == 'Ecocash' ||
                        paymentMethod == 'All') ...[
                      Text(
                        'Ecocash Number: $ecocashNumber',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ecocash Name: $ecocashName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                    ],
                  ],
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
              // Buttons arranged in 2 rows of 2 buttons each
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final newInvoice = Receipt(
                          receiptNumber: invoiceNumber,
                          customerName: customerName,
                          date: date,
                          items:
                              items
                                  .map(
                                    (item) => Item(
                                      description: item.description,
                                      quantity: item.quantity,
                                      price: item.price,
                                    ),
                                  )
                                  .toList(),
                        );
                        SalesDataStore().addInvoice(newInvoice);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invoice saved successfully')),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
