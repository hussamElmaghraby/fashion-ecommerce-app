import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// S class - Simplified translations
/// Usage: 'key'.tr(context) or S.of(context).translate('key')
class S {
  final BuildContext context;

  S(this.context);

  /// Get S instance from context
  static S of(BuildContext context) => S(context);

  /// Translate a key
  String translate(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  /// Get current locale
  String get currentLanguage {
    return AppLocalizations.of(context)?.locale.languageCode ?? 'en';
  }

  /// Check if current language is RTL
  bool get isRTL {
    return AppLocalizations.of(context)?.isRTL ?? false;
  }

  // Common translations as getters for convenience
  String get appName => translate('app_name');
  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('get_started');
  String get signUp => translate('sign_up');
  String get signIn => translate('sign_in');
  String get login => translate('login');
  String get email => translate('email');
  String get password => translate('password');
  String get rememberMe => translate('remember_me');
  String get forgotPassword => translate('forgot_password');
  String get discover => translate('discover');
  String get searchProducts => translate('search_products');
  String get addToCart => translate('add_to_cart');
  String get myCart => translate('my_cart');
  String get checkout => translate('checkout');
  String get total => translate('total');
  String get placeOrder => translate('place_order');
  String get enterYourEmail => translate('enter_your_email');
  String get enterYourPassword => translate('enter_your_password');
  String get passwordRequired => translate('password_required');
  String get passwordMinLength => translate('password_min_length');
  String get fieldRequired => translate('field_required');
  String get invalidEmail => translate('invalid_email');
  String get loginToAccount => translate('login_to_account');
  String get orContinueWith => translate('or_continue_with');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get fullName => translate('full_name');
  String get enterYourFullName => translate('enter_your_full_name');
  String get confirmPassword => translate('confirm_password');
  String get confirmYourPassword => translate('confirm_your_password');
  String get createAccount => translate('create_account');
  String get agreeTerms => translate('agree_terms');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get account => translate('account');
  String get editProfile => translate('edit_profile');
  String get addresses => translate('addresses');
  String get paymentMethods => translate('payment_methods');
  String get preferences => translate('preferences');
  String get notifications => translate('notifications');
  String get language => translate('language');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get darkMode => translate('dark_mode');
  String get support => translate('support');
  String get helpCenter => translate('help_center');
  String get privacyPolicy => translate('privacy_policy');
  String get termsConditions => translate('terms_conditions');
  String get logout => translate('logout');
  String get logoutConfirm => translate('logout_confirm');
  String get cancel => translate('cancel');
  String get selectLanguage => translate('select_language');
  String get resetPassword => translate('reset_password');
  String get resetPasswordDesc => translate('reset_password_desc');
  String get sendResetLink => translate('send_reset_link');
  String get enterDigitCode => translate('enter_digit_code');
  String get verificationCode => translate('verification_code');
  String get resendCode => translate('resend_code');
  String get newPassword => translate('new_password');
  String get enterNewPassword => translate('enter_new_password');
  String get confirmNewPassword => translate('confirm_new_password');
  String get confirmNewPasswordHint => translate('confirm_new_password_hint');
  String get passwordChangedSuccessfully => translate('password_changed_successfully');
  String get passwordTooShort => translate('password_too_short');
}

/// Extension on String for easy translation
/// Usage: 'key'.tr(context)
extension StringTranslation on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}

/// Extension on BuildContext for easy access
/// Usage: context.tr('key') or context.s
extension BuildContextTranslation on BuildContext {
  /// Translate a key
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }

  /// Get S instance
  S get s => S(this);

  /// Get current language code
  String get languageCode {
    return AppLocalizations.of(this)?.locale.languageCode ?? 'en';
  }

  /// Check if RTL
  bool get isRTL {
    return AppLocalizations.of(this)?.isRTL ?? false;
  }
}
