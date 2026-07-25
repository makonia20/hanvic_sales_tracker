class TripData {
  String? tripDetail;
  String? tripFrom;
  String? tripTo;
  double dieselAmount;
  double tollgateAmount;
  double vidAmount;
  double foodAmount;
  double policeAmount;
  double tripAmount;

  TripData({
    this.tripDetail,
    this.tripFrom,
    this.tripTo,
    this.dieselAmount = 0,
    this.tollgateAmount = 0,
    this.vidAmount = 0,
    this.foodAmount = 0,
    this.policeAmount = 0,
    this.tripAmount = 0,
  });

  double get totalColumn2 =>
      dieselAmount + tollgateAmount + vidAmount + foodAmount + policeAmount;

  double get totalAfterSubtracting => tripAmount - totalColumn2;

  @override
  String toString() {
    return 'TripDetail: \$tripDetail, From: \$tripFrom, To: \$tripTo, Diesel: \$dieselAmount, Tollgate: \$tollgateAmount, Vid: \$vidAmount, Food: \$foodAmount, Police: \$policeAmount, TripAmount: \$tripAmount';
  }

  // Dummy data for testing and demonstration
  static List<TripData> dummyTripsForDemo() {
    return [
      TripData(
        tripDetail: 'Trip A',
        tripFrom: 'Location 1',
        tripTo: 'Location 2',
        dieselAmount: 10,
        tollgateAmount: 5,
        vidAmount: 2,
        foodAmount: 3,
        policeAmount: 1,
        tripAmount: 25,
      ),
      TripData(
        tripDetail: 'Trip B',
        tripFrom: 'Location 3',
        tripTo: 'Location 4',
        dieselAmount: 8,
        tollgateAmount: 4,
        vidAmount: 1,
        foodAmount: 2,
        policeAmount: 0,
        tripAmount: 20,
      ),
      TripData(
        tripDetail: 'Trip C',
        tripFrom: 'Location 5',
        tripTo: 'Location 6',
        dieselAmount: 12,
        tollgateAmount: 6,
        vidAmount: 3,
        foodAmount: 4,
        policeAmount: 2,
        tripAmount: 30,
      ),
    ];
  }
}
