# Fashion E-Commerce App

Flutter e-commerce app with Clean Architecture, Riverpod, and Arabic/English localization.

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

## Features

- Authentication (Login, Signup, Reset Password)
- Product catalog with search and filters
- Shopping cart with quantity controls
- Favorites/Save products
- Checkout with address and payment
- English/Arabic localization with RTL
- Bottom navigation (Home, Search, Cart, Favorites, Account)
- Hive local storage
- FakeStore API integration

## Translations

```dart
import 'package:fashion_ecommerce/core/utils/l10n.dart';

// Simple way
Text('login'.tr(context))

// Type-safe way
final s = context.s;
Text(s.login)
Text(s.email)
CustomButton(text: s.signUp)
```

## Type-Safe Assets

```dart
import 'package:fashion_ecommerce/gen/assets.gen.dart';

// Images
Assets.images.onboardingImage.image()
Assets.images.splashCenteredIcon.svg()

// Icons
Assets.icons.cashIcon.svg(width: 32, height: 32)
Assets.icons.visaCardIcon.svg()
```

## Custom TextField

```dart
CustomTextField(
  label: 'Email',
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  },
)
```

## Project Structure

```
lib/
├── core/
│   ├── config/         # Router, theme
│   ├── constants/      # Colors, dimensions
│   ├── utils/          # Localization (L10n class)
│   └── widgets/        # Reusable widgets
├── data/
│   ├── models/         # Hive models
│   ├── repositories/   # Data repositories
│   └── services/       # API, storage
├── features/
│   ├── auth/           # Login, signup
│   ├── cart/           # Shopping cart
│   ├── checkout/       # Checkout flow
│   ├── favorites/      # Saved products
│   ├── home/           # Product listing
│   ├── navigation/     # Bottom nav
│   ├── product/        # Product details
│   └── profile/        # User profile
└── main.dart
```

## Commands

```bash
# Code generation (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Code analysis
flutter analyze

# Format code
flutter format lib test
```

## Dependencies

**Core:**
- flutter_riverpod (state management)
- go_router (navigation)
- hive & hive_flutter (local storage)

**UI:**
- flutter_svg (SVG support)
- cached_network_image (image caching)
- flutter_gen (type-safe assets)

**API:**
- dio (HTTP client)

**Localization:**
- flutter_localizations (i18n)

## Troubleshooting

**Hive errors?**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Assets not found?**
```bash
dart run build_runner build --delete-conflicting-outputs
flutter clean
flutter pub get
```

**App not updating?**
- Use **full restart** (Shift + R), not hot reload

## Notes

- Hive adapters must be registered before use (see `main.dart`)
- Use L10n class (context.s) for translations instead of hardcoded strings
- All assets are type-safe via `flutter_gen`
- Cart uses VAT 5%
- Default locale: English (change in Profile → Language)

---

Built with Flutter & Clean Architecture
