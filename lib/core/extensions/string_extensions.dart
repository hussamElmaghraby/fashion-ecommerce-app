import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

/// Extension to get localized strings
/// Usage: 'login'.tr(context) or context.tr('login')
extension LocalizedString on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}

/// Extension on BuildContext for easier access
extension LocalizationContext on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }

  AppLocalizations? get loc => AppLocalizations.of(this);
}

/// App Strings - Direct localization keys
/// Usage: S.login.tr(context) or context.tr(S.login)
class S {
  S._();

  // App
  static const String appName = 'app_name';

  // Onboarding
  static const String onboardingTitle1 = 'onboarding_title_1';
  static const String skip = 'skip';
  static const String next = 'next';
  static const String getStarted = 'get_started';

  // Auth - Sign Up
  static const String signUp = 'sign_up';
  static const String createAccount = 'create_account';
  static const String fullName = 'full_name';
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'confirm_password';
  static const String agreeTerms = 'agree_terms';
  static const String alreadyHaveAccount = 'already_have_account';
  static const String signIn = 'sign_in';

  // Auth - Login
  static const String login = 'login';
  static const String loginToAccount = 'login_to_account';
  static const String rememberMe = 'remember_me';
  static const String forgotPassword = 'forgot_password';
  static const String dontHaveAccount = 'dont_have_account';
  static const String orContinueWith = 'or_continue_with';

  // Auth - Reset Password
  static const String resetPassword = 'reset_password';
  static const String enterEmail = 'enter_your_email';
  static const String sendResetLink = 'send_reset_link';
  static const String resetPasswordDesc = 'reset_password_desc';
  static const String enterDigitCode = 'enter_digit_code';
  static const String verificationCode = 'verification_code';
  static const String resendCode = 'resend_code';
  static const String newPassword = 'new_password';
  static const String confirmNewPassword = 'confirm_new_password';
  static const String passwordChangedSuccessfully =
      'password_changed_successfully';

  // Home/Products
  static const String discover = 'discover';
  static const String searchProducts = 'search_products';
  static const String categories = 'categories';
  static const String allCategories = 'all_categories';
  static const String newArrivals = 'new_arrivals';
  static const String trending = 'trending';
  static const String saleItems = 'sale_items';

  // Product Details
  static const String productDetails = 'product_details';
  static const String selectSize = 'select_size';
  static const String selectColor = 'select_color';
  static const String quantity = 'quantity';
  static const String addToCart = 'add_to_cart';
  static const String buyNow = 'buy_now';
  static const String description = 'description';
  static const String reviews = 'reviews';
  static const String inStock = 'in_stock';
  static const String outOfStock = 'out_of_stock';

  // Cart
  static const String myCart = 'my_cart';
  static const String cartEmpty = 'cart_empty';
  static const String startShopping = 'start_shopping';
  static const String removeItem = 'remove_item';
  static const String updateQuantity = 'update_quantity';
  static const String subtotal = 'subtotal';
  static const String shipping = 'shipping';
  static const String tax = 'tax';
  static const String total = 'total';
  static const String proceedToCheckout = 'proceed_to_checkout';

  // Checkout
  static const String checkout = 'checkout';
  static const String orderSummary = 'order_summary';
  static const String applyCoupon = 'apply_coupon';
  static const String couponCode = 'coupon_code';
  static const String apply = 'apply';
  static const String deliveryAddress = 'delivery_address';
  static const String paymentMethod = 'payment_method';
  static const String placeOrder = 'place_order';

  // Address
  static const String address = 'address';
  static const String addNewAddress = 'add_new_address';
  static const String editAddress = 'edit_address';
  static const String saveAddress = 'save_address';
  static const String streetAddress = 'street_address';
  static const String city = 'city';
  static const String state = 'state';
  static const String zipCode = 'zip_code';
  static const String country = 'country';
  static const String phoneNumber = 'phone_number';
  static const String setAsDefault = 'set_as_default';

  // Payment
  static const String payment = 'payment';
  static const String selectPaymentMethod = 'select_payment_method';
  static const String creditCard = 'credit_card';
  static const String debitCard = 'debit_card';
  static const String cash = 'cash';
  static const String addNewCard = 'add_new_card';
  static const String cardNumber = 'card_number';
  static const String cardHolderName = 'card_holder_name';
  static const String expiryDate = 'expiry_date';
  static const String cvv = 'cvv';
  static const String saveCard = 'save_card';
  static const String editCard = 'edit_card';
  static const String addNew = 'add_new';
  static const String pleaseSelectAddress = 'please_select_address';
  static const String pleaseSelectPayment = 'please_select_payment';
  static const String orderPlaced = 'order_placed';
  static const String promoCode = 'promo_code';
  static const String enterPromoCode = 'enter_promo_code';

  // Validation
  static const String fieldRequired = 'field_required';
  static const String invalidEmail = 'invalid_email';
  static const String passwordTooShort = 'password_too_short';
  static const String passwordsDoNotMatch = 'passwords_do_not_match';
  static const String invalidPhoneNumber = 'invalid_phone_number';
  static const String invalidCardNumber = 'invalid_card_number';
  static const String invalidCVV = 'invalid_cvv';
  static const String invalidExpiryDate = 'invalid_expiry_date';

  // General
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String ok = 'ok';
  static const String yes = 'yes';
  static const String no = 'no';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String tryAgain = 'try_again';
  static const String noInternetConnection = 'no_internet_connection';
  static const String somethingWentWrong = 'something_went_wrong';

  // Additional
  static const String enterYourEmail = 'enter_your_email';
  static const String enterYourPassword = 'enter_your_password';
  static const String passwordRequired = 'password_required';
  static const String passwordMinLength = 'password_min_length';
  static const String enterYourFullName = 'enter_your_full_name';
  static const String confirmYourPassword = 'confirm_your_password';
  static const String selectLanguage = 'select_language';
  static const String english = 'english';
  static const String arabic = 'arabic';
  static const String account = 'account';
  static const String editProfile = 'edit_profile';
  static const String addresses = 'addresses';
  static const String paymentMethods = 'payment_methods';
  static const String preferences = 'preferences';
  static const String notifications = 'notifications';
  static const String language = 'language';
  static const String darkMode = 'dark_mode';
  static const String support = 'support';
  static const String helpCenter = 'help_center';
  static const String privacyPolicy = 'privacy_policy';
  static const String termsConditions = 'terms_conditions';
  static const String logout = 'logout';
  static const String logoutConfirm = 'logout_confirm';
  static const String enterNewPassword = 'enter_new_password';
  static const String confirmNewPasswordHint = 'confirm_new_password_hint';
}
