import 'dart:convert';

class Lens {
  final String? id;
  final String? name;
  final String? description;
  final int? price;

  Lens({
    this.id,
    this.name,
    this.description,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory Lens.fromMap(Map<String, dynamic> map) {
    return Lens(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Lens.fromJson(String source) => Lens.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Lens &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ price.hashCode;
  }
}
