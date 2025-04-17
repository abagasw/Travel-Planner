# Travel Planner App

A Flutter application for planning travel itineraries with personalized recommendations based on user preferences and location polygons.

## Features

- User registration with preference selection
- Personalized travel recommendations
- Polygon-based location matching
- Accommodation suggestions
- Tourist spot recommendations
- Daily itinerary planning
- Cost estimation

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Navigate to the project directory:
```bash
cd travel_planner
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/
│   ├── user_preferences.dart
│   ├── travel_plan.dart
│   ├── tourist_spot.dart
│   └── recommendation.dart
├── screens/
│   ├── registration_screen.dart
│   ├── home_screen.dart
│   └── create_plan_screen.dart
├── services/
│   └── recommendation_service.dart
└── main.dart
```

## Usage

1. Register and set your travel preferences
2. Create a new travel plan
3. View personalized recommendations
4. Select and customize your itinerary

## Implementation Details

### Polygon-based Recommendations

The app uses polygon zones to determine suitable tourist spots and accommodations based on the user's selected location. This is implemented in the `recommendation_service.dart` file using the ray-casting algorithm.

### User Preferences

User preferences are stored and used to filter and prioritize recommendations, ensuring personalized travel suggestions that match the user's interests.

### Itinerary Generation

The app generates daily itineraries considering:
- User preferences
- Location proximity
- Time constraints
- Operating hours
- Estimated duration at each spot

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
