class Driver {
  final String fullName;
  final String idNumber;
  final String phoneNumber;
  final String? imagePath;
  final String password;
  final String vehicleType;

  Driver({
    required this.fullName,
    required this.idNumber,
    required this.phoneNumber,
    this.imagePath,
    required this.password,
    required this.vehicleType,
  });
}
