class ShoppingItem {
  String id;
  String name;
  int quantity;
  String category;
  bool isBought;

  ShoppingItem({required this.id, required this.name, required this.quantity, required this.category, this.isBought = false});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'quantity': quantity, 'category': category, 'isBought': isBought};

  factory ShoppingItem.fromMap(Map<String, dynamic> map) =>
      ShoppingItem(id: map['id'], name: map['name'], quantity: map['quantity'], category: map['category'], isBought: map['isBought']);
}