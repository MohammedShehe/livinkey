// lib/services/auth_service.dart
import 'package:flutter/material.dart';

class AuthService {
  static const String _tenantEmail = 'molittle1011@gmail.com';
  static const String _guestEmail = 'mosnake111@gmail.com';
  static const String _tenantPassword = 'Tenant@123';
  static const String _guestPassword = 'Guest@123';

  static const String tenantRole = 'tenant';
  static const String guestRole = 'guest';

  static bool isValidCredentials(String email, String password) {
    return (email == _tenantEmail && password == _tenantPassword) ||
           (email == _guestEmail && password == _guestPassword);
  }

  static String? getRole(String email) {
    if (email == _tenantEmail) return tenantRole;
    if (email == _guestEmail) return guestRole;
    return null;
  }

  static bool isTenant(String email) {
    return email == _tenantEmail;
  }

  static bool isGuest(String email) {
    return email == _guestEmail;
  }
}