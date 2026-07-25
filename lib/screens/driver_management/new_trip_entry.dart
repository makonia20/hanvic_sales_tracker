// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/trip_data.dart';
import 'package:hanvic_sales_tracker/screens/driver_management/total_summary.dart';
import 'package:intl/intl.dart';
import 'package:hanvic_sales_tracker/models/trip_data_store.dart';

class NewTripEntry extends StatefulWidget {
  @override
  _NewTripEntryState createState() => _NewTripEntryState();
}

class _NewTripEntryState extends State<NewTripEntry> {
  List<TripData> trips = [TripData()];

  void addTrip() {
    setState(() {
      trips.add(TripData());
    });
  }

  void saveTrips() {
    // Save trips to TripDataStore with current date
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TripDataStore().addTripsForDate(currentDate, trips.cast<TripData>());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Trips saved successfully!')));
  }

  void editTrip(int index) {
    // Implement edit logic if needed
    // Currently, the form is editable by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Trip Entry'),
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...trips.asMap().entries.map((entry) {
              int index = entry.key;
              TripData trip = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TripTable(
                  tripData: trip,
                  onChanged: (updatedTrip) {
                    setState(() {
                      trips[index] = updatedTrip;
                    });
                  },
                  tripNumber: index + 1,
                ),
              );
            }).toList(),
            Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TotalSummary(trips: trips),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: addTrip,
                  icon: Icon(Icons.add),
                  label: Text('Add Another Trip'),
                ),
                ElevatedButton.icon(
                  onPressed: saveTrips,
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TripTable extends StatefulWidget {
  final TripData tripData;
  final ValueChanged<TripData> onChanged;
  final int tripNumber;

  TripTable({
    required this.tripData,
    required this.onChanged,
    required this.tripNumber,
  });

  @override
  _TripTableState createState() => _TripTableState();
}

class _TripTableState extends State<TripTable> {
  late TextEditingController dieselController;
  late TextEditingController tollgateController;
  late TextEditingController vidController;
  late TextEditingController foodController;
  late TextEditingController policeController;
  late TextEditingController tripAmountController;
  late TextEditingController tripFromController;
  late TextEditingController tripToController;
  String? selectedTripDetail;

  final List<String> tripOptions = ['Trip A', 'Trip B', 'Trip C', 'Trip D'];

  @override
  void initState() {
    super.initState();
    dieselController = TextEditingController(
      text: widget.tripData.dieselAmount.toString(),
    );
    tollgateController = TextEditingController(
      text: widget.tripData.tollgateAmount.toString(),
    );
    vidController = TextEditingController(
      text: widget.tripData.vidAmount.toString(),
    );
    foodController = TextEditingController(
      text: widget.tripData.foodAmount.toString(),
    );
    policeController = TextEditingController(
      text: widget.tripData.policeAmount.toString(),
    );
    tripAmountController = TextEditingController(
      text: widget.tripData.tripAmount.toString(),
    );
    tripFromController = TextEditingController(
      text: widget.tripData.tripFrom ?? '',
    );
    tripToController = TextEditingController(
      text: widget.tripData.tripTo ?? '',
    );
    selectedTripDetail = widget.tripData.tripDetail;
  }

  @override
  void dispose() {
    dieselController.dispose();
    tollgateController.dispose();
    vidController.dispose();
    foodController.dispose();
    policeController.dispose();
    tripAmountController.dispose();
    tripFromController.dispose();
    tripToController.dispose();
    super.dispose();
  }

  void updateTripData() {
    double parseAmount(String value) {
      return double.tryParse(value) ?? 0;
    }

    widget.onChanged(
      TripData(
        tripDetail: selectedTripDetail,
        tripFrom: tripFromController.text,
        tripTo: tripToController.text,
        dieselAmount: parseAmount(dieselController.text),
        tollgateAmount: parseAmount(tollgateController.text),
        vidAmount: parseAmount(vidController.text),
        foodAmount: parseAmount(foodController.text),
        policeAmount: parseAmount(policeController.text),
        tripAmount: parseAmount(tripAmountController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalColumn2 =
        (double.tryParse(dieselController.text) ?? 0) +
        (double.tryParse(tollgateController.text) ?? 0) +
        (double.tryParse(vidController.text) ?? 0) +
        (double.tryParse(foodController.text) ?? 0) +
        (double.tryParse(policeController.text) ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip \${widget.tripNumber}',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Trip Detail'),
                        value: selectedTripDetail,
                        items:
                            tripOptions
                                .map(
                                  (trip) => DropdownMenuItem(
                                    value: trip,
                                    child: Text(trip),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTripDetail = value;
                            updateTripData();
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: tripFromController,
                              decoration: InputDecoration(labelText: 'From'),
                              onChanged: (value) => updateTripData(),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: tripToController,
                              decoration: InputDecoration(labelText: 'To'),
                              onChanged: (value) => updateTripData(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
                Padding(padding: EdgeInsets.all(8), child: Text('')),
              ],
            ),
            buildAmountRow('Diesel', dieselController, updateTripData),
            buildAmountRow('Tollgate', tollgateController, updateTripData),
            buildAmountRow('Vid', vidController, updateTripData),
            buildAmountRow('Food', foodController, updateTripData),
            buildAmountRow('Police', policeController, updateTripData),
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
                  child: TextFormField(
                    controller: tripAmountController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) => setState(() {}),
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
                    '\$' + totalColumn2.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '\$' +
                        (double.tryParse(tripAmountController.text) ?? 0)
                            .toStringAsFixed(2),
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
                    '\$' +
                        ((double.tryParse(tripAmountController.text) ?? 0) -
                                totalColumn2)
                            .toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TableRow buildAmountRow(
    String label,
    TextEditingController controller,
    VoidCallback onChanged,
  ) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text(label)),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) {
              setState(() {
                onChanged();
              });
            },
          ),
        ),
        Padding(padding: EdgeInsets.all(8), child: Text('\$')),
        Padding(padding: EdgeInsets.all(8), child: Text('')),
      ],
    );
  }
}
