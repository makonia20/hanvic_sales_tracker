import 'receipt.dart';

class SalesDataStore {
  static final SalesDataStore _instance = SalesDataStore._internal();

  factory SalesDataStore() => _instance;

  SalesDataStore._internal();

  final List<Receipt> receipts = [];
  final List<Receipt> invoices = [];
  final List<Receipt> quotations = [];

  void addReceipt(Receipt receipt) {
    receipts.add(receipt);
  }

  void addInvoice(Receipt invoice) {
    invoices.add(invoice);
  }

  void addQuotation(Receipt quotation) {
    quotations.add(quotation);
  }
}
