import 'package:flutter/material.dart';
import 'package:hanvic_sales_tracker/models/driver.dart';
import 'package:hanvic_sales_tracker/models/driver_data_store.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _vehicleType = 'Tipper';
  String? _imagePath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final newDriver = Driver(
        fullName: _fullNameController.text.trim(),
        idNumber: _idNumberController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        imagePath: _imagePath,
        password: _passwordController.text,
        vehicleType: _vehicleType,
      );

      // Simulate a delay for submission process
      await Future.delayed(Duration(seconds: 1));

      DriverDataStore().addDriver(newDriver);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Driver added successfully')));

      setState(() {
        _isSubmitting = false;
      });

      Navigator.of(context).pop();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _vehicleType,
        decoration: InputDecoration(
          labelText: 'Vehicle Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items:
            ['Tipper', 'Grabber']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
        onChanged: (value) {
          setState(() {
            _vehicleType = value ?? 'Tipper';
          });
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Driver Image', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Placeholder for image picker functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image picker not implemented yet')),
              );
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child:
                  _imagePath == null
                      ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey[600],
                      )
                      : Image.asset(_imagePath!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _idNumberController,
                label: 'ID Number',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter ID number';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              _buildImagePicker(),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              _buildDropdownField(),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child:
                      _isSubmitting
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text('Add Driver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
