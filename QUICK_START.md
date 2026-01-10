# Quick Start Guide

## ⚠️ Getting "Target of URI hasn't been generated" Error?

**This is normal for first-time setup!** You just need to run code generation:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- All required `.g.dart` files (Hive adapters)
- `assets.gen.dart` file (type-safe asset access)

**Note:** Use `dart run` (not `flutter pub run`) for better performance.

---

## 🚀 Run the App in 3 Minutes

### Step 1: Install Dependencies (1 min)
```bash
cd /Users/hussamelmaghraby/Data/Projects/SELF/fashion_ecommerce
flutter pub get
```

**Expected output:**
```
Running "flutter pub get" in fashion_ecommerce...
Got dependencies!
```

### Step 2: Generate Code (1 min) ⚠️ REQUIRED!
```bash
dart run build_runner build --delete-conflicting-outputs
```

**What this does:**
- Generates **Hive type adapters** (*.g.dart files)
- Generates **Asset classes** (assets.gen.dart) - Type-safe asset access!
- Creates serialization code for data models
- Required for the app to compile and run

**Expected output:**
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 1.2s
[INFO] Creating build script snapshot...
[INFO] Creating build script snapshot completed, took 2.3s
[INFO] Running build...
[INFO] Running build completed, took 4.5s
[INFO] Succeeded after 8.1s with 18 outputs
```

**Verify generation:**
```bash
ls lib/data/models/*.g.dart
ls lib/gen/assets.gen.dart
```

**You should see:**
```
lib/data/models/address_model.g.dart
lib/data/models/cart_item_model.g.dart
lib/data/models/payment_method_model.g.dart
lib/data/models/product_model.g.dart
lib/data/models/user_model.g.dart
lib/gen/assets.gen.dart  ← NEW! Type-safe assets
```

### Step 3: Run the App (30 seconds)
```bash
flutter run
```

**Select your device when prompted:**
- Press `1` for iOS Simulator
- Press `2` for Android Emulator
- Press `3` for Chrome (web)

**Expected output:**
```
Launching lib/main.dart on iPhone 15 in debug mode...
Running Xcode build...
✓ Built build/ios/iphonesimulator/Runner.app
To hot restart changes while running, press "r" or "R".
```

---

## 🧪 Test the App

### Test Credentials:
- **Email:** `test@example.com` (or any valid email)
- **Password:** `test123` (minimum 6 characters)
- **Coupon Code:** `SAVE10` (gets 10% discount)

### Test Flow:
1. **Onboarding:** Skip or go through 3 slides
2. **Sign Up:** Create account with any valid email
3. **Login:** Use same credentials
4. **Browse Products:** Search "shirt" or filter by "electronics"
5. **Product Details:** Select size M, color Black, quantity 2
6. **Add to Cart:** View cart with 2 items
7. **Checkout:** Apply coupon `SAVE10`, see discount
8. **Add Address:** Fill in test address details
9. **Payment:** Select "Cash on Delivery" or add test card
10. **Place Order:** Confirm and see success message

---

## 📱 Available Features

### ✅ Working Features:
- ✓ Product listing from FakeStoreAPI
- ✓ Product search and filtering
- ✓ Cart with persistent storage
- ✓ Address management
- ✓ Payment method management
- ✓ Coupon code application
- ✓ Form validation
- ✓ Error handling
- ✓ Loading states
- ✓ Empty states

### 🎨 UI Features:
- ✓ Smooth animations
- ✓ Material Design 3
- ✓ Pull to refresh
- ✓ Image caching
- ✓ Responsive design

### 🌍 Localization:
- ✓ English (default)
- ✓ Arabic with RTL support

---

## 🧪 Run Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widgets/custom_button_test.dart

# Run with coverage
flutter test --coverage
```

**Expected result:** All tests should pass ✓

---

## 🔍 Verify Code Quality

```bash
# Check for errors
flutter analyze

# Format code
flutter format lib test
```

**Expected result:** No issues found

---

## 🏗️ Build APK

```bash
# Build release APK
flutter build apk --release

# Find APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

**APK size:** ~20-30 MB

---

## 🎬 Record Demo

### iOS:
```bash
# Start recording
xcrun simctl io booted recordVideo --codec=h264 demo.mov

# Navigate through the app (2-3 minutes)
# Press Ctrl+C to stop
```

### Android:
```bash
# Start recording
adb shell screenrecord /sdcard/demo.mp4

# Navigate through the app (max 3 minutes)
# Press Ctrl+C to stop

# Pull file
adb pull /sdcard/demo.mp4
```

---

## 🐛 Common Issues & Solutions

### Issue 1: "Hive not initialized"
```bash
# Uncomment this line in main.dart:
await StorageService.init();
```

### Issue 2: "Build errors"
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 3: "No devices found"
```bash
# iOS: Open Simulator first
open -a Simulator

# Android: Start emulator
flutter emulators --launch <emulator_id>
```

### Issue 4: "Tests failing"
```bash
# Make sure build_runner completed
flutter pub run build_runner build --delete-conflicting-outputs

# Then run tests
flutter test
```

---

## 📊 Project Stats

- **Total Files:** 60+ Dart files
- **Lines of Code:** ~5,000+ lines
- **Screens:** 10 complete screens
- **Tests:** 12 test cases
- **Dependencies:** 20+ packages
- **Development Time:** ~6 hours

---

## 🎯 What to Demo in Video

### Must Show (2 min):
1. Onboarding flow (10s)
2. Sign up & login (20s)
3. Product browsing & search (20s)
4. Product details & add to cart (20s)
5. Cart & checkout (30s)
6. Address & payment (20s)
7. Place order success (10s)

### Nice to Show (1 min):
- Search functionality
- Category filtering
- Quantity updates
- Coupon code working
- Empty states
- Error handling
- Arabic localization

---

## 📞 Need Help?

Check these files:
- `README.md` - Complete documentation
- `SUBMISSION_GUIDE.md` - Submission steps
- `IMPLEMENTATION_NOTES.md` - Technical details

---

**You're all set! Good luck! 🎉**
