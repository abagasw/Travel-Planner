import 'package:flutter/material.dart';

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      json['latitude'] as double,
      json['longitude'] as double,
    );
  }
}

class TravelPlan {
  final String id;
  final String userId;
  final String destination;
  final LatLng location;
  final DateTime startDate;
  final DateTime endDate;
  final int duration; // in days

  TravelPlan({
    required this.id,
    required this.userId,
    required this.destination,
    required this.location,
    required this.startDate,
    required this.endDate,
    int? duration,
  }) : duration = duration ?? endDate.difference(startDate).inDays;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'destination': destination,
      'location': location.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'duration': duration,
    };
  }

  factory TravelPlan.fromJson(Map<String, dynamic> json) {
    return TravelPlan(
      id: json['id'] as String,
      userId: json['userId'] as String,
      destination: json['destination'] as String,
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      duration: json['duration'] as int,
    );
  }
}
