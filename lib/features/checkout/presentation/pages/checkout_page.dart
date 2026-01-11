import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/l10n.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../providers/payment_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String? _selectedAddressId;
  String? _selectedPaymentId;
  final _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10nKeys.pleaseSelectAddress.tr(context)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedPaymentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10nKeys.pleaseSelectPayment.tr(context)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Place order logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10nKeys.orderPlaced.tr(context)),
        backgroundColor: AppColors.success,
      ),
    );

    // Clear cart and navigate to home tab
    ref.read(cartProvider.notifier).clearCart();
    context.go('/home', extra: 0);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final addressesAsync = ref.watch(addressesProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(L10nKeys.checkout.tr(context))),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        children: [
          // Delivery Address Section
          Text(
            L10nKeys.deliveryAddress.tr(context),
            style: const TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          addressesAsync.when(
            data: (addresses) {
              if (addresses.isEmpty) {
                return Card(
                  child: ListTile(
                    title: const Text('No addresses saved'),
                    trailing: TextButton(
                      onPressed: () => context.push('/address/add'),
                      child: Text(L10nKeys.addNew.tr(context)),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...addresses.map((address) {
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.paddingSM,
                      ),
                      child: RadioListTile<String>(
                        title: Text(address.fullName),
                        subtitle: Text(
                          '${address.streetAddress}, ${address.city}',
                        ),
                        value: address.id,
                        groupValue: _selectedAddressId,
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressId = value;
                          });
                        },
                        secondary: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            ref
                                .read(addressProvider.notifier)
                                .deleteAddress(address.id);
                            if (_selectedAddressId == address.id) {
                              setState(() {
                                _selectedAddressId = null;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: () => context.push('/address/add'),
                    icon: const Icon(Icons.add),
                    label: Text(L10nKeys.addNew.tr(context)),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // Payment Method Section
          Text(
            L10nKeys.paymentMethod.tr(context),
            style: const TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          paymentMethodsAsync.when(
            data: (methods) {
              if (methods.isEmpty) {
                return Card(
                  child: ListTile(
                    title: const Text('No payment methods saved'),
                    trailing: TextButton(
                      onPressed: () => context.push('/payment/add'),
                      child: Text(L10nKeys.addNew.tr(context)),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...methods.map((method) {
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.paddingSM,
                      ),
                      child: RadioListTile<String>(
                        title: Text(method.cardHolderName ?? 'Card'),
                        subtitle: Text(
                          '**** **** **** ${method.cardNumber?.substring(method.cardNumber!.length - 4) ?? '****'}',
                        ),
                        value: method.id,
                        groupValue: _selectedPaymentId,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentId = value;
                          });
                        },
                        secondary: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            ref
                                .read(paymentProvider.notifier)
                                .deletePaymentMethod(method.id);
                            if (_selectedPaymentId == method.id) {
                              setState(() {
                                _selectedPaymentId = null;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: () => context.push('/payment/add'),
                    icon: const Icon(Icons.add),
                    label: Text(L10nKeys.addNew.tr(context)),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // Promo Code Section
          Text(
            L10nKeys.promoCode.tr(context),
            style: const TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoCodeController,
                  decoration: InputDecoration(
                    hintText: L10nKeys.enterPromoCode.tr(context),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              SizedBox(
                height: 56,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply promo code logic
                  },
                  child: Text(L10nKeys.apply.tr(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),

          // Order Summary
          Text(
            L10nKeys.orderSummary.tr(context),
            style: const TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              child: Column(
                children: [
                  _buildSummaryRow(
                    L10nKeys.subtotal.tr(context),
                    '\$${cartState.subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppDimensions.paddingSM),
                  _buildSummaryRow(
                    L10nKeys.tax.tr(context),
                    '\$${cartState.tax.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppDimensions.paddingSM),
                  _buildSummaryRow(
                    L10nKeys.shipping.tr(context),
                    '\$${cartState.shipping.toStringAsFixed(2)}',
                  ),
                  const Divider(height: AppDimensions.paddingLG),
                  _buildSummaryRow(
                    L10nKeys.total.tr(context),
                    '\$${cartState.total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          // Place Order Button
          CustomButton(
            text: L10nKeys.placeOrder.tr(context),
            onPressed: _placeOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? AppDimensions.fontLG : AppDimensions.fontMD,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? AppDimensions.fontLG : AppDimensions.fontMD,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
