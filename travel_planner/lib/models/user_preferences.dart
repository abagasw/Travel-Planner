class UserPreferences {
  final List<String> preferredSpotTypes; // Nature, Cultural, Historical, etc.
  final List<String> preferredRegions;
  final int defaultDuration; // in days

  UserPreferences({
    required this.preferredSpotTypes,
    required this.preferredRegions,
    this.defaultDuration = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferredSpotTypes': preferredSpotTypes,
      'preferredRegions': preferredRegions,
      'defaultDuration': defaultDuration,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      preferredSpotTypes: List<String>.from(json['preferredSpotTypes']),
      preferredRegions: List<String>.from(json['preferredRegions']),
      defaultDuration: json['defaultDuration'] ?? 3,
    );
  }
}
