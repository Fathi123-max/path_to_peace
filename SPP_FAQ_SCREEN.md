# SPP (System Prompt Programming) for FAQ Screen

## Overview
This SPP document describes the implementation of the FAQ screen in the Path to Peace application. The FAQ screen displays a list of frequently asked questions about Islam with expandable answers.

## Component Structure

### 1. FAQ Model (lib/models/faq.dart)
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

### 2. FAQ Screen (lib/screens/faq_screen.dart)

#### State Management
The FAQ screen implements StatefulWidget with the following state variables:
- `_faqs`: List of FAQ objects (nullable)
- `_isLoading`: Boolean indicating data loading state
- `_isError`: Boolean indicating error state
- `_expandedIndex`: Index of currently expanded FAQ (-1 if none)

#### Data Loading
The screen implements a data loading strategy with multiple fallbacks:
1. First attempts to fetch FAQs from the API
2. If API fails, tries to load from local cache
3. If no cached data, uses hardcoded fallback data
4. Successfully fetched data is cached for future offline use

#### UI Components
The screen renders:
1. Loading state with progress indicator
2. Error state with retry option
3. Empty state for no data
4. List of FAQ cards when data is available

### 3. FAQ Card (lib/widgets/faq_card.dart)

#### Animation System
The FAQ card implements expandable/collapsible animation using:
- AnimationController for timing control
- CurvedAnimation for easing functions
- SizeTransition for height animation
- RotationTransition for expand icon rotation

#### UI Features
- Glassmorphism effect using BackdropFilter
- Question header with expand/collapse icon
- Animated answer section
- Share functionality via modal

### 4. Services

#### API Service (lib/services/api_service.dart)
- Fetches FAQs from remote API endpoint
- Handles network errors gracefully
- Returns parsed FAQ objects

#### Local Cache (lib/services/local_cache.dart)
- Caches FAQs using SharedPreferences
- Serializes/deserializes FAQ objects to/from JSON
- Provides mechanism for data persistence

## Implementation Details

### Data Flow
1. Screen initializes and calls _loadFaqs()
2. Attempts API fetch with error handling
3. Falls back to local cache on failure
4. Uses hardcoded data if both fail
5. Caches successful API results
6. Renders FAQ cards in scrollable list
7. Manages expansion state on user interaction

### Animations
- Smooth expand/collapse using AnimationController
- 300ms duration with Curves.easeInOut
- Rotation animation for expand icon
- Size transition for answer content

### UI/UX Features
- Glassmorphism design with BackdropFilter.blur()
- Responsive sizing with ScreenUtil
- Themed colors for light/dark modes
- Consistent design tokens for spacing
- Loading, error, and empty states

### Error Handling
- Network error detection
- Loading state management
- Retry mechanism
- Fallback to cached/local data

## Testing Approach

### Widget Tests
- Verify FAQ card rendering
- Test expand/collapse functionality
- Validate loading states
- Check error handling

### Integration Tests
- API service functionality
- Local cache operations
- Data flow between components

## Design Principles

### Separation of Concerns
- Data models separated from UI
- Services isolated from presentation
- Reusable components (FAQ card)
- Clear state management

### Performance Considerations
- Lazy loading of FAQs
- Efficient animations
- Local caching for offline use
- Proper disposal of controllers

### Accessibility
- Semantic widget structure
- Proper contrast for text
- Sufficient touch targets
- Clear focus indicators

This implementation follows Flutter best practices with a clean architecture that separates data, presentation, and business logic layers.