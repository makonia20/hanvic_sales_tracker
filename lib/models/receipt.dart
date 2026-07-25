class Item {
  String description;
  int quantity;
  double price;

  Item({
    required this.description,
    required this.quantity,
    required this.price,
  });
}

class Receipt {
  String receiptNumber;
  String customerName;
  DateTime date;
  List<Item> items;

  Receipt({
    required this.receiptNumber,
    required this.customerName,
    required this.date,
    required this.items,
  });
}
