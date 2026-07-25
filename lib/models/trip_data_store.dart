import 'package:hanvic_sales_tracker/models/trip_data.dart';

class TripDataStore {
  static final TripDataStore _instance = TripDataStore._internal();

  factory TripDataStore() {
    return _instance;
  }

  TripDataStore._internal() {
    _addDummyData();
  }

  // Map of date string (yyyy-MM-dd) to list of trips
  final Map<String, List<TripData>> _tripsByDate = {};

  void addTripsForDate(String date, List<TripData> trips) {
    if (_tripsByDate.containsKey(date)) {
      _tripsByDate[date]!.addAll(trips);
    } else {
      _tripsByDate[date] = List.from(trips);
    }
  }

  List<TripData> getTripsForDate(String date) {
    return _tripsByDate[date] ?? [];
  }

  List<String> getAllDates() {
    final dates = _tripsByDate.keys.toList();
    dates.sort((a, b) => b.compareTo(a)); // descending order
    return dates;
  }

  void _addDummyData() {
    addTripsForDate('2024-06-01', [
      TripData(
        tripDetail: 'Driver 1 - Trip A',
        tripFrom: 'City A',
        tripTo: 'City B',
        dieselAmount: 50,
        tollgateAmount: 10,
        vidAmount: 5,
        foodAmount: 20,
        policeAmount: 0,
        tripAmount: 200,
      ),
      TripData(
        tripDetail: 'Driver 1 - Trip B',
        tripFrom: 'City C',
        tripTo: 'City D',
        dieselAmount: 40,
        tollgateAmount: 15,
        vidAmount: 0,
        foodAmount: 25,
        policeAmount: 5,
        tripAmount: 180,
      ),
    ]);
    addTripsForDate('2024-06-02', [
      TripData(
        tripDetail: 'Driver 1 - Trip C',
        tripFrom: 'City E',
        tripTo: 'City F',
        dieselAmount: 60,
        tollgateAmount: 12,
        vidAmount: 3,
        foodAmount: 18,
        policeAmount: 2,
        tripAmount: 220,
      ),
    ]);
    addTripsForDate('2024-06-03', [
      TripData(
        tripDetail: 'Driver 1 - Trip D',
        tripFrom: 'City G',
        tripTo: 'City H',
        dieselAmount: 55,
        tollgateAmount: 8,
        vidAmount: 4,
        foodAmount: 22,
        policeAmount: 1,
        tripAmount: 210,
      ),
      TripData(
        tripDetail: 'Driver 1 - Trip E',
        tripFrom: 'City I',
        tripTo: 'City J',
        dieselAmount: 45,
        tollgateAmount: 10,
        vidAmount: 2,
        foodAmount: 20,
        policeAmount: 3,
        tripAmount: 190,
      ),
      TripData(
        tripDetail: 'Driver 2 - Trip F',
        tripFrom: 'City K',
        tripTo: 'City L',
        dieselAmount: 50,
        tollgateAmount: 9,
        vidAmount: 1,
        foodAmount: 15,
        policeAmount: 0,
        tripAmount: 195,
      ),
    ]);
    // Add 5 test drivers with trips
    addTripsForDate('2024-06-04', [
      TripData(
        tripDetail: 'Driver 3 - Trip G',
        tripFrom: 'City M',
        tripTo: 'City N',
        dieselAmount: 30,
        tollgateAmount: 5,
        vidAmount: 2,
        foodAmount: 10,
        policeAmount: 0,
        tripAmount: 150,
      ),
      TripData(
        tripDetail: 'Driver 4 - Trip H',
        tripFrom: 'City O',
        tripTo: 'City P',
        dieselAmount: 35,
        tollgateAmount: 7,
        vidAmount: 3,
        foodAmount: 12,
        policeAmount: 1,
        tripAmount: 160,
      ),
      TripData(
        tripDetail: 'Driver 5 - Trip I',
        tripFrom: 'City Q',
        tripTo: 'City R',
        dieselAmount: 40,
        tollgateAmount: 6,
        vidAmount: 4,
        foodAmount: 15,
        policeAmount: 2,
        tripAmount: 170,
      ),
      TripData(
        tripDetail: 'Driver 6 - Trip J',
        tripFrom: 'City S',
        tripTo: 'City T',
        dieselAmount: 45,
        tollgateAmount: 8,
        vidAmount: 5,
        foodAmount: 18,
        policeAmount: 0,
        tripAmount: 180,
      ),
      TripData(
        tripDetail: 'Driver 7 - Trip K',
        tripFrom: 'City U',
        tripTo: 'City V',
        dieselAmount: 50,
        tollgateAmount: 9,
        vidAmount: 6,
        foodAmount: 20,
        policeAmount: 1,
        tripAmount: 190,
      ),
    ]);
  }
}
