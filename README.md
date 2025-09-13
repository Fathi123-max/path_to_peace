# Path to Peace

A Flutter application designed to help curious non-Muslims learn about Islam through authentic quotes and FAQs.

## Features

- Daily inspirational quotes from the Quran and Hadith
- Frequently asked questions about Islam with detailed answers
- About section with app information and contact option
- Dark/light mode support
- Offline-first functionality with local caching
- Share quotes and FAQs via multiple platforms
- Responsive design for all device sizes
- Micro-interactions and animations for enhanced UX

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd path_to_peace
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Set up environment variables (optional):
   Create a `.env` file in the root directory with:
   ```
   API_BASE_URL=https://your-api-base-url.com
   ```

5. Run the app:
   ```
   flutter run -d <device>
   ```

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── faq_screen.dart
│   └── about_screen.dart
├── widgets/
│   ├── quote_card.dart
│   ├── faq_card.dart
│   ├── bottom_nav.dart
│   └── share_modal.dart
├── models/
│   ├── quote.dart
│   └── faq.dart
├── services/
│   ├── api_service.dart
│   └── local_cache.dart
├── theme/
│   ├── colors.dart
│   ├── typography.dart
│   └── design_tokens.dart
├── assets/
│   ├── data/
│   │   ├── quotes.json
│   │   └── faq.json
│   ├── icons/
│   └── lottie/
```

## Dependencies

- flutter_screenutil: Responsive design
- google_fonts: Custom fonts (Inter, Lato, Cairo)
- share_plus: Share functionality
- http: API requests
- flutter_svg: SVG icon support
- lottie: Micro-animations
- shared_preferences: Local data caching
- animations: Smooth transitions
- dynamic_color: Material You theming
- url_launcher: Email functionality
- flutter_localizations: Localization support

## Design Implementation

### Tailwind to Flutter Mapping

| Tailwind Class | Flutter Implementation |
|----------------|------------------------|
| `.bg-white/30` | `Color(0x4DFFFFFF)` |
| `.backdrop-blur-md` | `BackdropFilter(blur: ImageFilter.blur(sigmaX: 10, sigmaY: 10))` |
| `.rounded-2xl` | `BorderRadius.circular(24.r)` |
| `.p-6` | `EdgeInsets.all(24.r)` |
| `.shadow` | `BoxShadow` with appropriate values |

## Testing

Run widget tests:
```
flutter test
```

## Localization

The app supports English and Arabic languages. To add more languages:

1. Add the locale to `supportedLocales` in `main.dart`
2. Create the corresponding ARB files in `lib/l10n/`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request
