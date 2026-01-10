import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/payment_provider.dart';

class AddPaymentPage extends ConsumerStatefulWidget {
  final String? paymentId;

  const AddPaymentPage({super.key, this.paymentId});

  @override
  ConsumerState<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends ConsumerState<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _savePaymentMethod() {
    if (!_formKey.currentState!.validate()) return;

    // Save payment method logic here
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paymentId == null
              ? S.addNewCard.tr(context)
              : S.editCard.tr(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          children: [
            CustomTextField(
              label: S.cardNumber.tr(context),
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.fieldRequired.tr(context);
                }
                if (value.length < 16) {
                  return 'Invalid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: S.cardHolderName.tr(context),
              controller: _cardHolderController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: S.expiryDate.tr(context),
                    controller: _expiryDateController,
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.fieldRequired.tr(context);
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: CustomTextField(
                    label: S.cvv.tr(context),
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.fieldRequired.tr(context);
                      }
                      if (value.length < 3) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CheckboxListTile(
              title: Text(S.setAsDefault.tr(context)),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            CustomButton(
              text: S.saveCard.tr(context),
              onPressed: _savePaymentMethod,
            ),
          ],
        ),
      ),
    );
  }
}
