// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {
  String? _userID;
  FirebaseFirestore _db;
  Reference _storageRef;
  FieldValue _timestamp;

  FirestoreHelper()
      : _userID = FirebaseAuth.instance.currentUser!.uid,
        _db = FirebaseFirestore.instance,
        _storageRef = FirebaseStorage.instance.ref(),
        _timestamp = FieldValue.serverTimestamp();

  String? get userID => _userID;
  FirebaseFirestore get db => _db;
  Reference get storageRef => _storageRef;
  FieldValue get timestamp => _timestamp;
}
