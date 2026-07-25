import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String errorMessage = '';
  bool _obscurePassword = true;

  // Dummy users data
  final Map<String, String> adminUsers = {
    'Admin1': 'password1',
    'Admin2': 'password2',
    'Admin3': 'password3',
  };

  final Map<String, String> driverUsers = {
    'Driver1': 'password1',
    'Driver2': 'password2',
    'Driver3': 'password3',
    'Driver4': 'password4',
    'Driver5': 'password5',
  };

  void _login() {
    setState(() {
      errorMessage = '';
    });

    if (adminUsers.containsKey(username) && adminUsers[username] == password) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (driverUsers.containsKey(username) &&
        driverUsers[username] == password) {
      Navigator.pushReplacementNamed(context, '/driver');
    } else {
      setState(() {
        errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.jpg', width: 120),
                      const SizedBox(height: 30),
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF001F3F),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (val) => username = val,
                              style: const TextStyle(color: Color(0xFF001F3F)),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Color(0xFF001F3F)),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xFF001F3F),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: _obscurePassword,
                              onChanged: (val) => password = val,
                              style: const TextStyle(color: Color(0xFF001F3F)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF001F3F),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF001F3F),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF001F3F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF001F3F),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                              ),
                              onPressed: _login,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '© 2025 Hanvic Logistics All rights reserved',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
