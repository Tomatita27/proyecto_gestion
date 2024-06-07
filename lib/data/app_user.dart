import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String photoRoute;
  final bool isBoss;
  Timestamp? lastLogin;

  AppUser(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.photoRoute,
      required this.isBoss});
}