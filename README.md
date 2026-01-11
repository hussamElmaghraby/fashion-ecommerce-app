# Fashion E-Commerce App

A Flutter e-commerce application for fashion products with cart management, checkout flow, user authentication, and favorites functionality.

## Requirements

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0 or higher

## Getting Started

### 1. Clone and Setup

```bash
cd fashion_ecommerce
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

The project uses code generation for Hive adapters and Riverpod providers. Run the following command after cloning:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Generate Localization Files

```bash
flutter gen-l10n
```

### 5. Run the App

Development mode:

```bash
flutter run
```

With a specific device:

```bash
flutter run -d <device_id>
```

List available devices:

```bash
flutter devices
```

## Build Commands

### Android

Debug APK:

```bash
flutter build apk --debug
```

Release APK:

```bash
flutter build apk --release
```

App Bundle (for Play Store):

```bash
flutter build appbundle --release
```

### iOS

Debug build:

```bash
flutter build ios --debug
```

Release build:

```bash
flutter build ios --release
```

## Testing

### Run All Tests

```bash
flutter test
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### Run Specific Test File

```bash
flutter test test/data/models/product_model_test.dart
```

### Run Tests in a Directory

```bash
flutter test test/data/models/
```

### Run Tests with Verbose Output

```bash
flutter test --reporter expanded
```

## Code Generation

### Watch Mode (Auto-rebuild on Changes)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Single Build

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Clean Generated Files

```bash
dart run build_runner clean
```

## Code Analysis

### Run Analyzer

```bash
flutter analyze
```

### Format Code

```bash
dart format lib/ test/
```

### Check Formatting

```bash
dart format --set-exit-if-changed lib/ test/
```

## Cleaning

### Clean Build Artifacts

```bash
flutter clean
```

### Full Clean and Rebuild

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Project Structure

```
lib/
  core/           - App configuration, constants, providers, utils, widgets
  data/           - Models, repositories, services
  features/       - Feature modules (auth, cart, checkout, favorites, home, etc.)
  gen/            - Generated assets
  main.dart       - App entry point

test/
  core/           - Core utility tests
  data/           - Model and repository tests
  features/       - Feature-specific tests
```

## Dependencies Overview

- State Management: flutter_riverpod
- Navigation: go_router
- Local Storage: hive, hive_flutter, shared_preferences
- Network: dio
- UI: cached_network_image, flutter_svg, shimmer, lottie

## Troubleshooting

### Hive Adapter Errors

If you encounter Hive adapter errors, regenerate the code:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Localization Not Found

Regenerate localization files:

```bash
flutter gen-l10n
```

### Dependency Conflicts

Update dependencies:

```bash
flutter pub upgrade
```

### iOS Pod Issues

```bash
cd ios
pod deintegrate
pod install
cd ..
```

## License

This project is for educational and demonstration purposes.
