import 'driver.dart';

class DriverDataStore {
  static final DriverDataStore _instance = DriverDataStore._internal();

  factory DriverDataStore() {
    return _instance;
  }

  DriverDataStore._internal();

  final List<Driver> _drivers = [];

  List<Driver> getAllDrivers() {
    return List.unmodifiable(_drivers);
  }

  void addDriver(Driver driver) {
    _drivers.add(driver);
  }

  Driver? getDriverByPhoneNumber(String phoneNumber) {
    try {
      return _drivers.firstWhere((d) => d.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }
}
