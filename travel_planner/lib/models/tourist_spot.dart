import 'travel_plan.dart';

class Polygon {
  final List<LatLng> points;

  const Polygon({required this.points});

  bool containsPoint(LatLng point) {
    bool isInside = false;
    int j = points.length - 1;

    for (int i = 0; i < points.length; i++) {
      if ((points[i].longitude < point.longitude && points[j].longitude >= point.longitude) ||
          (points[j].longitude < point.longitude && points[i].longitude >= point.longitude)) {
        if (points[i].latitude + (point.longitude - points[i].longitude) /
                (points[j].longitude - points[i].longitude) *
                (points[j].latitude - points[i].latitude) <
            point.latitude) {
          isInside = !isInside;
        }
      }
      j = i;
    }
    return isInside;
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point.toJson()).toList(),
    };
  }

  factory Polygon.fromJson(Map<String, dynamic> json) {
    return Polygon(
      points: (json['points'] as List)
          .map((point) => LatLng.fromJson(point as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TouristSpot {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String type; // Nature, Cultural, Historical, etc.
  final LatLng location;
  final Polygon zone;
  final double rating;
  final Map<String, dynamic> operatingHours;
  final double price; // Optional: entrance fee or estimated cost
  final List<String> facilities;
  final int estimatedDuration; // in hours

  const TouristSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.location,
    required this.zone,
    this.rating = 0.0,
    required this.operatingHours,
    this.price = 0.0,
    this.facilities = const [],
    this.estimatedDuration = 2,
  });

  bool isWithinZone(LatLng point) {
    return zone.containsPoint(point);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'location': location.toJson(),
      'zone': zone.toJson(),
      'rating': rating,
      'operatingHours': operatingHours,
      'price': price,
      'facilities': facilities,
      'estimatedDuration': estimatedDuration,
    };
  }

  factory TouristSpot.fromJson(Map<String, dynamic> json) {
    return TouristSpot(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
      zone: Polygon.fromJson(json['zone'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      operatingHours: json['operatingHours'] as Map<String, dynamic>,
      price: (json['price'] as num).toDouble(),
      facilities: List<String>.from(json['facilities'] as List),
      estimatedDuration: json['estimatedDuration'] as int,
    );
  }
}

class Accommodation {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String type; // Hotel, Resort, Homestay, etc.
  final LatLng location;
  final Polygon zone;
  final double rating;
  final double pricePerNight;
  final List<String> amenities;
  final Map<String, dynamic> checkInOut;

  const Accommodation({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.location,
    required this.zone,
    this.rating = 0.0,
    required this.pricePerNight,
    this.amenities = const [],
    required this.checkInOut,
  });

  bool isWithinZone(LatLng point) {
    return zone.containsPoint(point);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'location': location.toJson(),
      'zone': zone.toJson(),
      'rating': rating,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'checkInOut': checkInOut,
    };
  }

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
      zone: Polygon.fromJson(json['zone'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      amenities: List<String>.from(json['amenities'] as List),
      checkInOut: json['checkInOut'] as Map<String, dynamic>,
    );
  }
}
