# Flutter Gen Guide - Type-Safe Asset Access

## 🎯 What is Flutter Gen?

**flutter_gen** is a code generator that creates type-safe classes for your assets, eliminating string-based paths and enabling:
- ✅ **Compile-time safety** - Catch missing assets during build, not at runtime
- ✅ **Autocomplete** - IDE suggests all available assets
- ✅ **Refactoring support** - Rename detection works perfectly
- ✅ **Zero typos** - No more `"assets/icns/logo.png"` mistakes!

---

## 🚀 Quick Start

### Installation

Already included in `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_gen_runner: ^5.4.0
```

### Generate Assets

```bash
# Run code generation
dart run build_runner build --delete-conflicting-outputs
```

This creates `lib/gen/assets.gen.dart` with type-safe asset classes.

---

## 📖 Usage Examples

### Before (String Paths - ❌ Not Type-Safe)

```dart
// Typo-prone, no autocomplete, runtime errors
SvgPicture.asset('assets/icons/promo_code_icon.svg')
Image.asset('assets/images/onboarding_image.png')
```

### After (Flutter Gen - ✅ Type-Safe)

```dart
import 'package:fashion_ecommerce/gen/assets.gen.dart';

// Type-safe, autocomplete-enabled, compile-time checked!
Assets.icons.promoCodeIcon.svg()
Assets.images.onboardingImage.image()
```

---

## 🎨 Asset Types

### SVG Icons

```dart
import 'package:fashion_ecommerce/gen/assets.gen.dart';

// Basic usage
Assets.icons.cashIcon.svg()

// With size
Assets.icons.visaCardIcon.svg(
  width: 32,
  height: 32,
)

// With color filter
Assets.icons.promoCodeIcon.svg(
  width: 24,
  height: 24,
  colorFilter: ColorFilter.mode(
    Colors.blue,
    BlendMode.srcIn,
  ),
)

// All properties
Assets.icons.deleteIcon.svg(
  width: 20,
  height: 20,
  fit: BoxFit.contain,
  alignment: Alignment.center,
  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
)
```

### PNG/JPG Images

```dart
import 'package:fashion_ecommerce/gen/assets.gen.dart';

// Basic usage
Assets.images.onboardingImage.image()

// With fit mode
Assets.images.onboardingImage.image(
  fit: BoxFit.cover,
)

// With size
Assets.images.onboardingImage.image(
  width: 300,
  height: 300,
  fit: BoxFit.contain,
)

// All properties
Assets.images.onboardingImage.image(
  width: 400,
  height: 400,
  fit: BoxFit.cover,
  alignment: Alignment.center,
  color: Colors.black.withOpacity(0.5),
  colorBlendMode: BlendMode.darken,
)
```

### Get Asset Path (if needed)

```dart
// Get the path as string (for special cases)
String iconPath = Assets.icons.cashIcon.path;
// Returns: "assets/icons/cash_icon.svg"

String imagePath = Assets.images.onboardingImage.path;
// Returns: "assets/images/onboarding_image.png"
```

---

## 📁 Generated Structure

After running `dart run build_runner build`, you get:

```dart
// lib/gen/assets.gen.dart

class Assets {
  static const AssetGenImage images = AssetGenImage();
  static const AssetGenIcon icons = AssetGenIcon();
}

class AssetGenImage {
  const AssetGenImage();
  
  AssetGenImage get onboardingImage => 
    const AssetGenImage('assets/images/onboarding_image.png');
  
  AssetGenImage get splashCenteredIcon => 
    const AssetGenImage('assets/images/splash_centered_icon.svg');
}

class AssetGenIcon {
  const AssetGenIcon();
  
  SvgGenImage get cashIcon => 
    const SvgGenImage('assets/icons/cash_icon.svg');
  
  SvgGenImage get visaCardIcon => 
    const SvgGenImage('assets/icons/visa_card_icon.svg');
  
  SvgGenImage get promoCodeIcon => 
    const SvgGenImage('assets/icons/promo_code_icon.svg');
  
  // ... all other icons
}
```

---

## 🔄 File Naming Conventions

Flutter Gen converts file names to camelCase:

| File Name | Generated Name |
|-----------|---------------|
| `promo_code_icon.svg` | `promoCodeIcon` |
| `visa_card_icon.svg` | `visaCardIcon` |
| `onboarding_image.png` | `onboardingImage` |
| `splash_centered_icon.svg` | `splashCenteredIcon` |

---

## ⚙️ Configuration

In `pubspec.yaml`:

```yaml
flutter_gen:
  output: lib/gen/  # Where to generate files
  line_length: 80   # Code formatting

  integrations:
    flutter_svg: true  # Enable SVG support
    flare_flutter: false
    rive: false
    lottie: false
```

---

## 🎯 Real-World Examples from Our App

### Splash Screen

```dart
// Before
SvgPicture.asset(
  'assets/images/splash_centered_icon.svg',
  width: 200,
  height: 200,
)

// After
Assets.images.splashCenteredIcon.svg(
  width: 200,
  height: 200,
)
```

### Onboarding

```dart
// Before
Image.asset(
  'assets/images/onboarding_image.png',
  fit: BoxFit.contain,
)

// After
Assets.images.onboardingImage.image(
  fit: BoxFit.contain,
)
```

### Checkout Page

```dart
// Before
prefixIcon: Padding(
  padding: const EdgeInsets.all(12.0),
  child: SvgPicture.asset(
    'assets/icons/promo_code_icon.svg',
    width: 24,
    height: 24,
  ),
)

// After
prefixIcon: Padding(
  padding: const EdgeInsets.all(12.0),
  child: Assets.icons.promoCodeIcon.svg(
    width: 24,
    height: 24,
  ),
)
```

### Payment Selection

```dart
// Before
payment.type == PaymentType.cash
  ? SvgPicture.asset('assets/icons/cash_icon.svg')
  : SvgPicture.asset('assets/icons/visa_card_icon.svg')

// After
payment.type == PaymentType.cash
  ? Assets.icons.cashIcon.svg()
  : Assets.icons.visaCardIcon.svg()
```

---

## 🔍 IDE Support

### VS Code

Autocomplete works automatically:
```dart
Assets.icons.  // ← IDE shows all available icons!
```

### Android Studio / IntelliJ

Full autocomplete and navigation:
- Type `Assets.` to see all categories
- Ctrl+Click to navigate to asset
- Refactor → Rename updates all usages

---

## ➕ Adding New Assets

### Step 1: Add File

```bash
cp my_new_icon.svg assets/icons/
```

### Step 2: Regenerate

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 3: Use It!

```dart
Assets.icons.myNewIcon.svg()  // ← Autocomplete shows it!
```

---

## 🐛 Troubleshooting

### Error: "Undefined name 'Assets'"

**Cause:** Assets not generated yet.

**Solution:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Error: "The getter 'myIcon' isn't defined"

**Cause:** Asset file doesn't exist or not in correct folder.

**Solution:**
1. Check file exists in `assets/icons/` or `assets/images/`
2. Verify `pubspec.yaml` includes the asset directory
3. Run `flutter pub get`
4. Regenerate: `dart run build_runner build --delete-conflicting-outputs`

### Asset Not Showing in Autocomplete

**Solution:**
1. Ensure code generation completed successfully
2. Restart your IDE
3. Check `lib/gen/assets.gen.dart` was created

### Build Fails After Adding Asset

**Solution:**
```bash
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

---

## 📊 Benefits Summary

### Type Safety

```dart
// Before: Runtime error if typo
SvgPicture.asset('assets/icons/promo_cde_icon.svg')  // Typo!

// After: Compile error - catch immediately
Assets.icons.promoCdeIcon.svg()  // IDE shows error!
```

### Refactoring

```dart
// Rename promo_code_icon.svg → coupon_icon.svg

// Before: Must find/replace ALL string references
// After: Regenerate and IDE updates all usages automatically!
```

### Autocomplete

```dart
// Before: Need to remember exact path
'assets/icons/...'  // Which file was it?

// After: Just start typing
Assets.icons.  // IDE shows all 17 icons!
```

---

## 🎓 Best Practices

### 1. Always Import from gen/

```dart
// ✅ Good
import 'package:fashion_ecommerce/gen/assets.gen.dart';

// ❌ Bad - don't use string paths anymore
import 'package:flutter_svg/flutter_svg.dart';
SvgPicture.asset('assets/icons/...');
```

### 2. Use Asset Path Only When Necessary

```dart
// ✅ Good - use the widget method
Assets.icons.cashIcon.svg()

// ❌ Avoid - only use path if absolutely needed
SvgPicture.asset(Assets.icons.cashIcon.path)
```

### 3. Regenerate After Adding Assets

```bash
# Add new asset
cp new_icon.svg assets/icons/

# Immediately regenerate
dart run build_runner build --delete-conflicting-outputs
```

### 4. Commit Generated Files

```bash
# DO commit lib/gen/assets.gen.dart
git add lib/gen/
git commit -m "Add new assets"
```

---

## 📚 Advanced Usage

### Dynamic Asset Selection

```dart
SvgGenImage getPaymentIcon(PaymentType type) {
  switch (type) {
    case PaymentType.card:
      return Assets.icons.visaCardIcon;
    case PaymentType.cash:
      return Assets.icons.cashIcon;
    case PaymentType.applePay:
      return Assets.icons.applePayIcon;
  }
}

// Usage
getPaymentIcon(payment.type).svg(width: 32, height: 32)
```

### Create Asset Lists

```dart
final List<SvgGenImage> navigationIcons = [
  Assets.icons.selectedHomeIcon,
  Assets.icons.unselectedSearchIcon,
  Assets.icons.unselectedCardIcon,
  Assets.icons.unselectedAccountIcon,
  Assets.icons.unselectedSavesIcon,
];

// Use in loop
for (var icon in navigationIcons) {
  icon.svg(width: 24, height: 24)
}
```

### Asset Path Utilities

```dart
class AssetPaths {
  // Get all icon paths
  static List<String> getAllIconPaths() {
    return [
      Assets.icons.cashIcon.path,
      Assets.icons.visaCardIcon.path,
      Assets.icons.promoCodeIcon.path,
      // ... etc
    ];
  }
}
```

---

## 🔄 Migration Guide

### Migrating from String Paths

**Find and Replace Strategy:**

1. **Find:**
   ```dart
   SvgPicture.asset('assets/icons/cash_icon.svg'
   ```

2. **Replace:**
   ```dart
   Assets.icons.cashIcon.svg(
   ```

3. **Update imports:**
   ```dart
   // Remove
   import 'package:flutter_svg/flutter_svg.dart';
   
   // Add
   import 'package:fashion_ecommerce/gen/assets.gen.dart';
   ```

---

## 📦 Package Information

**Package:** flutter_gen  
**Version:** 5.4.0  
**Documentation:** https://pub.dev/packages/flutter_gen  
**GitHub:** https://github.com/FlutterGen/flutter_gen

---

## ✅ Checklist

Before committing code that uses assets:

- [ ] Ran `dart run build_runner build --delete-conflicting-outputs`
- [ ] Verified `lib/gen/assets.gen.dart` was generated
- [ ] Imported `assets.gen.dart` in files that need assets
- [ ] Used `Assets.icons.*` or `Assets.images.*` instead of strings
- [ ] Tested assets display correctly
- [ ] No linter errors
- [ ] Committed generated file

---

## 🎉 Summary

Flutter Gen makes asset management:
- ✅ **Safe** - No runtime errors from typos
- ✅ **Fast** - Autocomplete speeds up development
- ✅ **Maintainable** - Refactoring just works
- ✅ **Professional** - Industry best practice

**Never write asset paths as strings again!** 🚀
