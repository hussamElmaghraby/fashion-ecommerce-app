import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    // Save address logic here
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.addressId == null
              ? S.addNewAddress.tr(context)
              : S.editAddress.tr(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          children: [
            CustomTextField(
              label: S.fullName.tr(context),
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: S.phoneNumber.tr(context),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: S.streetAddress.tr(context),
              controller: _streetController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.fieldRequired.tr(context);
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            CustomTextField(
              label: S.city.tr(context),
              controller: _cityController,
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
                    label: S.state.tr(context),
                    controller: _stateController,
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
                    label: S.zipCode.tr(context),
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.fieldRequired.tr(context);
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
              text: S.saveAddress.tr(context),
              onPressed: _saveAddress,
            ),
          ],
        ),
      ),
    );
  }
}
