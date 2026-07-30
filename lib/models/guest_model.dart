// lib/models/guest_model.dart
class GuestModel {
  final String fullName;
  final String email;
  final String nationality;
  final String phone;

  GuestModel({
    required this.fullName,
    required this.email,
    required this.nationality,
    required this.phone,
  });

  // Factory method to create a GuestModel from JSON (for API integration)
  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      nationality: json['nationality'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  // Convert GuestModel to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'nationality': nationality,
      'phone': phone,
    };
  }

  // Create a copy with updated fields
  GuestModel copyWith({
    String? fullName,
    String? email,
    String? nationality,
    String? phone,
  }) {
    return GuestModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nationality: nationality ?? this.nationality,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'GuestModel(fullName: $fullName, email: $email, nationality: $nationality, phone: $phone)';
  }
}