import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/l10n.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isValid =
        email.isNotEmpty &&
        EmailValidator.validate(email) &&
        password.isNotEmpty &&
        password.length >= 6;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email') ?? '';

    if (rememberMe && savedEmail.isNotEmpty) {
      setState(() {
        _rememberMe = rememberMe;
        _emailController.text = savedEmail;
      });
    }
  }

  Future<void> _saveRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('saved_email', _emailController.text.trim());
    } else {
      await prefs.remove('remember_me');
      await prefs.remove('saved_email');
    }
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    await _saveRememberMe();

    ref
        .read(authStateProvider.notifier)
        .login(
          _emailController.text.trim(),
          _passwordController.text,
          _rememberMe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen to auth state changes
    ref.listen(authStateProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }

      if (next.isAuthenticated && !next.isLoading) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  L10nKeys.login.tr(context),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontDisplay,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  L10nKeys.loginToAccount.tr(context),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontLG,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Email Field
                CustomTextField(
                  label: L10nKeys.email.tr(context),
                  hintText: L10nKeys.enterYourEmail.tr(context),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  showSuccessState: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return L10nKeys.fieldRequired.tr(context);
                    }
                    if (!EmailValidator.validate(value)) {
                      return L10nKeys.invalidEmail.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMD),

                // Password Field
                CustomTextField(
                  label: L10nKeys.password.tr(context),
                  hintText: L10nKeys.enterYourPassword.tr(context),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  showSuccessState: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required'.tr(context);
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters'.tr(
                        context,
                      );
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: AppDimensions.paddingMD),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(
                          L10nKeys.rememberMe.tr(context),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontMD,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push('/reset-password'),
                      child: Text(
                        L10nKeys.forgotPassword.tr(context),
                        style: const TextStyle(fontSize: AppDimensions.fontMD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Login Button
                CustomButton(
                  text: L10nKeys.login.tr(context),
                  onPressed: _isFormValid ? _login : null,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMD,
                      ),
                      child: Text(
                        L10nKeys.orContinueWith.tr(context),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontMD,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Social Login Buttons
                _buildGoogleButton(),
                const SizedBox(height: AppDimensions.paddingSM),
                _buildFacebookButton(),
                const SizedBox(height: AppDimensions.paddingXL),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      L10nKeys.dontHaveAccount.tr(context),
                      style: const TextStyle(
                        fontSize: AppDimensions.fontMD,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        L10nKeys.signUp.tr(context),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontMD,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Implement Google Sign In
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        icon: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        label: Text(
          L10nKeys.loginWithGoogle.tr(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement Facebook Sign In
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1877F2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        icon: const Icon(
          Icons.facebook,
          size: 24,
          color: Colors.white,
        ),
        label: Text(
          L10nKeys.loginWithFacebook.tr(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
