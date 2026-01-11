import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/checkout/presentation/pages/address_page.dart';
import '../../features/checkout/presentation/pages/add_address_page.dart';
import '../../features/checkout/presentation/pages/payment_page.dart';
import '../../features/checkout/presentation/pages/add_payment_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String productDetails = '/product/:id';
  static const String checkout = '/checkout';
  static const String address = '/address';
  static const String addAddress = '/address/add';
  static const String payment = '/payment';
  static const String addPayment = '/payment/add';

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) {
          final tabIndex = state.extra as int? ?? 0;
          return MainNavigationPage(
            key: ValueKey('home_tab_$tabIndex'),
            initialTabIndex: tabIndex,
          );
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailsPage(productId: id);
        },
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: address,
        name: 'address',
        builder: (context, state) => const AddressPage(),
      ),
      GoRoute(
        path: addAddress,
        name: 'addAddress',
        builder: (context, state) {
          final addressId = state.extra as String?;
          return AddAddressPage(addressId: addressId);
        },
      ),
      GoRoute(
        path: payment,
        name: 'payment',
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(
        path: addPayment,
        name: 'addPayment',
        builder: (context, state) {
          final paymentId = state.extra as String?;
          return AddPaymentPage(paymentId: paymentId);
        },
      ),
    ],
  );
}
