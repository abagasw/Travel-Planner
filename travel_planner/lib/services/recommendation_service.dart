import 'dart:math';
import '../models/travel_plan.dart';
import '../models/tourist_spot.dart';
import '../models/recommendation.dart';
import '../models/user_preferences.dart';

class RecommendationService {
  // Simulated database of tourist spots and accommodations
  final List<TouristSpot> _spots = [];
  final List<Accommodation> _accommodations = [];

  // Initialize with some dummy data
  RecommendationService() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    // Example polygon for a tourist zone
    final dummyZone = Polygon(points: [
      const LatLng(-6.2088, 106.8456),
      const LatLng(-6.2088, 106.8656),
      const LatLng(-6.2288, 106.8656),
      const LatLng(-6.2288, 106.8456),
    ]);

    // Add some dummy tourist spots
    _spots.addAll([
      TouristSpot(
        id: '1',
        name: 'Beautiful Beach',
        description: 'A scenic beach with crystal clear water',
        imageUrl: 'https://example.com/beach.jpg',
        type: 'Nature',
        location: const LatLng(-6.2188, 106.8556),
        zone: dummyZone,
        operatingHours: {
          'open': '08:00',
          'close': '18:00',
        },
        rating: 4.5,
        facilities: ['Parking', 'Restroom', 'Food Court'],
      ),
      // Add more dummy spots as needed
    ]);

    // Add some dummy accommodations
    _accommodations.addAll([
      Accommodation(
        id: '1',
        name: 'Seaside Resort',
        description: 'Luxury resort with ocean view',
        imageUrl: 'https://example.com/resort.jpg',
        type: 'Resort',
        location: const LatLng(-6.2188, 106.8556),
        zone: dummyZone,
        rating: 4.8,
        pricePerNight: 200.0,
        amenities: ['Pool', 'Spa', 'Restaurant'],
        checkInOut: {
          'checkIn': '14:00',
          'checkOut': '12:00',
        },
      ),
      // Add more dummy accommodations as needed
    ]);
  }

  List<TouristSpot> _findSpotsInZone(LatLng location, List<String> preferredTypes) {
    return _spots.where((spot) {
      return spot.isWithinZone(location) && preferredTypes.contains(spot.type);
    }).toList();
  }

  List<Accommodation> _findAccommodationsInZone(LatLng location) {
    return _accommodations.where((acc) => acc.isWithinZone(location)).toList();
  }

  List<DailyItinerary> _createItinerary(
    List<TouristSpot> availableSpots,
    DateTime startDate,
    int duration,
  ) {
    final List<DailyItinerary> itinerary = [];
    final spotsPerDay = min(3, availableSpots.length ~/ duration);

    for (int day = 0; day < duration; day++) {
      final startIdx = day * spotsPerDay;
      final endIdx = min(startIdx + spotsPerDay, availableSpots.length);
      
      if (startIdx >= availableSpots.length) break;

      final daySpots = availableSpots.sublist(startIdx, endIdx);
      final dailyCost = daySpots.fold(0.0, (sum, spot) => sum + spot.price);

      itinerary.add(DailyItinerary(
        day: day + 1,
        spots: daySpots,
        date: startDate.add(Duration(days: day)),
        estimatedCost: dailyCost,
      ));
    }

    return itinerary;
  }

  TravelRecommendation generateRecommendation(
    TravelPlan plan,
    UserPreferences preferences,
  ) {
    // Find spots and accommodations within the zone
    final availableSpots = _findSpotsInZone(
      plan.location,
      preferences.preferredSpotTypes,
    );
    final availableAccommodations = _findAccommodationsInZone(plan.location);

    if (availableSpots.isEmpty || availableAccommodations.isEmpty) {
      throw Exception('No available spots or accommodations in the selected zone');
    }

    // Sort spots by rating
    availableSpots.sort((a, b) => b.rating.compareTo(a.rating));

    // Select best rated accommodation
    final accommodation = availableAccommodations
        .reduce((a, b) => a.rating > b.rating ? a : b);

    // Create daily itinerary
    final itinerary = _createItinerary(
      availableSpots,
      plan.startDate,
      plan.duration,
    );

    // Calculate total cost
    final accommodationCost = accommodation.pricePerNight * plan.duration;
    final activitiesCost = itinerary.fold(
      0.0,
      (sum, day) => sum + day.estimatedCost,
    );
    final totalCost = accommodationCost + activitiesCost;

    return TravelRecommendation(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
      plan: plan,
      accommodation: accommodation,
      itinerary: itinerary,
      totalEstimatedCost: totalCost,
      additionalInfo: {
        'accommodationCost': accommodationCost,
        'activitiesCost': activitiesCost,
      },
    );
  }

  // Method to get multiple recommendations
  List<TravelRecommendation> generateRecommendations(
    TravelPlan plan,
    UserPreferences preferences,
    {int count = 3}
  ) {
    final List<TravelRecommendation> recommendations = [];
    
    try {
      // Generate primary recommendation
      final primaryRec = generateRecommendation(plan, preferences);
      recommendations.add(primaryRec);

      // Generate alternative recommendations with different accommodations or spot combinations
      // This is a simplified version - in a real app, you'd want more sophisticated alternatives
      final availableAccommodations = _findAccommodationsInZone(plan.location);
      for (int i = 1; i < count && i < availableAccommodations.length; i++) {
        final altPlan = TravelPlan(
          id: '${plan.id}-alt$i',
          userId: plan.userId,
          destination: plan.destination,
          location: plan.location,
          startDate: plan.startDate,
          endDate: plan.endDate,
        );
        
        try {
          final altRec = generateRecommendation(altPlan, preferences);
          if (!recommendations.any((rec) => 
              rec.accommodation.id == altRec.accommodation.id)) {
            recommendations.add(altRec);
          }
        } catch (e) {
          // Skip failed alternative recommendations
          continue;
        }
      }
    } catch (e) {
      // If no recommendations can be generated, return empty list
      return [];
    }

    return recommendations;
  }
}
