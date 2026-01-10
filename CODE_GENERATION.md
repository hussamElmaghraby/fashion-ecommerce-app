# Code Generation Documentation

## 📘 Overview

This project uses **build_runner** for automatic code generation. This is essential for:
- **Hive Type Adapters** - Database serialization
- **JSON Serialization** - API data models
- **Riverpod Providers** - State management (if using code gen)

---

## 🚀 Quick Start

### First-Time Setup
```bash
# 1. Install dependencies
flutter pub get

# 2. Generate all code (REQUIRED!)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Verify generation succeeded
ls lib/data/models/*.g.dart
```

**Expected Output:**
```
lib/data/models/address_model.g.dart
lib/data/models/cart_item_model.g.dart
lib/data/models/payment_method_model.g.dart
lib/data/models/product_model.g.dart
lib/data/models/user_model.g.dart
```

---

## 📋 When to Run Code Generation

### Always Run After:
- ✅ **First clone** of the repository
- ✅ **Adding new** Hive models
- ✅ **Modifying** existing models with Hive annotations
- ✅ **Git pull** with model changes
- ✅ **Seeing errors** about missing `.g.dart` files

### No Need to Run After:
- ❌ UI-only changes
- ❌ Adding new screens without models
- ❌ Modifying existing screens
- ❌ Changing colors/constants

---

## 🔧 Code Generation Commands

### Standard Build
```bash
flutter pub run build_runner build
```
- Generates all files
- Stops if conflicts detected
- Safe for production

### Force Build (Recommended)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
- Generates all files
- Deletes conflicting files automatically
- **Use this command 99% of the time**

### Watch Mode (Development)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```
- Auto-regenerates on file save
- Great for active development
- Keeps running in background
- **Press Ctrl+C to stop**

### Clean and Rebuild
```bash
# Option 1: Clean generated files
flutter pub run build_runner clean

# Option 2: Manual cleanup
rm -rf lib/**/*.g.dart

# Then rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📁 Generated Files

### Hive Type Adapters

**What are they?**
Hive needs type adapters to serialize/deserialize custom objects. The `@HiveType` annotation triggers generation.

**Location:** `lib/data/models/*.g.dart`

**Example:**
```dart
// Source: product_model.dart
@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  // ... more fields
}

// Generated: product_model.g.dart
class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    // Deserialization code
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    // Serialization code
  }
}
```

### Current Generated Files

| Source File | Generated File | Purpose |
|------------|----------------|---------|
| `product_model.dart` | `product_model.g.dart` | Product & Rating adapters |
| `cart_item_model.dart` | `cart_item_model.g.dart` | Cart item adapter |
| `address_model.dart` | `address_model.g.dart` | Address adapter |
| `payment_method_model.dart` | `payment_method_model.g.dart` | Payment method adapter |
| `user_model.dart` | `user_model.g.dart` | User adapter |

---

## 🎯 How It Works

### 1. Source Code with Annotations
```dart
import 'package:hive/hive.dart';

part 'product_model.g.dart';  // Points to generated file

@HiveType(typeId: 0)  // Triggers code generation
class ProductModel {
  @HiveField(0)
  final int id;
  
  ProductModel({required this.id});
}
```

### 2. Build Runner Scans
```bash
flutter pub run build_runner build
```
- Scans all `.dart` files
- Finds `@HiveType` annotations
- Finds `part` directives
- Generates adapter code

### 3. Generated File
```dart
// product_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;
  
  // Generated serialization code...
}
```

### 4. Registration
```dart
// In main.dart or storage_service.dart
void registerAdapters() {
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
  // ... etc
}
```

---

## 🐛 Common Errors & Solutions

### Error 1: "Target of URI hasn't been generated"
```
Error: Target of URI hasn't been generated: 'package:fashion_ecommerce/data/models/address_model.g.dart'
```

**Cause:** Generated files don't exist yet.

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Error 2: "Conflicting outputs"
```
[WARNING] Conflicting outputs were detected and the build is unable to prompt for permission to remove them.
```

**Cause:** Old generated files conflict with new ones.

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Error 3: "part of uses an unknown file"
```
Error: This part doesn't have a containing library.
```

**Cause:** Missing `part 'file_name.g.dart';` directive.

**Solution:** Add to top of source file:
```dart
part 'product_model.g.dart';
```

---

### Error 4: "No builders found"
```
Error: No builders found
```

**Cause:** Missing dev dependencies.

**Solution:**
```bash
flutter pub add --dev build_runner
flutter pub add --dev hive_generator
flutter pub get
```

---

### Error 5: Build takes too long
**Solution:** Use watch mode:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📊 Build Output Explained

### Successful Build
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 1.2s

[INFO] Creating build script snapshot...  
[INFO] Creating build script snapshot completed, took 2.3s

[INFO] Running build...
[INFO] Running build completed, took 4.5s

[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 0.1s

[INFO] Succeeded after 8.1s with 12 outputs (15 actions)
```

**What this means:**
- ✅ 12 files generated successfully
- ✅ 15 actions performed
- ✅ Completed in 8.1 seconds
- ✅ Ready to run the app!

### Build with Warnings
```
[WARNING] Conflicting outputs were detected...
[INFO] Deleting 5 conflicting outputs...
[INFO] Succeeded after 10.2s with 12 outputs
```

**What this means:**
- ⚠️ Had to delete old files
- ✅ Successfully regenerated
- ✅ Safe to proceed

### Build Failed
```
[SEVERE] Error running build:
[SEVERE] hive_generator:hive_generator on lib/data/models/product_model.dart:
Build failed with exception
```

**What to do:**
1. Check the error message
2. Fix the issue in source file
3. Run build again
4. See troubleshooting section

---

## 🔄 Development Workflow

### Option 1: Manual Build (Stable)
```bash
# Make changes to model
vim lib/data/models/product_model.dart

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### Option 2: Watch Mode (Fast)
```bash
# Start watch mode (in separate terminal)
flutter pub run build_runner watch --delete-conflicting-outputs

# In another terminal
flutter run

# Now every save auto-regenerates!
```

### Recommended Workflow
```bash
# Terminal 1: Watch mode
flutter pub run build_runner watch

# Terminal 2: Run app with hot reload
flutter run

# Now you have:
# ✅ Auto code generation on save
# ✅ Hot reload on save
# ✅ Fast development cycle!
```

---

## 📝 Best Practices

### DO ✅
- Run code generation before first run
- Use `--delete-conflicting-outputs` flag
- Use watch mode during active development
- Commit generated files to Git
- Add `.dart_tool/` to `.gitignore`
- Document custom generators in README

### DON'T ❌
- Don't edit `.g.dart` files manually
- Don't delete `part` directives
- Don't forget to run after pulling changes
- Don't commit without running generation
- Don't skip generation in CI/CD

---

## 🚀 CI/CD Integration

### GitHub Actions Example
```yaml
name: Build & Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Analyze
        run: flutter analyze
      
      - name: Test
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
```

---

## 📚 Additional Resources

- [build_runner documentation](https://pub.dev/packages/build_runner)
- [hive_generator documentation](https://pub.dev/packages/hive_generator)
- [json_serializable documentation](https://pub.dev/packages/json_serializable)
- [Flutter code generation guide](https://flutter.dev/docs/development/data-and-backend/json#code-generation)

---

## 🆘 Still Having Issues?

1. **Clean everything:**
   ```bash
   flutter clean
   rm -rf .dart_tool
   rm -rf lib/**/*.g.dart
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Check dependencies:**
   ```bash
   flutter pub outdated
   flutter pub upgrade
   ```

3. **Verify build_runner version:**
   ```bash
   flutter pub deps | grep build_runner
   ```

4. **Check for conflicting packages:**
   ```bash
   flutter pub deps
   ```

5. **Run with verbose output:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs --verbose
   ```

---

## ✅ Checklist Before Committing

- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Verify all `.g.dart` files exist
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (all pass)
- [ ] Commit both source and generated files
- [ ] Update documentation if models changed

---

**Remember:** When in doubt, regenerate! It's quick and safe. 🚀
