# 🌍 Translation Usage Guide - S Class

## ✨ New S Class for Easy Translations

I've created a powerful S class that gives you **5 different ways** to use translations!

## 📦 What's New

### File Created
- ✅ `lib/core/utils/s.dart` - Translation utilities

## 🚀 5 Ways to Use Translations

### Method 1: String Extension (Recommended ⭐)
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Simple and clean!
Text('login'.tr(context))
Text('email'.tr(context))
Text('password'.tr(context))
```

### Method 2: Context Extension
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Use context directly
Text(context.tr('login'))
Text(context.tr('email'))
Text(context.tr('password'))
```

### Method 3: S Instance
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Get S instance
final s = S.of(context);
Text(s.translate('login'))
```

### Method 4: S Getters (Type-Safe ⭐⭐)
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Use predefined getters - autocomplete works!
final s = context.s;
Text(s.login)
Text(s.email)
Text(s.password)
Text(s.myCart)
Text(s.checkout)
```

### Method 5: Context Property Shortcut
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Quick access via context
final s = context.s;
Text(s.addToCart)
Text(s.placeOrder)
```

## 📝 Complete Examples

### Example 1: Login Button (CustomButton)
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Old way:
CustomButton(
  text: 'Login',
  onPressed: () {},
)

// New way - String extension:
CustomButton(
  text: 'login'.tr(context),
  onPressed: () {},
)

// New way - S getters:
CustomButton(
  text: context.s.login,
  onPressed: () {},
)
```

### Example 2: Form Fields
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

CustomTextField(
  label: 'email'.tr(context),
  hintText: 'enter_your_email'.tr(context),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr(context);
    }
    return null;
  },
)

// OR using getters:
final s = context.s;
CustomTextField(
  label: s.email,
  hintText: s.enterYourEmail,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return s.fieldRequired;
    }
    return null;
  },
)
```

### Example 3: AppBar Title
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

AppBar(
  title: Text('my_cart'.tr(context)),
)

// OR:
AppBar(
  title: Text(context.s.myCart),
)
```

### Example 4: StatelessWidget
```dart
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/core/utils/s.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get S instance once
    final s = context.s;
    
    return Column(
      children: [
        Text(s.welcome),      // Using getters
        Text(s.signIn),
        CustomButton(
          text: s.login,      // Type-safe!
          onPressed: () {},
        ),
      ],
    );
  }
}
```

### Example 5: Snackbar Messages
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('password_changed_successfully'.tr(context)),
  ),
);
```

### Example 6: Dialog
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

showDialog(
  context: context,
  builder: (context) {
    final s = context.s;
    return AlertDialog(
      title: Text(s.logout),
      content: Text(s.logoutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        TextButton(
          onPressed: () {
            // Logout logic
          },
          child: Text(s.logout),
        ),
      ],
    );
  },
);
```

## 🎯 Utility Extensions

### Check Current Language
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

final languageCode = context.languageCode; // 'en' or 'ar'

if (context.languageCode == 'ar') {
  print('Arabic is active');
}
```

### Check RTL
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

if (context.isRTL) {
  // Apply RTL-specific logic
  print('Layout is right-to-left');
}
```

### Get S Instance Anywhere
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

Widget myMethod(BuildContext context) {
  final s = S.of(context);
  return Text(s.myCart);
}
```

## 📋 Available S Getters

All common translations are available as getters:

```dart
final s = context.s;

// Auth
s.login
s.signIn
s.signUp
s.email
s.password
s.confirmPassword
s.forgotPassword
s.resetPassword
s.createAccount
s.alreadyHaveAccount
s.dontHaveAccount

// Profile
s.account
s.editProfile
s.addresses
s.paymentMethods
s.notifications
s.language
s.logout

// Shopping
s.myCart
s.addToCart
s.checkout
s.placeOrder
s.total
s.searchProducts
s.discover

// Common
s.appName
s.skip
s.next
s.getStarted
s.cancel
s.fieldRequired
s.invalidEmail
```

## 🔄 Migration Examples

### Before (Old Way):
```dart
import '../core/constants/app_strings.dart';

Text(AppStrings.login),
CustomButton(text: AppStrings.signUp),
```

### After (New Way):
```dart
import 'package:fashion_ecommerce/core/utils/s.dart';

// Option 1 - String extension:
Text('login'.tr(context)),
CustomButton(text: 'sign_up'.tr(context)),

// Option 2 - S getters (recommended):
final s = context.s;
Text(s.login),
CustomButton(text: s.signUp),
```

## 🎨 Best Practices

### ✅ DO: Use String Extension for Simple Cases
```dart
Text('login'.tr(context))
```

### ✅ DO: Use S Getters for Multiple Translations
```dart
final s = context.s;
Column(
  children: [
    Text(s.login),
    Text(s.email),
    Text(s.password),
  ],
)
```

### ✅ DO: Use Context Extension in Functions
```dart
String getMessage(BuildContext context) {
  return context.tr('welcome_message');
}
```

### ❌ DON'T: Create S instance multiple times
```dart
// Bad:
Text(S.of(context).login)
Text(S.of(context).email)
Text(S.of(context).password)

// Good:
final s = context.s;
Text(s.login)
Text(s.email)
Text(s.password)
```

## 🆕 Adding New Translation Keys

### Step 1: Add to JSON Files

**en.json**:
```json
{
  "welcome_message": "Welcome to our app!",
  "new_key": "New Translation"
}
```

**ar.json**:
```json
{
  "welcome_message": "مرحبا بك في تطبيقنا!",
  "new_key": "ترجمة جديدة"
}
```

### Step 2: (Optional) Add Getter to S Class

Edit `lib/core/utils/s.dart`:
```dart
class S {
  // Add new getter
  String get welcomeMessage => translate('welcome_message');
  String get newKey => translate('new_key');
}
```

### Step 3: Use It!
```dart
// With getter:
Text(context.s.welcomeMessage)

// Or with key:
Text('welcome_message'.tr(context))
```

## 🔍 IDE Support

All methods support:
- ✅ **Autocomplete** (especially S getters)
- ✅ **Type checking**
- ✅ **Go to definition**
- ✅ **Refactoring**

## 📱 Platform Support

Works on all platforms:
- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🎯 When to Use Which Method?

| Scenario | Recommended Method | Example |
|----------|-------------------|---------|
| Simple text | String extension | `'login'.tr(context)` |
| Multiple translations | S getters | `context.s.login` |
| Type safety needed | S getters | `context.s.email` |
| Dynamic keys | Context extension | `context.tr(dynamicKey)` |
| In functions | Context extension | `context.tr('key')` |

## ✨ Summary

### What You Get:
- ✅ **5 ways** to use translations
- ✅ **Type-safe** getters for common translations
- ✅ **Clean syntax**: `'key'.tr(context)`
- ✅ **Context utilities**: `context.isRTL`, `context.languageCode`
- ✅ **Full autocomplete** support
- ✅ **Backwards compatible** with existing code

### How to Start:
1. Import: `import 'package:fashion_ecommerce/core/utils/s.dart';`
2. Use: `'key'.tr(context)` or `context.s.key`
3. Enjoy! 🎉

---

**The S class is ready to use! Start translating with ease!** 🌍
