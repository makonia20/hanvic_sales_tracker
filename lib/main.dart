import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/admin_dashboard.dart';
import 'screens/driver_dashboard.dart';
import 'screens/sales_documentation/receipts.dart';
import 'screens/sales_documentation/quotations.dart';
import 'screens/sales_documentation/invoice.dart';
import 'screens/sales_documentation/view_all_receipts.dart';
import 'screens/sales_documentation/view_all_quotations.dart';
import 'screens/sales_documentation/view_all_invoices.dart';

void main() {
  runApp(const HanvicApp());
}

class HanvicApp extends StatelessWidget {
  const HanvicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hanvic Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF001F3F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF001F3F),
          secondary: const Color(0xFFFF0000),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/admin': (context) => AdminDashboard(),
        '/driver': (context) => DriverDashboard(),
        '/receipts': (context) => ReceiptsPage(),
        '/quotations': (context) => QuotationsPage(),
        '/invoices': (context) => InvoicePage(),
        '/view_all_receipts': (context) => ViewAllReceiptsPage(),
        '/view_all_quotations': (context) => ViewAllQuotationsPage(),
        '/view_all_invoices': (context) => ViewAllInvoicesPage(),
      },
    );
  }
}
