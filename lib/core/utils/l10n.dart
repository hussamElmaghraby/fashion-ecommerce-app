import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// L10n class - Localization helper
/// Usage: 'key'.tr(context) or L10n.of(context).translate('key')
class L10n {
  final BuildContext context;

  L10n(this.context);

  static L10n of(BuildContext context) => L10n(context);

  String translate(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  String get currentLanguage {
    return AppLocalizations.of(context)?.locale.languageCode ?? 'en';
  }

  bool get isRTL {
    return AppLocalizations.of(context)?.isRTL ?? false;
  }

  // Common translations as getters for convenience
  String get appName => translate('app_name');
  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('get_started');
  String get onboardingTitle1 => translate('onboarding_title_1');
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
  String get loginWithGoogle => translate('login_with_google');
  String get loginWithFacebook => translate('login_with_facebook');
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
  String get categories => translate('categories');
  String get allCategories => translate('all_categories');
  String get newArrivals => translate('new_arrivals');
  String get trending => translate('trending');
  String get saleItems => translate('sale_items');
  String get productDetails => translate('product_details');
  String get selectSize => translate('select_size');
  String get selectColor => translate('select_color');
  String get quantity => translate('quantity');
  String get buyNow => translate('buy_now');
  String get description => translate('description');
  String get reviews => translate('reviews');
  String get inStock => translate('in_stock');
  String get outOfStock => translate('out_of_stock');
  String get cartEmpty => translate('cart_empty');
  String get cartEmptySubtitle => translate('cart_empty_subtitle');
  String get yourCartIsEmpty => translate('your_cart_is_empty');
  String get goToCheckout => translate('go_to_checkout');
  String get subTotal => translate('sub_total');
  String get vat => translate('vat');
  String get shippingFee => translate('shipping_fee');
  String get home => translate('home');
  String get search => translate('search');
  String get cart => translate('cart');
  String get card => translate('card');
  String get favorites => translate('favorites');
  String get saved => translate('saved');
  String get noFavoritesYet => translate('no_favorites_yet');
  String get startAddingFavorites => translate('start_adding_favorites');
  String get browseProducts => translate('browse_products');
  String get startShopping => translate('start_shopping');
  String get removeItem => translate('remove_item');
  String get updateQuantity => translate('update_quantity');
  String get subtotal => translate('subtotal');
  String get shipping => translate('shipping');
  String get tax => translate('tax');
  String get proceedToCheckout => translate('proceed_to_checkout');
  String get orderSummary => translate('order_summary');
  String get applyCoupon => translate('apply_coupon');
  String get couponCode => translate('coupon_code');
  String get apply => translate('apply');
  String get items => translate('items');
  String get item => translate('item');
  String get clearAll => translate('clear_all');
  String get clearAllFavorites => translate('clear_all_favorites');
  String get removeAllFavoritesConfirm => translate('remove_all_favorites_confirm');
  String get searchProductsHint => translate('search_products_hint');
  String get noProductsAvailable => translate('no_products_available');
  String get noProductsFound => translate('no_products_found');
  String get addedToCart => translate('added_to_cart');
  String get welcome => translate('welcome');
  String get guestUser => translate('guest_user');
  String get notLoggedIn => translate('not_logged_in');
  String get settings => translate('settings');
  String get orders => translate('orders');
  String get myOrders => translate('my_orders');
  String get wishlist => translate('wishlist');
  String get changeLanguage => translate('change_language');
  String get rate => translate('rate');
  String get deliveryAddress => translate('delivery_address');
  String get paymentMethod => translate('payment_method');
  String get address => translate('address');
  String get addNewAddress => translate('add_new_address');
  String get editAddress => translate('edit_address');
  String get saveAddress => translate('save_address');
  String get streetAddress => translate('street_address');
  String get city => translate('city');
  String get state => translate('state');
  String get zipCode => translate('zip_code');
  String get country => translate('country');
  String get phoneNumber => translate('phone_number');
  String get setAsDefault => translate('set_as_default');
  String get payment => translate('payment');
  String get selectPaymentMethod => translate('select_payment_method');
  String get creditCard => translate('credit_card');
  String get debitCard => translate('debit_card');
  String get cash => translate('cash');
  String get addNewCard => translate('add_new_card');
  String get cardNumber => translate('card_number');
  String get cardHolderName => translate('card_holder_name');
  String get expiryDate => translate('expiry_date');
  String get cvv => translate('cvv');
  String get saveCard => translate('save_card');
  String get invalidPhoneNumber => translate('invalid_phone_number');
  String get invalidCardNumber => translate('invalid_card_number');
  String get invalidCvv => translate('invalid_cvv');
  String get invalidExpiryDate => translate('invalid_expiry_date');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get tryAgain => translate('try_again');
  String get noInternetConnection => translate('no_internet_connection');
  String get somethingWentWrong => translate('something_went_wrong');
  String get editCard => translate('edit_card');
  String get addNew => translate('add_new');
  String get pleaseSelectAddress => translate('please_select_address');
  String get pleaseSelectPayment => translate('please_select_payment');
  String get orderPlaced => translate('order_placed');
  String get promoCode => translate('promo_code');
  String get enterPromoCode => translate('enter_promo_code');
}

extension StringTranslation on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}

extension BuildContextTranslation on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }

  L10n get s => L10n(this);

  String get languageCode {
    return AppLocalizations.of(this)?.locale.languageCode ?? 'en';
  }

  bool get isRTL {
    return AppLocalizations.of(this)?.isRTL ?? false;
  }
}
