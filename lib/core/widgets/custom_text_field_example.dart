import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'custom_text_field.dart';

class CustomTextFieldExample extends StatefulWidget {
  const CustomTextFieldExample({super.key});

  @override
  State<CustomTextFieldExample> createState() => _CustomTextFieldExampleState();
}

class _CustomTextFieldExampleState extends State<CustomTextFieldExample> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _errorEmailController = TextEditingController(text: 'cody.fisher45@example');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _errorEmailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomTextField Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success State Example
            const Text(
              'Success State',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Full Name',
              hintText: 'Cody Fisher',
              controller: _nameController,
              showSuccessState: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hintText: 'cody.fisher45@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              showSuccessState: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              hintText: '56772809hjs',
              controller: _passwordController,
              obscureText: true,
              validator: _validatePassword,
              showSuccessState: true,
            ),
            
            const SizedBox(height: 40),
            
            // Error State Example
            const Text(
              'Error State',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hintText: 'Enter your email',
              controller: _errorEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              showSuccessState: true,
            ),
            
            const SizedBox(height: 40),
            
            // Normal State Example
            const Text(
              'Normal/Unfocused State',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Email',
              hintText: 'Enter your email address',
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            
            const SizedBox(height: 40),
            
            // Focused State (tap to see)
            const Text(
              'Focused State (tap field to see)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Email',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}
