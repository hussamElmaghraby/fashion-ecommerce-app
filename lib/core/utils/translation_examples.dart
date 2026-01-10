import 'package:flutter/material.dart';
import 'package:fashion_ecommerce/core/utils/l10n.dart';
import 'package:fashion_ecommerce/core/widgets/custom_button.dart';
import 'package:fashion_ecommerce/core/widgets/custom_text_field.dart';


// ============================================================================
// METHOD 1: String Extension (Simplest)
// ============================================================================
class Example1_StringExtension extends StatelessWidget {
  const Example1_StringExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('login'.tr(context)),
        Text('email'.tr(context)),
        Text('password'.tr(context)),
        
        CustomButton(
          text: 'sign_in'.tr(context),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ============================================================================
// METHOD 2: Context Extension
// ============================================================================
class Example2_ContextExtension extends StatelessWidget {
  const Example2_ContextExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.tr('login')),
        Text(context.tr('email')),
        
        CustomButton(
          text: context.tr('sign_up'),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ============================================================================
// METHOD 3: S Getters (Best for Multiple Translations)
// ============================================================================
class Example3_SGetters extends StatelessWidget {
  const Example3_SGetters({super.key});

  @override
  Widget build(BuildContext context) {
    // Get S instance once - use it multiple times!
    final s = context.s;
    
    return Column(
      children: [
        // Type-safe, autocomplete works!
        Text(s.login),
        Text(s.email),
        Text(s.password),
        
        CustomButton(
          text: s.signIn,
          onPressed: () {},
        ),
        
        CustomButton(
          text: s.signUp,
          onPressed: () {},
        ),
      ],
    );
  }
}

// ============================================================================
// EXAMPLE 4: Login Form (Real Use Case)
// ============================================================================
class Example4_LoginForm extends StatelessWidget {
  const Example4_LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s; // Get S instance
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Title
          Text(
            s.loginToAccount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Email Field
          CustomTextField(
            label: s.email,
            hintText: s.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return s.fieldRequired;
              }
              if (!value.contains('@')) {
                return s.invalidEmail;
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Password Field
          CustomTextField(
            label: s.password,
            hintText: s.enterYourPassword,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return s.passwordRequired;
              }
              if (value.length < 6) {
                return s.passwordMinLength;
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Login Button
          CustomButton(
            text: s.login,
            onPressed: () {
              // Login logic
            },
          ),
          
          const SizedBox(height: 16),
          
          // Forgot Password
          TextButton(
            onPressed: () {},
            child: Text(s.forgotPassword),
          ),
          
          const SizedBox(height: 16),
          
          // Sign Up Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(s.dontHaveAccount),
              TextButton(
                onPressed: () {},
                child: Text(s.signUp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 5: Shopping Cart (Real Use Case)
// ============================================================================
class Example5_ShoppingCart extends StatelessWidget {
  const Example5_ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(s.myCart),
      ),
      body: Column(
        children: [
          // Cart items would go here
          Expanded(
            child: Center(
              child: Text('Cart Items'),
            ),
          ),
          
          // Total Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.total),
                    const Text('\$100.00'),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: s.checkout,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 6: Profile Settings (Real Use Case)
// ============================================================================
class Example6_ProfileSettings extends StatelessWidget {
  const Example6_ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(s.account),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(s.editProfile),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(s.addresses),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Text(s.paymentMethods),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(s.language),
            subtitle: Text(
              context.languageCode == 'ar' ? s.arabic : s.english,
            ),
            onTap: () {
              // Show language selector
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(s.notifications),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              s.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    final s = context.s;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              Navigator.pop(context);
            },
            child: Text(
              s.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// UTILITY EXAMPLES
// ============================================================================
class UtilityExamples {
  // Check current language
  static void checkLanguage(BuildContext context) {
    final currentLang = context.languageCode;
    // Returns 'en' or 'ar'
  }
  
  // Check if RTL
  static void checkRTL(BuildContext context) {
    if (context.isRTL) {
      // Layout is right-to-left (Arabic)
    } else {
      // Layout is left-to-right (English)
    }
  }
  
  // Dynamic translation
  static String getDynamicTranslation(BuildContext context, String key) {
    return context.tr(key);
  }
  
  // Show snackbar with translation
  static void showTranslatedSnackbar(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(key.tr(context))),
    );
  }
}

// ============================================================================
// QUICK REFERENCE
// ============================================================================
/*

5 WAYS TO TRANSLATE:

1. String Extension (Simplest):
   'login'.tr(context)

2. Context Extension:
   context.tr('login')

3. S Instance:
   S.of(context).translate('login')

4. S Getters (Type-safe, Autocomplete):
   context.s.login
   
5. S Property:
   final s = S(context);
   s.email

RECOMMENDED:
- Single translation: 'key'.tr(context)
- Multiple translations: final s = context.s; then use s.key

UTILITIES:
- context.languageCode  // 'en' or 'ar'
- context.isRTL         // true if Arabic
- context.s             // Get S instance

*/
