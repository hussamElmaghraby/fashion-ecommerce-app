import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/core/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField Widget Tests', () {
    testWidgets('should render text field with label', (tester) async {
      // Arrange
      const label = 'Test Label';
      const hintText = 'Test Hint';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: label,
              hintText: hintText,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should update text when typing', (tester) async {
      // Arrange
      final controller = TextEditingController();
      const testText = 'Test Input';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), testText);

      // Assert
      expect(controller.text, testText);
    });

    testWidgets('should show validation error', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      const errorMessage = 'This field is required';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                hintText: 'Enter text',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return errorMessage;
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should render with obscure text when specified', (tester) async {
      // Arrange
      const hintText = 'Password';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hintText: hintText,
              obscureText: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));

      // Assert
      expect(textField.obscureText, true);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      // Arrange
      String? changedValue;
      const testText = 'Test';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hintText: 'Enter text',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), testText);

      // Assert
      expect(changedValue, testText);
    });
  });
}
