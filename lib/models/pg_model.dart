// lib/models/pg_model.dart
class PgModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int totalRooms;
  final int availableRooms;
  final int rent;
  final String status;
  final String imageUrl;
  final List<String> amenities;
  final List<UserComment> comments;
  final String description;

  PgModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.totalRooms,
    required this.availableRooms,
    required this.rent,
    required this.status,
    required this.imageUrl,
    required this.amenities,
    required this.comments,
    required this.description,
  });
}

class UserComment {
  final String userName;
  final String text;

  UserComment(this.userName, this.text);
}