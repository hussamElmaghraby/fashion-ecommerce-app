import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/s.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 0; // 0: Email, 1: Code, 2: New Password, 3: Success

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authStateProvider.notifier)
        .resetPassword(_emailController.text.trim());

    final authState = ref.read(authStateProvider);
    if (authState.error == null) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _verifyCode() {
    if (_codeController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 4-digit code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // In a real app, verify the code with backend
    setState(() {
      _currentStep = 2;
    });
  }

  void _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // In a real app, update password with backend
    setState(() {
      _currentStep = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen to errors
    ref.listen(authStateProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(L10nKeys.resetPassword.tr(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Form(key: _formKey, child: _buildCurrentStep(authState)),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AuthState authState) {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep(authState);
      case 1:
        return _buildCodeStep(authState);
      case 2:
        return _buildNewPasswordStep(authState);
      case 3:
        return _buildSuccessStep();
      default:
        return _buildEmailStep(authState);
    }
  }

  Widget _buildEmailStep(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nKeys.resetPassword,
          style: const TextStyle(
            fontSize: AppDimensions.fontDisplay,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Text(
          L10nKeys.resetPasswordDesc,
          style: const TextStyle(
            fontSize: AppDimensions.fontLG,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomTextField(
          label: L10nKeys.email,
          hintText: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return L10nKeys.fieldRequired;
            }
            if (!EmailValidator.validate(value)) {
              return L10nKeys.invalidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomButton(
          text: L10nKeys.sendResetLink,
          onPressed: _sendResetLink,
          isLoading: authState.isLoading,
        ),
      ],
    );
  }

  Widget _buildCodeStep(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nKeys.enterDigitCode,
          style: const TextStyle(
            fontSize: AppDimensions.fontDisplay,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomTextField(
          label: L10nKeys.verificationCode,
          hintText: '0000',
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 4,
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _sendResetLink,
            child: Text(L10nKeys.resendCode.tr(context)),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomButton(text: 'Verify Code', onPressed: _verifyCode),
      ],
    );
  }

  Widget _buildNewPasswordStep(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nKeys.newPassword,
          style: const TextStyle(
            fontSize: AppDimensions.fontDisplay,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomTextField(
          label: L10nKeys.newPassword,
          hintText: 'Enter new password',
          controller: _newPasswordController,
          obscureText: _obscurePassword,
          showSuccessState: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        CustomTextField(
          label: L10nKeys.confirmNewPassword,
          hintText: 'Confirm new password',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          showSuccessState: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return L10nKeys.fieldRequired;
            }
            if (value != _newPasswordController.text) {
              return L10nKeys.passwordsDoNotMatch;
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        CustomButton(text: 'Update Password', onPressed: _updatePassword),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 100,
          color: AppColors.success,
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        Text(
          L10nKeys.passwordChangedSuccessfully,
          style: const TextStyle(
            fontSize: AppDimensions.fontHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingXXL),
        CustomButton(
          text: 'Back to Login',
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }
}
