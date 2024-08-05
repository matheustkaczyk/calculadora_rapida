class Item {
  final int? id;
  final String name;
  final int price;
  int quantity;

  Item({this.id, required this.name, required this.price, this.quantity = 0});

  Item copyWith({int? id, String? name, int? price, int? quantity}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}