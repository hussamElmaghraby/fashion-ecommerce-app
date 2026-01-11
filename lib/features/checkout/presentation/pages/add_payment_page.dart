import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/l10n.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/models/payment_method_model.dart';
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

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    final paymentMethod = PaymentMethodModel(
      id: widget.paymentId ?? const Uuid().v4(),
      type: PaymentType.card,
      cardNumber: _cardNumberController.text.trim(),
      cardHolderName: _cardHolderController.text.trim(),
      expiryDate: _expiryDateController.text.trim(),
      isDefault: _isDefault,
    );

    await ref.read(paymentProvider.notifier).savePaymentMethod(paymentMethod);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10nKeys.cardSaved.tr(context)),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paymentId == null
              ? L10nKeys.addNewCard.tr(context)
              : L10nKeys.editCard.tr(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          children: [
            CustomTextField(
              label: L10nKeys.cardNumber.tr(context),
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10nKeys.fieldRequired.tr(context);
                }
                if (value.length < 16) {
                  return 'Invalid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: L10nKeys.cardHolderName.tr(context),
              controller: _cardHolderController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10nKeys.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: L10nKeys.expiryDate.tr(context),
                    controller: _expiryDateController,
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return L10nKeys.fieldRequired.tr(context);
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: CustomTextField(
                    label: L10nKeys.cvv.tr(context),
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return L10nKeys.fieldRequired.tr(context);
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
              title: Text(L10nKeys.setAsDefault.tr(context)),
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
              text: L10nKeys.saveCard.tr(context),
              onPressed: _savePaymentMethod,
            ),
          ],
        ),
      ),
    );
  }
}
