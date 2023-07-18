import 'dart:convert';

class UserProfile {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? birth;
  final String? gender;
  final String? avatarPath;

  UserProfile({
    this.id = '',
    this.name = '',
    this.username,
    this.email = '',
    this.phone = '',
    this.birth = '',
    this.gender = '',
    this.avatarPath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'birth': birth,
      'gender': gender,
      'avatarPath': avatarPath,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      birth: map['birth'],
      gender: map['gender'],
      avatarPath: map['avatarPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  UserProfile copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? birth,
    String? gender,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, username: $username, email: $email, phone: $phone, birth: $birth, gender: $gender, avatarPath: $avatarPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.birth == birth &&
        other.gender == gender &&
        other.avatarPath == avatarPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        avatarPath.hashCode;
  }
}
