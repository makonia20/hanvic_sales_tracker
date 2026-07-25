import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/driver_data_store.dart';
import 'package:hanvic_sales_tracker/models/driver.dart';

class ViewDrivers extends StatefulWidget {
  const ViewDrivers({Key? key}) : super(key: key);

  @override
  _ViewDriversState createState() => _ViewDriversState();
}

class _ViewDriversState extends State<ViewDrivers> {
  final DriverDataStore _driverDataStore = DriverDataStore();

  @override
  void initState() {
    super.initState();
    _addDummyDriversIfEmpty();
  }

  void _addDummyDriversIfEmpty() {
    if (_driverDataStore.getAllDrivers().isEmpty) {
      _driverDataStore.addDriver(
        Driver(
          fullName: 'John Doe',
          idNumber: 'ID123456',
          phoneNumber: '123-456-7890',
          imagePath: null,
          password: 'password1',
          vehicleType: 'Tipper',
        ),
      );
      _driverDataStore.addDriver(
        Driver(
          fullName: 'Jane Smith',
          idNumber: 'ID654321',
          phoneNumber: '098-765-4321',
          imagePath: null,
          password: 'password2',
          vehicleType: 'Grabber',
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final drivers = _driverDataStore.getAllDrivers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Drivers'),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body:
          drivers.isEmpty
              ? Center(child: Text('No drivers added yet.'))
              : ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  return ListTile(
                    leading:
                        driver.imagePath != null
                            ? CircleAvatar(
                              backgroundImage: AssetImage(driver.imagePath!),
                            )
                            : CircleAvatar(child: Icon(Icons.person)),
                    title: Text(driver.fullName),
                    subtitle: Text(
                      'Phone: ${driver.phoneNumber}\nVehicle: ${driver.vehicleType}',
                    ),
                    isThreeLine: true,
                  );
                },
              ),
    );
  }
}
