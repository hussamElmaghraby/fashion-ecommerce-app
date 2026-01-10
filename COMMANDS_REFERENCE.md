# Complete Commands Reference

## 🎯 Essential Commands (Copy & Paste)

### First-Time Setup
```bash
# Navigate to project
cd /Users/hussamelmaghraby/Data/Projects/SELF/fashion_ecommerce

# Install dependencies
flutter pub get

# Generate code (REQUIRED!)
flutter pub run build_runner build --delete-conflicting-outputs

# Verify generation
ls lib/data/models/*.g.dart

# Run the app
flutter run
```

---

## 📱 Running the App

### Run on Simulator/Emulator
```bash
flutter run
```

### Run on Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Examples:
flutter run -d chrome          # Web
flutter run -d emulator-5554   # Android
flutter run -d iPhone          # iOS
```

### Run with Options
```bash
# Release mode
flutter run --release

# Profile mode (performance profiling)
flutter run --profile

# Debug mode with hot reload (default)
flutter run
```

---

## 🔨 Code Generation

### Standard Commands
```bash
# One-time build
flutter pub run build_runner build

# Build with auto-delete conflicts (recommended)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on save)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

### When to Run
```bash
# After git pull
git pull
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# After adding new model
vim lib/data/models/new_model.dart
flutter pub run build_runner build --delete-conflicting-outputs

# When seeing "URI not generated" error
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widgets/custom_button_test.dart

# With coverage
flutter test --coverage

# Verbose output
flutter test --verbose

# Watch mode (re-run on changes)
flutter test --watch
```

### Test Reports
```bash
# Generate HTML coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

---

## 🔍 Code Quality

### Analysis
```bash
# Check for issues
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Check specific directory
flutter analyze lib/
```

### Formatting
```bash
# Format all files
flutter format lib test

# Format and fail if changes needed (CI/CD)
flutter format --set-exit-if-changed lib test

# Format specific file
flutter format lib/main.dart
```

### Linting
```bash
# Run custom lint rules (if configured)
dart run custom_lint
```

---

## 🏗️ Building

### Android
```bash
# Build APK (debug)
flutter build apk

# Build APK (release)
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build specific flavor
flutter build apk --flavor production --release

# Build for specific architecture
flutter build apk --target-platform android-arm64 --release
```

### iOS (macOS only)
```bash
# Build for simulator
flutter build ios --simulator

# Build for device (release)
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release

# Clean iOS build
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
```

### Web
```bash
# Build web app
flutter build web

# Build with specific renderer
flutter build web --web-renderer canvaskit  # Better performance
flutter build web --web-renderer html       # Smaller size

# Build with base href
flutter build web --base-href /my-app/
```

### All Platforms
```bash
# Clean all builds
flutter clean

# Clean and rebuild
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📦 Dependencies

### Managing Dependencies
```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Update specific package
flutter pub upgrade package_name

# Outdated packages
flutter pub outdated

# Add dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Remove dependency
flutter pub remove package_name
```

### Cache Management
```bash
# Clear pub cache
flutter pub cache clean

# Repair pub cache
flutter pub cache repair

# Clean dart tool
rm -rf .dart_tool
```

---

## 🐛 Debugging

### Flutter Doctor
```bash
# Check Flutter installation
flutter doctor

# Verbose output
flutter doctor -v

# Check specific component
flutter doctor --android-licenses
```

### Device Management
```bash
# List devices
flutter devices

# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Create emulator
flutter emulators --create
```

### Logs
```bash
# View logs while running
flutter logs

# Clear logs
flutter logs --clear

# Device logs (Android)
adb logcat

# Device logs (iOS)
idevicesyslog  # Requires libimobiledevice
```

---

## 🧹 Cleaning

### Clean Commands
```bash
# Clean build artifacts
flutter clean

# Clean generated files
flutter pub run build_runner clean

# Clean everything
flutter clean && rm -rf .dart_tool && rm -rf pubspec.lock

# Deep clean (nuclear option)
flutter clean
rm -rf .dart_tool
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf android/.gradle
rm -rf build
rm -rf lib/**/*.g.dart
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔄 Git Workflow

### After Git Pull
```bash
git pull
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Before Commit
```bash
# Format code
flutter format lib test

# Analyze code
flutter analyze

# Run tests
flutter test

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Commit
git add .
git commit -m "Your message"
git push
```

---

## 🚀 Performance

### Profile Build
```bash
# Build with performance profiling
flutter build apk --profile

# Run in profile mode
flutter run --profile

# Analyze performance
flutter run --profile --trace-startup
```

### Size Analysis
```bash
# Analyze APK size
flutter build apk --analyze-size --target-platform android-arm64

# Analyze bundle size
flutter build appbundle --analyze-size
```

---

## 📊 Useful Combinations

### Complete Clean Build
```bash
flutter clean && \
rm -rf .dart_tool && \
flutter pub get && \
flutter pub run build_runner build --delete-conflicting-outputs && \
flutter analyze && \
flutter test && \
flutter run
```

### Quick Rebuild
```bash
flutter pub run build_runner build --delete-conflicting-outputs && flutter run
```

### Pre-Commit Check
```bash
flutter format lib test && \
flutter analyze && \
flutter test && \
echo "✅ All checks passed!"
```

### Production Build (Android)
```bash
flutter clean && \
flutter pub get && \
flutter pub run build_runner build --delete-conflicting-outputs && \
flutter test && \
flutter build apk --release && \
echo "✅ APK ready at: build/app/outputs/flutter-apk/app-release.apk"
```

---

## 🆘 Emergency Commands

### App Won't Build
```bash
# Try this sequence:
flutter clean
rm -rf .dart_tool
rm -rf pubspec.lock
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Build Runner Issues
```bash
# Force rebuild everything:
flutter pub run build_runner clean
rm -rf lib/**/*.g.dart
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs --verbose
```

### Dependency Hell
```bash
# Nuclear option:
flutter clean
rm -rf .dart_tool
rm -rf pubspec.lock
flutter pub cache clean
flutter pub get
flutter pub upgrade
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📝 Quick Reference Table

| Task | Command |
|------|---------|
| Install dependencies | `flutter pub get` |
| Generate code | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Run app | `flutter run` |
| Run tests | `flutter test` |
| Format code | `flutter format lib test` |
| Analyze code | `flutter analyze` |
| Build APK | `flutter build apk --release` |
| Clean build | `flutter clean` |
| Update deps | `flutter pub upgrade` |
| View devices | `flutter devices` |

---

## 💡 Pro Tips

1. **Use Watch Mode During Development**
   ```bash
   # Terminal 1:
   flutter pub run build_runner watch --delete-conflicting-outputs
   
   # Terminal 2:
   flutter run
   ```

2. **Create Shell Aliases**
   ```bash
   # Add to ~/.zshrc or ~/.bashrc:
   alias fclean='flutter clean'
   alias fget='flutter pub get'
   alias fgen='flutter pub run build_runner build --delete-conflicting-outputs'
   alias frun='flutter run'
   alias ftest='flutter test'
   alias frebuild='fclean && fget && fgen && frun'
   ```

3. **Use Scripts**
   Create `scripts/setup.sh`:
   ```bash
   #!/bin/bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter analyze
   flutter test
   echo "✅ Setup complete!"
   ```

---

**Remember:** When in doubt, clean and rebuild! 🚀
