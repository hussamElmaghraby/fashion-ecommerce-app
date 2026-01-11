import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

enum TextFieldState { normal, focused, error, success }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool showSuccessState;
  final String? errorText;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.showSuccessState = false,
    this.errorText,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = true;
  String? _currentError;
  bool _hasValidated = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (!_isFocused && widget.controller != null) {
        // Validate on focus lost
        _validateField();
      }
    });
  }

  void _validateField() {
    if (widget.validator != null && widget.controller != null) {
      final error = widget.validator!(widget.controller!.text);
      setState(() {
        _currentError = error;
        _hasValidated = true;
      });
    }
  }

  TextFieldState _getCurrentState() {
    // Error state has highest priority
    if (_currentError != null || widget.errorText != null) {
      return TextFieldState.error;
    }

    // Success state - show only when unfocused, validated, and passed
    if (widget.showSuccessState &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty &&
        _hasValidated &&
        _currentError == null &&
        !_isFocused) {
      return TextFieldState.success;
    }

    // Focused state
    if (_isFocused) {
      return TextFieldState.focused;
    }

    // Default state
    return TextFieldState.normal;
  }

  Color _getBorderColor() {
    switch (_getCurrentState()) {
      case TextFieldState.error:
        return const Color(0xFFDC2626); // Red
      case TextFieldState.success:
        return const Color(0xFF16A34A); // Green
      case TextFieldState.focused:
        return AppColors.textPrimary; // Black/Dark
      case TextFieldState.normal:
        return const Color(0xFFE5E7EB); // Light gray
    }
  }

  Widget? _getSuffixIcon() {
    // Password visibility toggle
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: const Color(0xFF9CA3AF),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    // State icons (error or success)
    final state = _getCurrentState();
    if (state == TextFieldState.error) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Assets.icons.errorValidationIcon.svg(),
      );
    } else if (state == TextFieldState.success) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Assets.icons.successValidationIcon.svg(),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentState = _getCurrentState();
    final borderColor = _getBorderColor();
    final displayError = _currentError ?? widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText && _obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF111827),
            height: 1.5,
          ),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            if (_currentError != null) {
              setState(() {
                _currentError = null;
              });
            }
            if (widget.showSuccessState && widget.validator != null) {
              _validateField();
            } else if (widget.showSuccessState) {
              setState(() {});
            }
          },
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9CA3AF),
              height: 1.5,
            ),
            suffixIcon: _getSuffixIcon(),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // Normal border
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: currentState == TextFieldState.normal ? 1.5 : 2,
              ),
            ),

            // Focused border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),

            // Error border
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),

            // Focused error border
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),

            // Disabled border
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB).withOpacity(0.5),
                width: 1.5,
              ),
            ),

            // Remove default error styling
            errorStyle: const TextStyle(height: 0, fontSize: 0),
          ),
        ),

        // Error message
        if (displayError != null && displayError.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: Assets.icons.errorValidationIcon.svg(
                  width: 14,
                  height: 14,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  displayError,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFDC2626),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
