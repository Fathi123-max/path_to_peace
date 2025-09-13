# Project State Snapshot

## Project Overview
- **Name**: Path to Peace
- **Type**: Flutter mobile application
- **Purpose**: Educational app to help non-Muslims learn about Islam through inspirational quotes and FAQs
- **Platform**: Cross-platform (iOS/Android)

## Current Implementation Status

### Core Features
1. ✅ Home Screen with inspirational quotes
2. ✅ FAQ Screen with expandable question/answer cards
3. ✅ About Screen with app information
4. ✅ Bottom Navigation
5. ✅ Data models for Quotes and FAQs
6. ✅ API service layer
7. ✅ Local caching mechanism
8. ✅ Share functionality
9. ✅ Responsive design with ScreenUtil
10. ✅ Glassmorphism UI effects
11. ✅ Dark/Light mode support
12. ✅ Material You dynamic color support

### File Structure
```
lib/
├── main.dart
├── models/
│   ├── quote.dart
│   └── faq.dart
├── screens/
│   ├── home_screen.dart
│   ├── faq_screen.dart
│   └── about_screen.dart
├── services/
│   ├── api_service.dart
│   └── local_cache.dart
├── theme/
│   ├── colors.dart
│   ├── design_tokens.dart
│   └── typography.dart
├── widgets/
│   ├── bottom_nav.dart
│   ├── quote_card.dart
│   ├── faq_card.dart
│   ├── section_card.dart
│   └── share_modal.dart
└── utils/
    └── constants.dart
```

### Dependencies
All required dependencies are properly configured in pubspec.yaml:
- flutter_screenutil (responsive design)
- google_fonts (custom typography)
- share_plus (content sharing)
- http (API requests)
- flutter_svg (SVG icon support)
- lottie (animations)
- shared_preferences (local storage)
- animations (advanced animations)
- dynamic_color (Material You support)
- url_launcher (external links)

### UI/UX Features
- Glassmorphism design effects using BackdropFilter
- Smooth animations for FAQ card expansion
- Responsive layout using ScreenUtil
- Consistent design system with design tokens
- Dark/light mode with dynamic color support
- Custom typography with Google Fonts
- Intuitive bottom navigation

### Data Management
- API service for fetching remote data
- Local cache for offline functionality
- JSON serialization for data models
- Error handling for network requests
- Fallback mechanisms for data loading

## SPP (System Prompt Programming) for FAQ Screen

### Component Analysis

#### FAQ Model (lib/models/faq.dart)
```dart
class Faq {
  final String id;
  final String question;
  final String answer;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}
```

#### FAQ Screen (lib/screens/faq_screen.dart)
The FAQ screen implements:
1. Data loading from API with local cache fallback
2. Loading, error, and empty states
3. Scrollable list of FAQ cards
4. State management for expanded/collapsed cards

#### FAQ Card (lib/widgets/faq_card.dart)
The FAQ card implements:
1. Expandable/collapsible animation
2. Question/answer display
3. Share functionality via modal
4. Glassmorphism design effects

#### Services
1. API Service (lib/services/api_service.dart):
   - Fetch FAQs from remote API
   - Error handling for network requests

2. Local Cache (lib/services/local_cache.dart):
   - Cache FAQs for offline use
   - JSON serialization/deserialization

### Key Implementation Details

#### State Management
- Uses StatefulWidget for FAQ expansion tracking
- Implements loading/error states
- Manages animation controllers for smooth transitions

#### Animations
- Uses AnimationController for FAQ card expansion
- Implements rotation animation for expand/collapse icon
- Uses SizeTransition and CurvedAnimation for smooth expansion

#### Data Flow
1. Screen initializes and calls _loadFaqs()
2. Attempts to fetch from API first
3. Falls back to local cache if API fails
4. Caches API results for future offline use
5. Renders FAQ cards in a scrollable list
6. Handles user interactions for card expansion

#### UI Components
- Glassmorphism effect using BackdropFilter.blur()
- Responsive sizing with ScreenUtil
- Custom typography with GoogleFonts
- Consistent design tokens for spacing and radius
- Themed colors for light/dark modes

#### Error Handling
- Network error detection and display
- Loading state with progress indicator
- Retry mechanism for failed requests
- Empty state for no data scenarios

### Testing Considerations
- Widget tests for UI components
- Integration tests for API/local cache
- Error state simulation
- Animation verification
- Responsive design validation

This implementation follows Flutter best practices with a clean separation of concerns between UI, business logic, and data layers.