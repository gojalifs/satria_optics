import 'dart:convert';
import 'dart:io';

class UserProfile {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? birth;
  final String? gender;
  final String? avatarPath;
  final List? favorites;
  final File? image;

  UserProfile({
    this.id = '',
    this.name = '',
    this.username,
    this.email = '',
    this.phone = '',
    this.birth = '',
    this.gender = '',
    this.avatarPath = '',
    this.favorites,
    this.image,
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
      'favorites': favorites,
      'image': image,
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
      favorites: map['favorites'],
      image: map['image'],
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
    List<String>? favorites,
    File? image,
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
      favorites: favorites ?? this.favorites,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, username: $username, email: $email, phone: $phone, birth: $birth, gender: $gender, avatarPath: $avatarPath, favorites: $favorites, image: $image)';
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
        other.avatarPath == avatarPath &&
        other.favorites == favorites &&
        other.image == image;
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
        favorites.hashCode ^
        avatarPath.hashCode ^
        image.hashCode;
  }
}
