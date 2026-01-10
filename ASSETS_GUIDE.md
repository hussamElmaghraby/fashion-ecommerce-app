# Assets Guide

## 📁 Asset Structure

```
assets/
├── icons/               # 17 SVG icons
│   ├── apple_pay_icon.svg
│   ├── cash_icon.svg
│   ├── delete_icon.svg
│   ├── edit_payment_icon.svg
│   ├── error_validation_icon.svg
│   ├── notifications_icon.svg
│   ├── promo_code_icon.svg
│   ├── selected_card_icon.svg
│   ├── selected_home_icon.svg
│   ├── success_bottom_sheet_icon.svg
│   ├── success_validation_icon.svg
│   ├── unselected_account_icon.svg
│   ├── unselected_card_icon.svg
│   ├── unselected_save_icon.svg
│   ├── unselected_saves_icon.svg
│   ├── unselected_search_icon.svg
│   └── visa_card_icon.svg
├── images/              # PNG/SVG images
│   ├── onboarding_image.png
│   └── splash_centered_icon.svg
└── translations/        # Localization files
    ├── ar.json
    └── en.json
```

---

## 🎨 Icons Reference

### Navigation Icons

| Icon | File | Usage | Where Used |
|------|------|-------|------------|
| 🏠 Home | `selected_home_icon.svg` | Bottom nav - selected | Home tab |
| 🔍 Search | `unselected_search_icon.svg` | Bottom nav | Search tab |
| 🛒 Cart | `unselected_card_icon.svg` | Bottom nav | Cart tab |
| 👤 Account | `unselected_account_icon.svg` | Bottom nav | Profile tab |
| 💾 Saves | `unselected_saves_icon.svg` | Bottom nav | Favorites tab |
| 💾 Save | `unselected_save_icon.svg` | Product save button | Product details |

### Payment Icons

| Icon | File | Usage | Where Used |
|------|------|-------|------------|
| 💳 Visa Card | `visa_card_icon.svg` | Credit/debit card | Payment methods |
| 🍎 Apple Pay | `apple_pay_icon.svg` | Apple Pay option | Payment methods |
| 💵 Cash | `cash_icon.svg` | Cash on delivery | Payment methods |

### Action Icons

| Icon | File | Usage | Where Used |
|------|------|-------|------------|
| 🗑️ Delete | `delete_icon.svg` | Remove item | Cart, addresses |
| ✏️ Edit | `edit_payment_icon.svg` | Edit payment | Payment methods |
| 🎟️ Promo Code | `promo_code_icon.svg` | Coupon input | Checkout page |
| 🔔 Notifications | `notifications_icon.svg` | Alerts | App bar |

### Validation Icons

| Icon | File | Usage | Where Used |
|------|------|-------|------------|
| ✅ Success | `success_validation_icon.svg` | Valid input | Form validation |
| ✅ Success Sheet | `success_bottom_sheet_icon.svg` | Success message | Order confirmation |
| ❌ Error | `error_validation_icon.svg` | Invalid input | Form validation |

### Selection Indicators

| Icon | File | Usage | Where Used |
|------|------|-------|------------|
| ✓ Selected Card | `selected_card_icon.svg` | Selected payment | Payment selection |

---

## 🖼️ Images Reference

### Onboarding

**File:** `onboarding_image.png`
- **Type:** PNG
- **Usage:** Main illustration for onboarding screens
- **Dimensions:** 300x300 (displayed)
- **Where:** `lib/features/onboarding/presentation/pages/onboarding_page.dart`

**Code:**
```dart
Image.asset(
  'assets/images/onboarding_image.png',
  width: 300,
  height: 300,
  fit: BoxFit.contain,
)
```

### Splash Screen

**File:** `splash_centered_icon.svg`
- **Type:** SVG
- **Usage:** App logo on splash screen
- **Dimensions:** 200x200 (displayed)
- **Where:** `lib/features/onboarding/presentation/pages/splash_page.dart`
- **Animation:** Fade + Scale animation (1.5s)

**Code:**
```dart
SvgPicture.asset(
  'assets/images/splash_centered_icon.svg',
  width: 200,
  height: 200,
)
```

---

## 🌍 Translations

### English (`en.json`)

Sample structure:
```json
{
  "app_name": "Fashion Store",
  "onboarding_title_1": "Discover Fashion",
  "onboarding_desc_1": "Explore the latest trends...",
  "login": "Login",
  "email": "Email",
  "password": "Password"
}
```

### Arabic (`ar.json`)

Sample structure (with RTL support):
```json
{
  "app_name": "متجر الأزياء",
  "onboarding_title_1": "اكتشف الموضة",
  "onboarding_desc_1": "استكشف أحدث الصيحات...",
  "login": "تسجيل الدخول",
  "email": "البريد الإلكتروني",
  "password": "كلمة المرور"
}
```

**Usage:**
```dart
import 'core/utils/app_localizations.dart';

final localizations = AppLocalizations(Locale('en'));
final text = localizations.translate('app_name');
```

---

## 📝 How to Use Assets

### 1. Using SVG Icons

**Import:**
```dart
import 'package:flutter_svg/flutter_svg.dart';
```

**Basic Usage:**
```dart
SvgPicture.asset(
  'assets/icons/promo_code_icon.svg',
  width: 24,
  height: 24,
)
```

**With Color:**
```dart
SvgPicture.asset(
  'assets/icons/promo_code_icon.svg',
  width: 24,
  height: 24,
  colorFilter: ColorFilter.mode(
    Colors.blue,
    BlendMode.srcIn,
  ),
)
```

**In Icon Widget:**
```dart
prefixIcon: Padding(
  padding: const EdgeInsets.all(12.0),
  child: SvgPicture.asset(
    'assets/icons/promo_code_icon.svg',
    width: 24,
    height: 24,
  ),
)
```

### 2. Using PNG Images

**Basic Usage:**
```dart
Image.asset(
  'assets/images/onboarding_image.png',
  fit: BoxFit.contain,
)
```

**With Size:**
```dart
Image.asset(
  'assets/images/onboarding_image.png',
  width: 300,
  height: 300,
  fit: BoxFit.cover,
)
```

### 3. Using Translations

**Setup:**
```dart
import 'core/utils/app_localizations.dart';

// In your widget
final localizations = AppLocalizations(
  Localizations.localeOf(context)
);

// Use translation
Text(localizations.translate('app_name'))
```

---

## ➕ Adding New Assets

### Step 1: Add File to Project

```bash
# Copy icon to icons folder
cp my_new_icon.svg assets/icons/

# Copy image to images folder
cp my_image.png assets/images/
```

### Step 2: Verify pubspec.yaml

Ensure the asset directories are declared:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/translations/
```

### Step 3: Refresh Assets

```bash
# Get packages to refresh asset bundle
flutter pub get

# Hot restart (not hot reload!) to load new assets
# Press 'R' in terminal or restart from IDE
```

### Step 4: Use in Code

```dart
// For new icon
SvgPicture.asset('assets/icons/my_new_icon.svg')

// For new image
Image.asset('assets/images/my_image.png')
```

---

## 🎨 Design Guidelines

### Icon Guidelines

- **Format:** SVG (vector, scalable)
- **Size:** 24x24dp base size
- **Color:** Single color or transparent
- **Style:** Consistent line weight
- **Naming:** `{name}_{type}_icon.svg`

### Image Guidelines

- **Format:** PNG or SVG
- **Resolution:** 2x or 3x for PNG
- **Optimization:** Compress before adding
- **Naming:** `{screen}_{purpose}.{ext}`

### Translation Guidelines

- **Format:** JSON
- **Encoding:** UTF-8
- **Keys:** `snake_case`
- **Structure:** Flat or nested by feature

---

## 🔧 Asset Configuration

### pubspec.yaml Setup

```yaml
flutter:
  uses-material-design: true
  
  assets:
    # Images folder (includes all files)
    - assets/images/
    
    # Icons folder (includes all SVG files)
    - assets/icons/
    
    # Translations (JSON files)
    - assets/translations/
    
  fonts:
    - family: YourCustomFont
      fonts:
        - asset: assets/fonts/YourFont-Regular.ttf
        - asset: assets/fonts/YourFont-Bold.ttf
          weight: 700
```

---

## 🐛 Troubleshooting

### Asset Not Found

**Error:** `Unable to load asset: assets/icons/my_icon.svg`

**Solutions:**
1. Check file path is correct
2. Verify `pubspec.yaml` includes the directory
3. Run `flutter pub get`
4. Hot **restart** (not hot reload)
5. Check file name spelling and case

### SVG Not Rendering

**Error:** Icon shows as blank or error

**Solutions:**
1. Verify SVG is valid (open in browser/editor)
2. Simplify SVG (remove complex gradients)
3. Use `flutter_svg` package
4. Check console for specific error

### Image Quality Issues

**Solutions:**
1. Use higher resolution (2x, 3x)
2. Use vector format (SVG) when possible
3. Compress images without losing quality
4. Use appropriate fit mode (cover, contain, etc.)

### Translation Not Working

**Solutions:**
1. Verify JSON is valid (no syntax errors)
2. Check locale is correctly set
3. Ensure key exists in JSON file
4. Rebuild app after changing translations

---

## 📊 Asset Usage Map

### Where Each Asset is Used

**Splash Screen:**
- `splash_centered_icon.svg` - Logo

**Onboarding:**
- `onboarding_image.png` - Main illustration

**Payment Pages:**
- `visa_card_icon.svg` - Card payment option
- `cash_icon.svg` - Cash payment option
- `apple_pay_icon.svg` - Apple Pay option (future)

**Checkout:**
- `promo_code_icon.svg` - Coupon input field

**Forms:**
- `success_validation_icon.svg` - Valid field indicator
- `error_validation_icon.svg` - Error field indicator

**Bottom Navigation (Future Enhancement):**
- `selected_home_icon.svg`
- `unselected_search_icon.svg`
- `unselected_card_icon.svg`
- `unselected_account_icon.svg`
- `unselected_saves_icon.svg`

---

## ✅ Asset Checklist

Before committing new assets:

- [ ] File is in correct folder
- [ ] File name follows naming convention
- [ ] File is optimized/compressed
- [ ] SVG is simplified (no complex features)
- [ ] Asset directory in `pubspec.yaml`
- [ ] Tested on both iOS and Android
- [ ] Tested in light and dark themes (if applicable)
- [ ] Used in code with proper error handling
- [ ] Documented in this file

---

## 📱 Performance Tips

1. **Use SVG for Icons**
   - Scalable without quality loss
   - Smaller file size
   - Color customizable

2. **Optimize PNG Images**
   - Use tools like TinyPNG
   - Provide 2x and 3x variants
   - Use appropriate resolution

3. **Lazy Load Large Images**
   ```dart
   CachedNetworkImage(
     imageUrl: url,
     placeholder: (context, url) => CircularProgressIndicator(),
   )
   ```

4. **Preload Critical Assets**
   ```dart
   Future<void> precacheAssets(BuildContext context) async {
     await precacheImage(
       AssetImage('assets/images/splash_logo.png'),
       context,
     );
   }
   ```

---

**Last Updated:** January 2026
**Asset Count:** 19 files (17 icons, 2 images, 2 translations)
