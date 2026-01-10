import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/payment_provider.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(S.paymentMethods.tr(context))),
      body: paymentMethodsAsync.when(
        data: (methods) {
          if (methods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.credit_card_off,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  const Text(
                    'No payment methods saved',
                    style: TextStyle(
                      fontSize: AppDimensions.fontLG,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  CustomButton(
                    text: S.addNewCard.tr(context),
                    onPressed: () => context.push('/payment/add'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text(method.cardHolderName ?? 'Card'),
                  subtitle: Text(
                    '**** **** **** ${method.cardNumber?.substring(method.cardNumber!.length - 4) ?? '****'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            context.push('/payment/edit/${method.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () {
                          ref
                              .read(paymentProvider.notifier)
                              .deletePaymentMethod(method.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/payment/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
