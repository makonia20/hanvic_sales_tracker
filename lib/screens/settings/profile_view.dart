import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isEditing = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _savedFullName = '';
  String _savedEmail = '';
  String _savedPhone = '';

  @override
  void initState() {
    super.initState();
    // Initialize with empty or dummy data
    _savedFullName = '';
    _savedEmail = '';
    _savedPhone = '';

    _fullNameController.text = _savedFullName;
    _emailController.text = _savedEmail;
    _phoneController.text = _savedPhone;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Cancel editing, revert to saved values
        _fullNameController.text = _savedFullName;
        _emailController.text = _savedEmail;
        _phoneController.text = _savedPhone;
      }
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _savedFullName = _fullNameController.text.trim();
      _savedEmail = _emailController.text.trim();
      _savedPhone = _phoneController.text.trim();
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
        title: Text('Profile View'),
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
            _buildTextField(
              label: 'Full Name',
              controller: _fullNameController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
