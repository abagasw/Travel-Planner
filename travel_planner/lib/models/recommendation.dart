import 'tourist_spot.dart';
import 'travel_plan.dart';

class DailyItinerary {
  final int day;
  final List<TouristSpot> spots;
  final DateTime date;
  final double estimatedCost;

  const DailyItinerary({
    required this.day,
    required this.spots,
    required this.date,
    required this.estimatedCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'spots': spots.map((spot) => spot.toJson()).toList(),
      'date': date.toIso8601String(),
      'estimatedCost': estimatedCost,
    };
  }

  factory DailyItinerary.fromJson(Map<String, dynamic> json) {
    return DailyItinerary(
      day: json['day'] as int,
      spots: (json['spots'] as List)
          .map((spot) => TouristSpot.fromJson(spot as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );
  }
}

class TravelRecommendation {
  final String id;
  final TravelPlan plan;
  final Accommodation accommodation;
  final List<DailyItinerary> itinerary;
  final double totalEstimatedCost;
  final Map<String, dynamic> additionalInfo;

  const TravelRecommendation({
    required this.id,
    required this.plan,
    required this.accommodation,
    required this.itinerary,
    required this.totalEstimatedCost,
    this.additionalInfo = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan': plan.toJson(),
      'accommodation': accommodation.toJson(),
      'itinerary': itinerary.map((day) => day.toJson()).toList(),
      'totalEstimatedCost': totalEstimatedCost,
      'additionalInfo': additionalInfo,
    };
  }

  factory TravelRecommendation.fromJson(Map<String, dynamic> json) {
    return TravelRecommendation(
      id: json['id'] as String,
      plan: TravelPlan.fromJson(json['plan'] as Map<String, dynamic>),
      accommodation: Accommodation.fromJson(json['accommodation'] as Map<String, dynamic>),
      itinerary: (json['itinerary'] as List)
          .map((day) => DailyItinerary.fromJson(day as Map<String, dynamic>))
          .toList(),
      totalEstimatedCost: (json['totalEstimatedCost'] as num).toDouble(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>,
    );
  }

  // Helper method to get spots for a specific day
  List<TouristSpot> getSpotsForDay(int day) {
    return itinerary
        .firstWhere((item) => item.day == day, orElse: () => DailyItinerary(
              day: day,
              spots: [],
              date: plan.startDate.add(Duration(days: day - 1)),
              estimatedCost: 0,
            ))
        .spots;
  }

  // Helper method to check if the itinerary is within user's preferences
  bool matchesPreferences(List<String> preferredTypes) {
    return itinerary.every((day) => day.spots.any(
          (spot) => preferredTypes.contains(spot.type),
        ));
  }
}
