import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/driver_data_store.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isEditing = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();

  String _savedFullName = '';
  String _savedIdNumber = '';
  String _savedPhone = '';
  String _savedVehicleType = '';

  @override
  void initState() {
    super.initState();
    final drivers = DriverDataStore().getAllDrivers();
    final driver = drivers.isNotEmpty ? drivers.first : null;

    _savedFullName = driver?.fullName ?? '';
    _savedIdNumber = driver?.idNumber ?? '';
    _savedPhone = driver?.phoneNumber ?? '';
    _savedVehicleType = driver?.vehicleType ?? '';

    _fullNameController.text = _savedFullName;
    _idNumberController.text = _savedIdNumber;
    _phoneController.text = _savedPhone;
    _vehicleTypeController.text = _savedVehicleType;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _vehicleTypeController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Cancel editing, revert to saved values
        _fullNameController.text = _savedFullName;
        _idNumberController.text = _savedIdNumber;
        _phoneController.text = _savedPhone;
        _vehicleTypeController.text = _savedVehicleType;
      }
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _savedFullName = _fullNameController.text.trim();
      _savedIdNumber = _idNumberController.text.trim();
      _savedPhone = _phoneController.text.trim();
      _savedVehicleType = _vehicleTypeController.text.trim();
      _isEditing = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile saved')));
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
        title: Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(icon: Icon(Icons.edit), onPressed: _toggleEdit),
          if (_isEditing) ...[
            IconButton(icon: Icon(Icons.save), onPressed: _saveProfile),
            IconButton(icon: Icon(Icons.cancel), onPressed: _toggleEdit),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Full Name',
              controller: _fullNameController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'ID Number',
              controller: _idNumberController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              label: 'Vehicle Type',
              controller: _vehicleTypeController,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }
}
