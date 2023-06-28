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
}
