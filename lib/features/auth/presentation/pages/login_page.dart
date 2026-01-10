import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
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

  void _login() {
    if (!_formKey.currentState!.validate()) return;

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
                  S.login.tr(context),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontDisplay,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  S.loginToAccount.tr(context),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontLG,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Email Field
                CustomTextField(
                  label: S.email.tr(context),
                  hintText: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  showSuccessState: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.fieldRequired.tr(context);
                    }
                    if (!EmailValidator.validate(value)) {
                      return S.invalidEmail.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMD),

                // Password Field
                CustomTextField(
                  label: S.password.tr(context),
                  hintText: 'Enter your password',
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
                          S.rememberMe.tr(context),
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
                        S.forgotPassword.tr(context),
                        style: const TextStyle(fontSize: AppDimensions.fontMD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Login Button
                CustomButton(
                  text: S.login.tr(context),
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
                        S.orContinueWith.tr(context),
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

                // Social Login Buttons (Placeholder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.facebook, () {}),
                    const SizedBox(width: AppDimensions.paddingMD),
                    _buildSocialButton(Icons.g_mobiledata, () {}),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.dontHaveAccount.tr(context),
                      style: const TextStyle(
                        fontSize: AppDimensions.fontMD,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        S.signUp.tr(context),
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

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Icon(icon, size: 32),
      ),
    );
  }
}
