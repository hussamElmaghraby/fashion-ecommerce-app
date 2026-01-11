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
import '../../../../data/models/address_model.dart';
import '../providers/address_provider.dart';

class AddAddressPage extends ConsumerStatefulWidget {
  final String? addressId;

  const AddAddressPage({super.key, this.addressId});

  @override
  ConsumerState<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends ConsumerState<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      id: widget.addressId ?? const Uuid().v4(),
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      streetAddress: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      country: 'USA',
      isDefault: _isDefault,
    );

    await ref.read(addressProvider.notifier).saveAddress(address);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10nKeys.addressSaved.tr(context)),
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
          widget.addressId == null
              ? L10nKeys.addNewAddress.tr(context)
              : L10nKeys.editAddress.tr(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          children: [
            CustomTextField(
              label: L10nKeys.fullName.tr(context),
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10nKeys.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: L10nKeys.phoneNumber.tr(context),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10nKeys.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: L10nKeys.streetAddress.tr(context),
              controller: _streetController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10nKeys.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: L10nKeys.city.tr(context),
              controller: _cityController,
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
                    label: L10nKeys.state.tr(context),
                    controller: _stateController,
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
                    label: L10nKeys.zipCode.tr(context),
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return L10nKeys.fieldRequired.tr(context);
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
              text: L10nKeys.saveAddress.tr(context),
              onPressed: _saveAddress,
            ),
          ],
        ),
      ),
    );
  }
}
