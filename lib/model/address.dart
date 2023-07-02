class Address {
  final String? id;
  final String city;
  final String detail;
  final String phone;
  final String postalCode;
  final String province;
  final String receiverName;
  final String street;
  final String subdistrict;
  final String village;
  final String country;
  Address({
    this.id,
    required this.city,
    required this.detail,
    required this.phone,
    required this.postalCode,
    required this.province,
    required this.receiverName,
    required this.street,
    required this.subdistrict,
    required this.village,
    required this.country,
  });

  Address copyWith({
    String? id,
    String? city,
    String? detail,
    String? phone,
    String? postalCode,
    String? province,
    String? receiverName,
    String? street,
    String? subdistrict,
    String? village,
    String? country,
  }) {
    return Address(
      id: id ?? this.id,
      city: city ?? this.city,
      detail: detail ?? this.detail,
      phone: phone ?? this.phone,
      postalCode: postalCode ?? this.postalCode,
      province: province ?? this.province,
      receiverName: receiverName ?? this.receiverName,
      street: street ?? this.street,
      subdistrict: subdistrict ?? this.subdistrict,
      village: village ?? this.village,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'detail': detail,
      'phone': phone,
      'postalCode': postalCode,
      'province': province,
      'receiverName': receiverName,
      'street': street,
      'subdistrict': subdistrict,
      'village': village,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      city: map['city'] ?? '',
      detail: map['detail'] ?? '',
      phone: map['phone'] ?? '',
      postalCode: map['postalCode'] ?? '',
      province: map['province'] ?? '',
      receiverName: map['receiverName'] ?? '',
      street: map['street'] ?? '',
      subdistrict: map['subdistrict'] ?? '',
      village: map['village'] ?? '',
      country: map['country'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, city: $city, detail: $detail, phone: $phone, postalCode: $postalCode, province: $province, receiverName: $receiverName, street: $street, subdistrict: $subdistrict, village: $village)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.id == id &&
        other.city == city &&
        other.detail == detail &&
        other.phone == phone &&
        other.postalCode == postalCode &&
        other.province == province &&
        other.receiverName == receiverName &&
        other.street == street &&
        other.subdistrict == subdistrict &&
        other.village == village &&
        other.country == country;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        city.hashCode ^
        detail.hashCode ^
        phone.hashCode ^
        postalCode.hashCode ^
        province.hashCode ^
        receiverName.hashCode ^
        street.hashCode ^
        subdistrict.hashCode ^
        village.hashCode ^
        country.hashCode;
  }
}
